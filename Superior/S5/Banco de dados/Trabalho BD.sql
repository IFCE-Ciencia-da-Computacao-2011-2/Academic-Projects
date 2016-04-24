DROP SCHEMA IF EXISTS efeito CASCADE;
CREATE SCHEMA efeito;

DROP SCHEMA IF EXISTS instancia CASCADE;
CREATE SCHEMA instancia;

DROP SCHEMA IF EXISTS dicionario_dados CASCADE;
CREATE SCHEMA dicionario_dados;

-------------------------------------------------------------------------------------
-- Esquema dicionario_dados
-------------------------------------------------------------------------------------
-- Material de apoio sobre catálogo do Postgres: http://www.inf.puc-rio.br/~postgresql/conteudo/publicationsfiles/monteiro-reltec-metadados.PDF

-- http://dba.stackexchange.com/questions/30061/how-do-i-list-all-tables-in-all-schemas-owned-by-the-current-user-in-postgresql
DROP view IF EXISTS dicionario_dados.relacao;

CREATE OR REPLACE VIEW dicionario_dados.relacao AS
	SELECT pg_namespace.nspname AS namespace,
	       RelName as tabela,
	       pg_catalog.obj_description(pg_class.oid, 'pg_class') AS comentario,
	       
	       case pg_class.relkind
		 when 'r' then 'TABLE'
		 when 'i' then 'INDEX'
		 when 'S' then 'SEQUENCE'
		 when 'v' then 'VIEW'
		 when 'c' then 'TYPE'
		 else pg_class.relkind::text
	       end as tipo/**/

	 FROM pg_class
	 JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace

	 WHERE pg_class.relkind NOT IN ('i', 'S')
	   AND pg_namespace.nspname IN ('efeito', 'instancia')

	   ORDER BY namespace, tipo;

DROP view IF EXISTS dicionario_dados.atributo;


CREATE OR REPLACE VIEW dicionario_dados.atributo AS

-- http://blog.delogic.com.br/criar-dicionario-de-dados-em-postgres/
SELECT nsp.nspname AS Namespace,
       tbl.relname AS Tabela,
       atr.attname AS Coluna,
       pg_catalog.format_type(atr.atttypid,atr.atttypmod) AS Tipo,

       CASE WHEN (atr.atttypmod > 0)
            THEN atr.atttypmod-4 END AS Tamanho,
       CASE WHEN atr.attnotnull = 't'
            THEN 'Sim' ELSE '-' END AS Obrigatorio,

	coalesce(
		(select 'Sim' || ''
		   from pg_constraint ct
		  where ct.contype = 'p'
		    and ct.conrelid = tbl.oid
		    AND atr.attnum = ANY (ct.conkey)),
		 '-')
	AS Chave_Primaria,
	coalesce(
		(select 'Ref: ' || nsp.nspname || '.' || g.relname
		   from pg_class g
		  inner join pg_constraint ct on g.oid = ct.confrelid
		  where ct.conrelid = tbl.oid
		    AND atr.attnum = ANY (ct.conkey)), '-')
	as Chave_Estrangeira,

    coalesce(
        (select 'Sim' || ''
           from pg_constraint ct
          where ct.contype = 'u'
            and ct.conrelid = tbl.oid
            AND atr.attnum = ANY (ct.conkey)), '-')
    AS Valor_Unico,

    pg_catalog.col_description(atr.attrelid, atr.attnum) AS comentario

  FROM pg_attribute atr

 INNER JOIN pg_class tbl ON tbl.oid = atr.attrelid
  LEFT JOIN pg_attrdef atrdef ON atrdef.adrelid = tbl.oid AND atrdef.adnum = atr.attnum
  LEFT JOIN pg_namespace nsp ON nsp.oid = tbl.relnamespace
 WHERE tbl.relkind = 'r'::char
   AND nsp.nspname IN ('efeito', 'instancia')
   AND atr.attnum > 0
 order by namespace, Tabela, atr.attnum /* Número da coluna*/, Coluna, Chave_Primaria desc, Chave_Estrangeira desc;

-------------------------------------------------------------------------------------
-- Esquema efeito
-------------------------------------------------------------------------------------
------------------------------------------
-- Domínios
------------------------------------------
DROP DOMAIN IF EXISTS efeito.Site CASCADE;
CREATE DOMAIN efeito.Site varchar(200);

------------------------------------------
-- Efeito
------------------------------------------
CREATE TABLE efeito.efeito (
	id_efeito int PRIMARY KEY,
	nome varchar(100) NOT NULL,
	descricao text,
	identificador efeito.Site UNIQUE NOT NULL,
	id_empresa int NOT NULL,
	id_tecnologia int NOT NULL
);

COMMENT ON TABLE efeito.efeito IS 'Efeitos são plugins que simulam "pedais" (de guitarra, de baixo...), "amplificadores", "sintetizadores" - dentre outros equipamentos - 
cujo intuito é melhorar (corrigir), modificar e (ou) incrementar o áudio obtido externamente (por uma interface de áudio) ou internamente (por um efeito anterior).\n
O produto (áudio processado) poderá ser utilizado externamente (sendo disposto em uma interface de áudio) ou internamente (por um efeito posterior ou gravação de áudio)\n\n

 - Para conexões entre efeitos, visite instancia.conexao\n
 - Para representação de interface de áudio, visite efeito.';

COMMENT ON COLUMN efeito.efeito.id_efeito IS 'Chave primária de efeito';
COMMENT ON COLUMN efeito.efeito.nome IS 'Nome do efeito';
COMMENT ON COLUMN efeito.efeito.descricao IS 'Descrição do efeito provindas da empresa que o desenvolveu';
COMMENT ON COLUMN efeito.efeito.identificador IS 'Identificador único em forma de URI - Identificador Uniforme de Recurso';
COMMENT ON COLUMN efeito.efeito.id_empresa IS 'Referência para chave primária da empresa que desenvolveu o efeito';
COMMENT ON COLUMN efeito.efeito.id_tecnologia IS 'Referência para chave primária da tecnologia utilizada do efeito';

------------------------------------------
-- Tecnologia e empresa do dispositivo
------------------------------------------
CREATE TABLE efeito.empresa (
	id_empresa int PRIMARY KEY,
	nome varchar(50) NOT NULL,
	site efeito.Site NOT NULL
);

COMMENT ON TABLE efeito.empresa IS 'Empresa que produz efeitos. Pode ser interpretada também como Fornecedor ou Desenvolvedor';

COMMENT ON COLUMN efeito.empresa.id_empresa IS 'Chave primária de empresa';
COMMENT ON COLUMN efeito.empresa.nome IS 'Nome da empresa';
COMMENT ON COLUMN efeito.empresa.site IS 'Site - dado pela própria empresa - no qual o usuário poderá encontrar informações dos produtos da desta';

CREATE TABLE efeito.tecnologia (
	id_tecnologia int PRIMARY KEY,
	nome varchar(50) NOT NULL,
	descricao text NOT NULL
);

COMMENT ON TABLE efeito.tecnologia IS 'Tecnologia/padrão de plugins de áudio no qual um efeito é desenvolvido';

COMMENT ON COLUMN efeito.tecnologia.id_tecnologia IS 'Chave primária de tecnologia';
COMMENT ON COLUMN efeito.tecnologia.nome IS 'Nome da tecnologia';
COMMENT ON COLUMN efeito.tecnologia.descricao IS 'Descrição da tecnologia, conforme disponível na Internet';

------------------------------------------
-- Categorias de efeitos
------------------------------------------

CREATE TABLE efeito.categoria (
	id_categoria int PRIMARY KEY,
	nome varchar(50) NOT NULL
);

COMMENT ON TABLE efeito.categoria IS 'Categoria no qual um efeito pode se enquadrar.
Como um efeito pode estar em mais de uma categoria, efeito.categoria_efeito relaciona as categorias para com os efeitos';

COMMENT ON COLUMN efeito.categoria.id_categoria IS 'Chave primária de categoria';
COMMENT ON COLUMN efeito.categoria.nome IS 'Nome da categoria no qual o efeito pode se enquadrar';

CREATE TABLE efeito.categoria_efeito (
	id_categoria int,
	id_efeito int,

	PRIMARY KEY(id_categoria, id_efeito)
);

COMMENT ON TABLE efeito.categoria IS 'Responsável por relacionar categorias e efeitos, de forma a permitir uma relação muitos-para-muitos';

COMMENT ON COLUMN efeito.categoria_efeito.id_categoria IS 'Referência para chave primária de categoria';
COMMENT ON COLUMN efeito.categoria_efeito.id_efeito IS 'Referência para chave primária de efeito';

------------------------------------------
-- Plug
------------------------------------------
CREATE TABLE efeito.plug (
	id_plug int PRIMARY KEY,
	id_efeito int NOT NULL,
	id_tipo_plug int NOT NULL,
	nome varchar(50) NOT NULL
);

COMMENT ON TABLE efeito.plug IS 'Um plug é a porta de entrada ou de saída do áudio.
Seu uso possibilita o processamento em série de vários efeitos - assim como uma cadeia de pedais de guitarra. \n
Indo além que pedais de efeitos no mundo real, onde um plug de saída pode conectar somente com um plug de entrada,
é possível que um plug de saída conecte-se com mais de um plug de entrada e vice-versa, facilitando um processamento de áudio "paralelo".

 - Para saber o tipo de plug, visite efeito.tipo_plug;
 - Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos através dos plugs), visite instancia.conexao';

COMMENT ON COLUMN efeito.plug.id_plug IS 'Chave primária de plug';
COMMENT ON COLUMN efeito.plug.id_efeito IS 'Referência para chave primária de efeito';
COMMENT ON COLUMN efeito.plug.id_tipo_plug IS 'Referência para chave primária de tipo_plug';
COMMENT ON COLUMN efeito.plug.nome IS 'Nome do plug';

CREATE TABLE efeito.tipo_plug (
	id_tipo_plug int PRIMARY KEY,
	nome varchar(50) NOT NULL UNIQUE
);

COMMENT ON TABLE efeito.tipo_plug IS 'Para este minimundo, um plug pode ser de entrada ou de saída\n\n

Para não ter que separar os tipos distintos de plugs em mais de uma tabela, fora utilizada esta estratégia.\n
Claramente, existem restrições de uso de plugs conforme seu tipo (como em instancia.conexao). Para estes casos,
foram utilizadas Triggers para garantir um estado válido para o Banco de dados (conforme as decisões de abstração tormadas).\n\n

Naturalmente, podem haver outros tipos de plugs. Entretanto, para o estado das tecnologias (efeito.tecnologia), estes dois são o suficiente.';

COMMENT ON COLUMN efeito.tipo_plug.id_tipo_plug IS 'Chave primária de tipo_plug';
COMMENT ON COLUMN efeito.tipo_plug.nome IS 'Nome do tipo do plug';
------------------------------------------
-- Parametro
------------------------------------------
CREATE TABLE efeito.parametro (
	id_parametro int PRIMARY KEY,
	id_efeito int NOT NULL,	
	nome varchar(50) NOT NULL,

	minimo float NOT NULL CHECK (minimo <= maximo),
	maximo float NOT NULL CHECK (maximo >= minimo),
	valor_padrao float NOT NULL CHECK(
		valor_padrao BETWEEN minimo AND maximo
	)
	/*
	SELECT efeito.nome, parametro.nome, minimo, maximo, valor_padrao
	  FROM efeito.parametro JOIN efeito.efeito USING (id_efeito)
	 WHERE maximo < valor_padrao
	*/
);

COMMENT ON TABLE efeito.parametro IS 'Parametro refere-se às parametrizações para um determinado efeito.
Esta tabela enumera os possíveis parâmetros de um efeito, bem como o estado possível deste, determinando seu domínio através 
de parametro.minimo, parametro.máximo e parametro.valor_padrao.\n\n

Note entretanto que uma tupla não contém o valor (estado atual) de um parâmetro para um efeito, pois este trabalho fora direcionado
para instancia.configuracao_efeito_parametro.\n\n

 - Para detalhes sobre como definir um valor a um parâmetro, visite instancia.configuracao_efeito_parametro;\n
 - Para detalhes sobre o que é uma instância de um efeito, visite instancia.instancia_efeito.';


COMMENT ON COLUMN efeito.parametro.id_parametro IS 'Chave primária de parametro';
COMMENT ON COLUMN efeito.parametro.id_efeito IS 'Referência para chave primária de efeito';
COMMENT ON COLUMN efeito.parametro.nome IS 'Nome do parâmetro';
COMMENT ON COLUMN efeito.parametro.minimo IS 'Menor valor possível no qual este parâmetro pode assumir';
COMMENT ON COLUMN efeito.parametro.maximo IS 'Maior valor possível no qual este parâmetro pode assumir';
COMMENT ON COLUMN efeito.parametro.valor_padrao IS 'Valor padrão do parâmetro. Obviamente, deve estar dentro do intervalo [minimo, maximo]';

------------------------------------------
-- Relacionamentos de chave estrangeira
------------------------------------------

ALTER TABLE efeito.efeito ADD FOREIGN KEY (id_empresa) REFERENCES efeito.empresa (id_empresa);
ALTER TABLE efeito.efeito ADD FOREIGN KEY (id_tecnologia) REFERENCES efeito.tecnologia (id_tecnologia);

ALTER TABLE efeito.categoria_efeito ADD FOREIGN KEY (id_categoria) REFERENCES efeito.categoria (id_categoria);
ALTER TABLE efeito.categoria_efeito ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);

ALTER TABLE efeito.plug ADD FOREIGN KEY (id_tipo_plug) REFERENCES efeito.tipo_plug (id_tipo_plug);
ALTER TABLE efeito.plug ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);

ALTER TABLE efeito.parametro ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);

------------------------------------------
-- Popular dados BASE
------------------------------------------
-- Tecnologia e empresa do dispositivo
INSERT INTO efeito.tecnologia (id_tecnologia, nome, descricao)
VALUES (1, 'LV²', 'LV2 is an open standard for audio plugins, used by hundreds of plugins and other projects. At its core, LV2 is a simple stable interface, accompanied by extensions which add functionality to support the needs of increasingly powerful audio software'),
       (2, 'LADSPA', 'LADSPA is an acronym for Linux Audio Developer"s Simple Plugin Aefeito. It is an application programming interface (Aefeito) standard for handling audio filters and audio signal processing effects, licensed under the GNU Lesser General Public License (LGPL)'),
       (3, 'VST', 'Virtual Studio Technology (VST) is a software interface that integrates software audio synthesizer and effect plugins with audio editors and recording systems. VST and similar technologies use digital signal processing to simulate traditional recording studio hardware in software. Thousands of plugins exist, both commercial and freeware, and a large number of audio applications support VST under license from its creator, Steinberg.');

-- Categorias de efeitos

-- Tipos de Plug
INSERT INTO efeito.tipo_plug (id_tipo_plug, nome)
VALUES (1, 'Input'),
       (2, 'Output');

-------------------------------------------------------------------------------------
-- Esquema instancia
-------------------------------------------------------------------------------------
------------------------------------------
-- Conexão
------------------------------------------
CREATE TABLE instancia.conexao (
	id_conexao int PRIMARY KEY,

	id_instancia_efeito_saida int NOT NULL,
	id_plug_saida int NOT NULL,

	id_instancia_efeito_entrada int NOT NULL,
	id_plug_entrada int NOT NULL,
	
	UNIQUE (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
);

COMMENT ON TABLE instancia.conexao IS '';
 
COMMENT ON COLUMN instancia.conexao.id_conexao IS 'Chave primária de conexao';
COMMENT ON COLUMN instancia.conexao.id_instancia_efeito_saida IS 'Referência para chave primária de instancia_efeito. Instância de efeito cuja seu efeito possua o plug de saída (id_plug_saida)';
COMMENT ON COLUMN instancia.conexao.id_plug_saida IS 'Referência para chave primária de plug. Plug deve ser do tipo_plug 2:saída. Representa o plug de origem, onde o qual a conexão entre as instancia_efeitos parte. Pode ser entendido como Vértice de origem de uma Aresta do grafo "Conexões de um Patch"';
COMMENT ON COLUMN instancia.conexao.id_instancia_efeito_entrada IS 'Menor valor possível no qual este parâmetro pode assumir. Instância de efeito cuja seu efeito possua o plug de entrada (id_plug_entrada)';
COMMENT ON COLUMN instancia.conexao.id_plug_entrada IS 'Referência para chave primária de plug. Plug deve ser do tipo_plug 1:entrada. Representa o plug de destino, onde o qual a conexão entre as instancia_efeitos destina-se. Pode ser entendido como Vértice de destino de uma Aresta do grafo "Conexões de um Patch"';

------------------------------------------
-- Instância, Patchs e Bancos
------------------------------------------
CREATE TABLE instancia.instancia_efeito (
	id_instancia_efeito int PRIMARY KEY,
	id_efeito int NOT NULL,
	id_patch int NOT NULL
);

COMMENT ON COLUMN instancia.instancia_efeito.id_instancia_efeito IS 'Chave primária de instancia_efeito';
COMMENT ON COLUMN instancia.instancia_efeito.id_efeito IS 'Referência para chave primária de efeito. Instância efeito "é do tipo" efeito';
COMMENT ON COLUMN instancia.instancia_efeito.id_patch IS 'Referência para chave primária de patch. Patch no qual instância está contida';

CREATE TABLE instancia.patch (
	id_patch int PRIMARY KEY,
	id_banco int NOT NULL,
	nome VARCHAR(20) NOT NULL,
	posicao int CHECK (posicao >= 0) NOT NULL,

	UNIQUE (id_banco, posicao)
);

COMMENT ON COLUMN instancia.patch.id_patch IS 'Chave primária de patch';
COMMENT ON COLUMN instancia.patch.id_banco IS 'Referência para chave primária de banco. Banco no qual o Patch pertence';
COMMENT ON COLUMN instancia.patch.nome IS 'Nome representativo do patch. Deve ser curto, pois este poderá ser exibido em um display pequeno';
--COMMENT ON COLUMN instancia.patch.posicao IS 'Posição de acesso para o patch'; -- Não sei se irei por

CREATE TABLE instancia.banco (
	id_banco int PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	posicao int CHECK (posicao >= 0) NOT NULL,

	UNIQUE (posicao)
);

COMMENT ON COLUMN instancia.banco.id_banco IS 'Chave primária de banco';
COMMENT ON COLUMN instancia.banco.nome IS 'Nome representativo do banco. Deve ser curto, pois este poderá ser exibido em um display pequeno';
--COMMENT ON COLUMN instancia.banco.posicao IS 'Posição de acesso para o banco'; -- Não sei se irei por

------------------------------------------
-- Configuração e parâmetros
------------------------------------------
CREATE TABLE instancia.configuracao_efeito_parametro (
	id_configuracao_efeito_parametro int PRIMARY KEY,
	id_instancia_efeito int NOT NULL,
	id_parametro int NOT NULL,
	valor float NOT NULL,

	UNIQUE (id_instancia_efeito, id_parametro)
);

COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_configuracao_efeito_parametro IS 'Chave primária de configuracao_efeito_parametro';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_instancia_efeito IS 'Referência para instancia_efeito. Representa a instância do efeito no qual o parâmetro pertence';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_parametro IS 'Referência para parametro. Representa o parametro no qual será atribuído um valor';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.valor IS 'Valor do parametro para a instancia_efeito. Este deve estar contido no intervalo [efeito.parametro.minimo, efeito.parametro.maximo]';

------------------------------------------
-- Relacionamentos de chave estrangeira
------------------------------------------
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_plug_entrada) REFERENCES efeito.plug (id_plug);
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_plug_saida) REFERENCES efeito.plug (id_plug);

ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_instancia_efeito_entrada) REFERENCES instancia.instancia_efeito (id_instancia_efeito);
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_instancia_efeito_saida) REFERENCES instancia.instancia_efeito (id_instancia_efeito);

ALTER TABLE instancia.instancia_efeito ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);
ALTER TABLE instancia.instancia_efeito ADD FOREIGN KEY (id_patch) REFERENCES instancia.patch (id_patch);

ALTER TABLE instancia.patch ADD FOREIGN KEY (id_banco) REFERENCES instancia.banco (id_banco);

ALTER TABLE instancia.configuracao_efeito_parametro ADD FOREIGN KEY (id_instancia_efeito) REFERENCES instancia.instancia_efeito (id_instancia_efeito);
ALTER TABLE instancia.configuracao_efeito_parametro ADD FOREIGN KEY (id_parametro) REFERENCES efeito.parametro (id_parametro);

------------------------------------------
-- SEQUENCES
------------------------------------------

CREATE SEQUENCE instancia.sequence_configuracao_efeito_parametro START 1;

-------------------------------------------------------------------------------------
-- Visões
-------------------------------------------------------------------------------------
CREATE VIEW efeito.view_efeito_descricao AS
	SELECT id_efeito, efeito.nome, efeito.identificador, efeito.descricao, empresa.nome AS empresa, tecnologia.nome AS tecnologia
	  FROM efeito.efeito
	  JOIN efeito.empresa USING (id_empresa)
	  JOIN efeito.tecnologia USING (id_tecnologia);

CREATE VIEW instancia.view_patch_detalhes AS
	SELECT id_patch, id_banco,
	       instancia.banco.posicao || ' - ' || instancia.banco.nome || ': ' || instancia.patch.posicao || ' - ' || instancia.patch.nome AS patch_nome, 
	       instancia.instancia_efeito.id_instancia_efeito,
	       efeito.view_efeito_descricao.id_efeito,
	       efeito.view_efeito_descricao.nome AS efeito_nome, 
	       efeito.view_efeito_descricao.identificador AS efeito_identificador, 
	       efeito.view_efeito_descricao.empresa, 
	       efeito.view_efeito_descricao.tecnologia

	  FROM instancia.patch
	  JOIN instancia.instancia_efeito USING (id_patch)
	  JOIN instancia.banco USING (id_banco)
	  JOIN efeito.view_efeito_descricao USING (id_efeito)

	ORDER BY banco.posicao, patch.posicao, id_instancia_efeito;

-------------------------------------------------------------------------------------
-- Triggers
-------------------------------------------------------------------------------------
-- Triggers para instancia.conexao
CREATE OR REPLACE FUNCTION instancia.funcao_gerenciar_conexao() RETURNS trigger AS $$
    BEGIN
	-- Plug de SAÍDA deve pertencer ao efeito no qual a instancia refere-se
	IF NOT EXISTS(
		SELECT *
		  FROM instancia.instancia_efeito
		  JOIN efeito.efeito USING (id_efeito)
		  JOIN efeito.plug USING (id_efeito)

		 WHERE id_instancia_efeito = NEW.id_instancia_efeito_saida
		   AND id_plug = NEW.id_plug_saida
	) THEN
		RAISE EXCEPTION 'Plug de saída (id_plug_saida) % não pertence ao efeito no qual sua instância (instancia_efeito_saida) % pertence', NEW.id_plug_saida, NEW.id_instancia_efeito_saida;
	END IF;

	-- Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se
	IF NOT EXISTS(
		SELECT *
		  FROM instancia.instancia_efeito
		  JOIN efeito.efeito USING (id_efeito)
		  JOIN efeito.plug USING (id_efeito)

		 WHERE id_instancia_efeito = NEW.id_instancia_efeito_entrada
		   AND id_plug = NEW.id_plug_entrada
	) THEN
		RAISE EXCEPTION 'Plug de entrada (id_plug_entrada) % não pertence ao efeito no qual sua instância (instancia_efeito_entrada) % pertence', NEW.id_plug_saida, NEW.id_instancia_efeito_saida;
	END IF;

	-- Plug de SAÍDA deve ser do tipo esperado (Output)
	IF NOT EXISTS(
		SELECT *
		  FROM efeito.plug
		 WHERE id_tipo_plug = 2 -- Output
		   AND id_plug = NEW.id_plug_saida
	) THEN
		RAISE EXCEPTION 'Plug de saída (id_plug_saída) % não é do tipo esperado (id_tipo_plug = 2, Output)', NEW.id_plug_saida;
	END IF;

	-- Plug de ENTRADA deve ser do tipo esperado (Input)
	IF NOT EXISTS(
		SELECT *
		  FROM efeito.plug
		 WHERE id_tipo_plug = 1 -- Input
		   AND id_plug = NEW.id_plug_entrada
	) THEN
		RAISE EXCEPTION 'Plug de entrada (id_plug_entrada) % não é do tipo esperado (id_tipo_plug = 1, Input)', NEW.id_plug_entrada;
	END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_gerenciar_conexao
AFTER INSERT OR UPDATE ON instancia.conexao
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_gerenciar_conexao();

-- Testes
--  1. Plug saída não pertencente ao efeito de saída
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10000, 1, 50, 2, 1);
--  2. Plug entrada não pertencente ao efeito de entrada
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10001, 1, 2, 2, 50);
--  3. Plug de saída deve ser do tipo output
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10002, 1, 1, 2, 1);
--  4. Plug de saída deve ser do tipo input
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10002, 1, 3, 2, 3);


CREATE OR REPLACE FUNCTION instancia.funcao_gerenciar_conexao_ciclos() RETURNS trigger AS $$
    BEGIN
	-- Não devem haver ciclos
	IF EXISTS(
		-- http://dba.stackexchange.com/questions/64663/pl-pgsql-fuction-to-find-circular-references
		WITH RECURSIVE busca_ciclo(id_conexao, id_instancia_efeito_saida, id_instancia_efeito_entrada, profundidade, caminho, ciclo) AS (
			SELECT saida.id_conexao,
			       saida.id_instancia_efeito_saida,
			       saida.id_instancia_efeito_entrada,
			       1 AS profundidade,
			       ARRAY[saida.id_instancia_efeito_saida, saida.id_instancia_efeito_entrada] AS caminho,
			       false AS ciclo

			  FROM instancia.conexao saida
			 WHERE id_conexao = NEW.id_conexao

		      UNION ALL

			SELECT entrada.id_conexao,
			       entrada.id_instancia_efeito_saida,
			       entrada.id_instancia_efeito_entrada,
			       saida.profundidade + 1,
			       caminho || entrada.id_instancia_efeito_entrada,
			       entrada.id_instancia_efeito_entrada = ANY(caminho)

			  FROM instancia.conexao entrada, busca_ciclo saida
			 WHERE saida.id_instancia_efeito_entrada = entrada.id_instancia_efeito_saida AND NOT ciclo
		)

		SELECT * FROM busca_ciclo where ciclo IS TRUE
	) THEN
		RAISE EXCEPTION 'Ciclo de instancia_efeito''s detectado!';
	END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gerenciar_conexao_ciclos
AFTER INSERT OR UPDATE ON instancia.conexao
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_gerenciar_conexao_ciclos();

-- 1. Não devem haver ciclos
-- START -> A -> B -> C -> END
-- START -> A -> B -> D -> A -- CICLO!
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10000, 1, 3, 2,  1),
--            (10001, 2, 3, 3,  5),
--            (10002, 3, 6, 4, 64),
--            (10003, 3, 6, 1,  1); -- Loop

-- Triggers para instancia.instancia_efeito
-- Descrição: Para uma instancia_efeito criada, serão gerados configuracao_efeito_parametro
--            para cada parâmetro do efeito da instância.
--            O valor será o efeito.parametro.valor_padrao
CREATE OR REPLACE FUNCTION instancia.funcao_gerar_configuracao_efeito_parametro() RETURNS trigger AS $$
    BEGIN
	INSERT INTO instancia.configuracao_efeito_parametro

	SELECT nextval('instancia.sequence_configuracao_efeito_parametro') AS id_configuracao_efeito_parametro, NEW.id_instancia_efeito, id_parametro, valor_padrao AS valor
	  FROM efeito.parametro
	 WHERE id_efeito = NEW.id_efeito;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER funcao_gerar_configuracao_efeito_parametro
AFTER INSERT ON instancia.instancia_efeito
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_gerar_configuracao_efeito_parametro();

-- Detalhes dos valores dos parâmetros dos efeitos de um patch
/*
SELECT id_patch || ' - ' || patch.nome AS patch, id_efeito, id_instancia_efeito, id_parametro, efeito.nome || ': ' || parametro.nome AS parametro, configuracao_efeito_parametro.valor AS valor_atual, valor_padrao || ' [' ||minimo || ', ' || maximo || ']' AS valor_padrao
  FROM instancia.patch
  JOIN instancia.instancia_efeito USING (id_patch)
  JOIN efeito.efeito USING (id_efeito)
  JOIN efeito.parametro USING (id_efeito)
  JOIN instancia.configuracao_efeito_parametro USING (id_instancia_efeito, id_parametro)

 WHERE id_patch = 1

 ORDER BY id_patch, id_efeito, id_instancia_efeito, id_parametro
*/

-- Valor de um parâmetro (instancia.configuracao_efeito_parametro.valor) deve estar entre
-- o mínimo e o máximo do parâmetro correspondente ([efeito.parametro.minimo, efeito.parametro.maximo])
CREATE OR REPLACE FUNCTION instancia.funcao_atualizar_valor_instancia_efeito_parametro() RETURNS trigger AS $$
    BEGIN
	IF EXISTS(
		SELECT * FROM efeito.parametro
		 WHERE id_parametro = NEW.id_parametro
		   AND NEW.valor NOT BETWEEN minimo AND maximo
	) THEN
		RAISE EXCEPTION 'instancia.configuracao_efeito_parametro deve ter seu valor pertencente ao intervalo [%, %]',
		                minimo FROM efeito.parametro WHERE id_parametro = NEW.id_parametro,
		                maximo FROM efeito.parametro WHERE id_parametro = NEW.id_parametro;
	END IF;

	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER funcao_atualizar_valor_instancia_efeito_parametro
AFTER UPDATE ON instancia.configuracao_efeito_parametro
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_atualizar_valor_instancia_efeito_parametro();

-- Menor
/*
UPDATE instancia.configuracao_efeito_parametro
 SET valor = -5000
  WHERE id_configuracao_efeito_parametro = 1;
*/

-- Maior
/*
UPDATE instancia.configuracao_efeito_parametro
 SET valor = 5000
  WHERE id_configuracao_efeito_parametro = 1;
*/

------------------------------------------
-- Dados de exemplo
------------------------------------------


------------------------------------------
-- Consultas de exemplo
------------------------------------------
-- View 1 - Efeitos
SELECT * FROM efeito.view_efeito_descricao
 ORDER BY empresa;

-- View 2 - Patchs
SELECT * FROM instancia.view_patch_detalhes;


-- Parametros de um efeito
SELECT view_efeito_descricao.id_efeito, view_efeito_descricao.nome, view_efeito_descricao.empresa, 
       efeito.parametro.*, view_efeito_descricao.tecnologia AS efeito_tecnologia

  FROM efeito.view_efeito_descricao
  JOIN efeito.parametro USING (id_efeito)

 WHERE id_efeito = 100;

SELECT * FROM dicionario_dados.atributo;
SELECT * FROM dicionario_dados.relacao;