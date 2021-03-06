﻿COMMENT ON DATABASE "PedalPi" IS 'Banco de persistência do multi-efeitos PedalPi';

DROP SCHEMA IF EXISTS efeito CASCADE;
CREATE SCHEMA efeito;

COMMENT ON SCHEMA efeito IS 'Schema responsável por agrupar elementos referentes a efeito: Definições de efeitos, tecnologias de efeitos, empresas que fizeram efeitos, parâmetros de efeitos, tipos (categorias) de efeitos...';

DROP SCHEMA IF EXISTS instancia CASCADE;
CREATE SCHEMA instancia;

COMMENT ON SCHEMA instancia IS 'Schema responsável por agrupar elementos referentes a instância: Instância de efeito, valores atuais dos parâmetros de determinada instância, agrupamento de instâncias em um patch, agrupamento de patchs em um banco, conexões entre instâncias de um patch...';

DROP SCHEMA IF EXISTS dicionario_dados CASCADE;
CREATE SCHEMA dicionario_dados;

COMMENT ON SCHEMA dicionario_dados IS 'Schema responsável por abstrair o catálogo do banco, expondo em views simplificadas dados relevantes para a geração de um dicionário de dados';

COMMENT ON SCHEMA public IS 'Schema não utilizado em PedalPi';


-------------------------------------------------------------------------------------
-- Esquema dicionario_dados
-------------------------------------------------------------------------------------
-- Material de apoio sobre catálogo do Postgres: http://www.inf.puc-rio.br/~postgresql/conteudo/publicationsfiles/monteiro-reltec-metadados.PDF
DROP VIEW IF EXISTS dicionario_dados.database;

CREATE OR REPLACE VIEW dicionario_dados.database AS

SELECT datname AS nome, description as comentario
  FROM pg_shdescription
JOIN pg_database on objoid = pg_database.oid
WHERE datistemplate = false
  AND datname !~ 'postgres';

COMMENT ON VIEW dicionario_dados.database IS 'Bancos de dados persistidos neste postgres';

  
DROP VIEW IF EXISTS dicionario_dados.schema;
CREATE OR REPLACE VIEW dicionario_dados.schema AS
SELECT n.nspname AS nome, pg_catalog.pg_get_userbyid(n.nspowner) AS usuario,
       pg_catalog.array_to_string(n.nspacl, E'\n') AS privilegios,
       pg_catalog.obj_description(n.oid, 'pg_namespace') AS comentario

 FROM pg_catalog.pg_namespace n
 WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
 ORDER BY nome;

COMMENT ON VIEW dicionario_dados.schema IS 'Dispõe metadados importante de schemas';

-- http://dba.stackexchange.com/questions/30061/how-do-i-list-all-tables-in-all-schemas-owned-by-the-current-user-in-postgresql
DROP view IF EXISTS dicionario_dados.relacao;
CREATE OR REPLACE VIEW dicionario_dados.relacao AS
	SELECT pg_namespace.nspname AS "schema",
	       RelName as relacao,
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
	   AND pg_namespace.nspname IN (SELECT nome FROM dicionario_dados.schema)

	   ORDER BY "schema", tipo, relacao;

COMMENT ON VIEW dicionario_dados.relacao IS 'Dispõe metadados importante de relações, sejam estas tabelas ou views';


DROP view IF EXISTS dicionario_dados.atributo;
CREATE OR REPLACE VIEW dicionario_dados.atributo AS

-- http://blog.delogic.com.br/criar-dicionario-de-dados-em-postgres/
SELECT nsp.nspname AS "schema",
       tbl.relname AS relacao,
       atr.attname AS atributo,
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
   AND nsp.nspname IN (SELECT nome FROM dicionario_dados.schema)
   AND atr.attnum > 0
 order by "schema", relacao, atr.attnum /* Número da coluna*/, atributo, Chave_Primaria desc, Chave_Estrangeira desc;


COMMENT ON VIEW dicionario_dados.atributo IS 'Dispõe metadados importante de atributos';


DROP view IF EXISTS dicionario_dados.trigger;
CREATE OR REPLACE VIEW dicionario_dados.trigger AS

SELECT nsp.nspname as "schema", relname as relacao, tgname AS nome, description AS comentario, proname as nome_funcao
  FROM pg_description 
RIGHT JOIN pg_trigger on pg_description.objoid = pg_trigger.oid
  JOIN pg_class on (tgrelid=pg_class.oid)
  JOIN pg_proc on (tgfoid=pg_proc.oid)
  LEFT JOIN pg_namespace nsp ON nsp.oid = pg_class.relnamespace
 WHERE tgisinternal = false
 ORDER BY nome;

COMMENT ON VIEW dicionario_dados.trigger IS 'Dispõe metadados importante de triggers';

-------------------------------------------------------------------------------------
-- Esquema efeito
-------------------------------------------------------------------------------------
------------------------------------------
-- Domínios
------------------------------------------
DROP DOMAIN IF EXISTS efeito.URI CASCADE;
CREATE DOMAIN efeito.URI varchar(200);

COMMENT ON DOMAIN efeito.URI IS 'Uniform Resource Identifier - Identificador Uniforme de Recurso';

------------------------------------------
-- Efeito
------------------------------------------
CREATE TABLE efeito.efeito (
	id_efeito serial PRIMARY KEY,
	nome varchar(100) NOT NULL,
	descricao text,
	identificador efeito.URI UNIQUE NOT NULL,
	id_empresa int NOT NULL,
	id_tecnologia int NOT NULL
);

COMMENT ON TABLE efeito.efeito IS 'Efeitos são plugins que simulam "pedais" (de guitarra, de baixo...), "amplificadores", "sintetizadores" - dentre outros equipamentos - cujo intuito é melhorar (corrigir), modificar e (ou) incrementar o áudio obtido externamente (por uma interface de áudio) ou internamente (por um efeito anterior).
O produto (áudio processado) poderá ser utilizado externamente (sendo disposto em uma interface de áudio) ou internamente (por um efeito posterior ou gravação de áudio)

 * Para conexões entre efeitos, visite instancia.conexao;
 * Para representação de interface de áudio, visite efeito.';

COMMENT ON COLUMN efeito.efeito.id_efeito IS 'Chave primária de efeito';
COMMENT ON COLUMN efeito.efeito.nome IS 'Nome do efeito';
COMMENT ON COLUMN efeito.efeito.descricao IS 'Descrição do efeito provindas da empresa que o desenvolveu';
COMMENT ON COLUMN efeito.efeito.identificador IS 'Identificador único em forma de URI';
COMMENT ON COLUMN efeito.efeito.id_empresa IS 'Referência para chave primária da empresa que desenvolveu o efeito';
COMMENT ON COLUMN efeito.efeito.id_tecnologia IS 'Referência para chave primária da tecnologia utilizada do efeito';

------------------------------------------
-- Tecnologia e empresa do dispositivo
------------------------------------------
CREATE TABLE efeito.empresa (
	id_empresa serial PRIMARY KEY,
	nome varchar(50) NOT NULL,
	site efeito.URI NOT NULL
);

COMMENT ON TABLE efeito.empresa IS 'Empresa que produz efeitos. Pode ser interpretada também como Fornecedor ou Desenvolvedor';

COMMENT ON COLUMN efeito.empresa.id_empresa IS 'Chave primária de empresa';
COMMENT ON COLUMN efeito.empresa.nome IS 'Nome da empresa';
COMMENT ON COLUMN efeito.empresa.site IS 'Site - dado pela própria empresa - no qual o usuário poderá encontrar informações dos produtos da desta';

CREATE TABLE efeito.tecnologia (
	id_tecnologia serial PRIMARY KEY,
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
	id_categoria serial PRIMARY KEY,
	nome varchar(50) NOT NULL,
	restritiva boolean NOT NULL default FALSE
);

COMMENT ON TABLE efeito.categoria IS 'Categoria no qual um efeito pode se enquadrar.
Como um efeito pode estar em mais de uma categoria, efeito.categoria_efeito relaciona as categorias para com os efeitos';

COMMENT ON COLUMN efeito.categoria.id_categoria IS 'Chave primária de categoria';
COMMENT ON COLUMN efeito.categoria.nome IS 'Nome da categoria no qual o efeito pode se enquadrar';
COMMENT ON COLUMN efeito.categoria.restritiva IS 'Uma categoria restritiva (= true) faz com que só seja permitido haver um efeito igual em um mesmo patch';

CREATE TABLE efeito.categoria_efeito (
	id_categoria int,
	id_efeito int,

	PRIMARY KEY(id_categoria, id_efeito)
);

COMMENT ON TABLE efeito.categoria_efeito IS 'Responsável por relacionar categorias e efeitos, de forma a permitir uma relação muitos-para-muitos';

COMMENT ON COLUMN efeito.categoria_efeito.id_categoria IS 'Referência para chave primária de categoria';
COMMENT ON COLUMN efeito.categoria_efeito.id_efeito IS 'Referência para chave primária de efeito';

------------------------------------------
-- Plugs
------------------------------------------
CREATE TABLE efeito.plug_entrada (
	id_plug_entrada serial PRIMARY KEY,
	id_efeito int NOT NULL,
	nome varchar(50) NOT NULL
);

COMMENT ON TABLE efeito.plug_entrada IS 'Um plug é a porta de entrada ou de saída do áudio. Seu uso possibilita o processamento em série de vários efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de entrada permite que um sinal que chega seja processado pelo efeito. Um simples exemplo é: Saída da guitarra **entra** na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos através dos plugs), visite instancia.conexao';

COMMENT ON COLUMN efeito.plug_entrada.id_plug_entrada IS 'Chave primária de plug_entrada';
COMMENT ON COLUMN efeito.plug_entrada.id_efeito IS 'Referência para chave primária de efeito';
COMMENT ON COLUMN efeito.plug_entrada.nome IS 'Nome do plug';

CREATE TABLE efeito.plug_saida (
	id_plug_saida serial PRIMARY KEY,
	id_efeito int NOT NULL,
	nome varchar(50) NOT NULL
);

COMMENT ON TABLE efeito.plug_saida IS 'Um plug é a porta de entrada ou de saída do áudio. Seu uso possibilita o processamento em série de vários efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de saída permite o uso por outro efeito de um sinal processado do efeito com o plug de saída utilizado. Um simples exemplo é: **Saída** da guitarra entra na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos através dos plugs), visite instancia.conexao';

COMMENT ON COLUMN efeito.plug_saida.id_plug_saida IS 'Chave primária de plug_saida';
COMMENT ON COLUMN efeito.plug_saida.id_efeito IS 'Referência para chave primária de efeito';
COMMENT ON COLUMN efeito.plug_saida.nome IS 'Nome do plug';

------------------------------------------
-- Parametro
------------------------------------------
CREATE TABLE efeito.parametro (
	id_parametro serial PRIMARY KEY,
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
Esta tabela enumera os possíveis parâmetros de um efeito, bem como o estado possível deste, determinando seu domínio através de parametro.minimo, parametro.máximo e parametro.valor_padrao.

Note entretanto que uma tupla não contém o valor (estado atual) de um parâmetro para um efeito, pois este trabalho fora direcionado para instancia.configuracao_efeito_parametro.

 * Para detalhes sobre como definir um valor a um parâmetro, visite instancia.configuracao_efeito_parametro;
 * Para detalhes sobre o que é uma instância de um efeito, visite instancia.instancia_efeito.';


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

ALTER TABLE efeito.plug_entrada ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);
ALTER TABLE efeito.plug_saida ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);

ALTER TABLE efeito.parametro ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);

------------------------------------------
-- Popular dados BASE
------------------------------------------
-- Dados referentes ao Hardware 
INSERT INTO efeito.tecnologia (nome, descricao)
     VALUES ('PedalPi', 'Tecnologia utilizada nas configurações referentes ao hardware do PedalPi');

INSERT INTO efeito.categoria (nome, restritiva) 
     VALUES ('System OUTPUT', true),
            ('System INPUT', true);

 INSERT INTO efeito.empresa (nome, site)
      VALUES ('PedalController', 'http://PedalController.github.io/');

 INSERT INTO efeito.efeito (id_empresa, id_tecnologia, nome, descricao, identificador) 
      VALUES (1, 1, 'Placa de áudio - ENTRADA dos amplificadores', 'O sinal de instrumentos ligados ao equipamento será acessível por meio desse efeito', 'http://SrMouraSilva.github.io/Placa-de-audio-ENTRADA'),
	     (1, 1, 'Placa de áudio - SAÍDA dos instrumentos', 'Saída de efeitos ligados aqui serão enviados para as saidas do equipamento, que serão utilizadas possivelmente em caixas de som', 'http://SrMouraSilva.github.io/Placa-de-audio-SAIDA');

 INSERT INTO efeito.categoria_efeito (id_categoria, id_efeito) 
      VALUES (1, 1),
	     (2, 2);

-- Saída dos efeitos do patch para as entrada das "caixas de som"
 INSERT INTO efeito.plug_entrada (id_efeito, nome) 
      VALUES (1, 'Canal Esquerdo'),
	     (1, 'Canal Direito'),
	     (1, 'Monitor');

-- Saída dos "instrumentos" para os efeitos do patch
 INSERT INTO efeito.plug_saida (id_efeito, nome) 
      VALUES (2, 'Canal Esquerdo'),
	     (2, 'Canal Direito');

-- Tecnologia e empresa do dispositivo
INSERT INTO efeito.tecnologia (nome, descricao)
VALUES ('LV²', 'LV2 is an open standard for audio plugins, used by hundreds of plugins and other projects. At its core, LV2 is a simple stable interface, accompanied by extensions which add functionality to support the needs of increasingly powerful audio software'),
       ('LADSPA', 'LADSPA is an acronym for Linux Audio Developer"s Simple Plugin Aefeito. It is an application programming interface (Aefeito) standard for handling audio filters and audio signal processing effects, licensed under the GNU Lesser General Public License (LGPL)'),
       ('VST', 'Virtual Studio Technology (VST) is a software interface that integrates software audio synthesizer and effect plugins with audio editors and recording systems. VST and similar technologies use digital signal processing to simulate traditional recording studio hardware in software. Thousands of plugins exist, both commercial and freeware, and a large number of audio applications support VST under license from its creator, Steinberg.'),
       ('AU', 'Audio Units (AU) are a system-level plug-in architecture provided by Core Audio in the operating system OS X, iOS developed by Apple. Audio Units are a set of application programming interface (API) services provided by the operating system to generate, process, receive, or otherwise manipulate streams of audio in near-real-time with minimal latency.');

-------------------------------------------------------------------------------------
-- Esquema instancia
-------------------------------------------------------------------------------------
------------------------------------------
-- Conexão
------------------------------------------
CREATE TABLE instancia.conexao (
	id_conexao serial PRIMARY KEY,

	id_instancia_efeito_saida int NOT NULL,
	id_plug_saida int NOT NULL,

	id_instancia_efeito_entrada int NOT NULL,
	id_plug_entrada int NOT NULL,
	
	UNIQUE (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
);

COMMENT ON TABLE instancia.conexao IS 'Representa uma conexão entre duas instancia_efeito. De forma análoga a conexão real de pedais, representa um cabo de áudio ligando dois pedais, onde uma ponta conecta-se em um plug específico de saída de um pedal A para um plug específico de entrada de outro pedal B, de modo a transportar o áudio que sai de A para B.

Pode-se também interpretar instancia.patch como um grafo, onde as portas (instancia.porta) dos efeitos das instâncias são os nós e as conexões (instancia.conexao) representa os vértices';

COMMENT ON COLUMN instancia.conexao.id_conexao IS 'Chave primária de conexao';
COMMENT ON COLUMN instancia.conexao.id_instancia_efeito_saida IS 'Referência para chave primária de instancia_efeito. Instância de efeito cuja seu efeito possua o plug de saída (id_plug_saida)';
COMMENT ON COLUMN instancia.conexao.id_plug_saida IS 'Referência para chave primária de plug_saida. Representa o plug de origem, onde o qual a conexão entre as instancia_efeitos parte. Pode ser entendido como Vértice de origem de uma Aresta do grafo "Conexões de um Patch"';
COMMENT ON COLUMN instancia.conexao.id_instancia_efeito_entrada IS 'Menor valor possível no qual este parâmetro pode assumir. Instância de efeito cuja seu efeito possua o plug de entrada (id_plug_entrada)';
COMMENT ON COLUMN instancia.conexao.id_plug_entrada IS 'Referência para chave primária de plug_entrada. Representa o plug de destino, onde o qual a conexão entre as instancia_efeitos destina-se. Pode ser entendido como Vértice de destino de uma Aresta do grafo "Conexões de um Patch"';

------------------------------------------
-- Instância, Patchs e Bancos
------------------------------------------
CREATE TABLE instancia.instancia_efeito (
	id_instancia_efeito serial PRIMARY KEY,
	id_efeito int NOT NULL,
	id_patch int NOT NULL,
	ativo boolean NOT NULL DEFAULT false
);

COMMENT ON TABLE instancia.instancia_efeito IS 'efeito.efeito está para "obra" como instancia.instancia_efeito está para "mídia física".

Como um efeito pode ser utilizado múltiplas vezes em uma instancia.patch e cada um tem sua devida configuração (conjunto de instancia.configuracao_efeito_parametro para cada instancia.instancia_efeito), instancia_efeito se faz necessária.';

COMMENT ON COLUMN instancia.instancia_efeito.id_instancia_efeito IS 'Chave primária de instancia_efeito';
COMMENT ON COLUMN instancia.instancia_efeito.id_efeito IS 'Referência para chave primária de efeito. Instância efeito "é do tipo" efeito';
COMMENT ON COLUMN instancia.instancia_efeito.id_patch IS 'Referência para chave primária de patch. Patch no qual instância está contida';
COMMENT ON COLUMN instancia.instancia_efeito.ativo IS 'Instância efeito está ativo? Ou seja, a instância deve processar o sinal que recebe nas entradas (ativo == true) ou deve simplesmente encaminhar o sinal que recebe das entradas para as saídas? (ativo == false)';

CREATE TABLE instancia.patch (
	id_patch serial PRIMARY KEY,
	id_banco int NOT NULL,
	nome VARCHAR(20) NOT NULL
);


COMMENT ON TABLE instancia.patch IS 'Um patch representa uma configuração de uso dos efeitos que relaciona instâncias de efeitos, as conexões entre instâncias, o estado das instâncias e os valores atuais dos parâmetros de cada instância.';

COMMENT ON COLUMN instancia.patch.id_patch IS 'Chave primária de patch';
COMMENT ON COLUMN instancia.patch.id_banco IS 'Referência para chave primária de banco. Banco no qual o Patch pertence';
COMMENT ON COLUMN instancia.patch.nome IS 'Nome representativo do patch. Deve ser curto, pois este poderá ser exibido em um display pequeno';

CREATE TABLE instancia.banco (
	id_banco serial PRIMARY KEY,
	nome VARCHAR(20) NOT NULL
);

COMMENT ON TABLE instancia.banco IS 'Um banco serve como agrupador de patchs.

Usuários costumam utilizar bancos como forma de agrupar um conjunto de patchs para determinada situação. Ex:

 * Banco "Rock" contendo patchs para músicas clássicas do rock;
 * Banco "Show dia dd/mm/yyyy" contendo patchs que serão utilizados em determinado show
 * Banco "Artista Tal" contendo patchs criados pelo próprio artista como forma que querer agradar seu nicho de fãs';

COMMENT ON COLUMN instancia.banco.id_banco IS 'Chave primária de banco';
COMMENT ON COLUMN instancia.banco.nome IS 'Nome representativo do banco. Deve ser curto, pois este poderá ser exibido em um display pequeno';

------------------------------------------
-- Configuração e parâmetros
------------------------------------------
CREATE TABLE instancia.configuracao_efeito_parametro (
	id_configuracao_efeito_parametro serial PRIMARY KEY,
	id_instancia_efeito int NOT NULL,
	id_parametro int NOT NULL,
	valor float NOT NULL,

	UNIQUE (id_instancia_efeito, id_parametro)
);

COMMENT ON TABLE instancia.configuracao_efeito_parametro IS 'Sabendo que um efeito pode ser utilizado em mais de um patch, como também pode ser utilizado mais de uma vez em um mesmo patch, os valores atuais dos parâmetros devem ser persistidos vinculando efeito.instancia_efeito.

Uma tupla de instancia.configuracao_efeito_parametro representa: Um valor de um determinado parâmetro de uma instância de um efeito';

COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_configuracao_efeito_parametro IS 'Chave primária de configuracao_efeito_parametro';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_instancia_efeito IS 'Referência para instancia_efeito. Representa a instância do efeito no qual o parâmetro pertence';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.id_parametro IS 'Referência para parametro. Representa o parametro no qual será atribuído um valor';
COMMENT ON COLUMN instancia.configuracao_efeito_parametro.valor IS 'Valor do parametro para a instancia_efeito. Este deve estar contido no intervalo [efeito.parametro.minimo, efeito.parametro.maximo]';

------------------------------------------
-- Relacionamentos de chave estrangeira
------------------------------------------
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_plug_saida)   REFERENCES efeito.plug_saida (id_plug_saida);
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_plug_entrada) REFERENCES efeito.plug_entrada (id_plug_entrada);

ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_instancia_efeito_entrada) REFERENCES instancia.instancia_efeito (id_instancia_efeito);
ALTER TABLE instancia.conexao ADD FOREIGN KEY (id_instancia_efeito_saida) REFERENCES instancia.instancia_efeito (id_instancia_efeito);

ALTER TABLE instancia.instancia_efeito ADD FOREIGN KEY (id_efeito) REFERENCES efeito.efeito (id_efeito);
ALTER TABLE instancia.instancia_efeito ADD FOREIGN KEY (id_patch) REFERENCES instancia.patch (id_patch);

ALTER TABLE instancia.patch ADD FOREIGN KEY (id_banco) REFERENCES instancia.banco (id_banco);

ALTER TABLE instancia.configuracao_efeito_parametro ADD FOREIGN KEY (id_instancia_efeito) REFERENCES instancia.instancia_efeito (id_instancia_efeito);
ALTER TABLE instancia.configuracao_efeito_parametro ADD FOREIGN KEY (id_parametro) REFERENCES efeito.parametro (id_parametro);

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
	       instancia.banco.nome || ': ' || instancia.patch.nome AS patch_nome, 
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

	ORDER BY id_instancia_efeito;

-------------------------------------------------------------------------------------
-- Triggers
-------------------------------------------------------------------------------------
-- Triggers para instancia.conexao
CREATE OR REPLACE FUNCTION instancia.funcao_gerenciar_conexao() RETURNS trigger AS $$
    DECLARE
    	id_patch_saida int;
	id_patch_entrada int;

	nome_do_efeito varchar(200);
	id_do_efeito int;


    BEGIN
	-- Em uma conexão, somente instâncias do mesmo patch podem ser conectadas entre si
	SELECT id_patch INTO id_patch_saida
	  FROM instancia.instancia_efeito
	 WHERE id_instancia_efeito = NEW.id_instancia_efeito_saida;

	SELECT id_patch INTO id_patch_entrada 
	  FROM instancia.instancia_efeito
	 WHERE id_instancia_efeito = NEW.id_instancia_efeito_entrada;

	IF (id_patch_saida != id_patch_entrada) THEN
		RAISE EXCEPTION 'Somente instâncias do mesmo patch podem ser conectadas entre si.
Patch de id_instancia_efeito_saida é %.
Patch de id_instancia_efeito_entrada é %.',
		id_patch_saida,
		id_patch_entrada;
	END IF;
	
	-- Plug de SAÍDA deve pertencer ao efeito no qual a instancia refere-se
	IF NOT EXISTS(
		SELECT *
		  FROM instancia.instancia_efeito
		  JOIN efeito.efeito USING (id_efeito)
		  JOIN efeito.plug_saida USING (id_efeito)

		 WHERE id_instancia_efeito = NEW.id_instancia_efeito_saida
		   AND id_plug_saida = NEW.id_plug_saida
	) THEN
		SELECT instancia_efeito.id_efeito INTO id_do_efeito FROM instancia.instancia_efeito WHERE id_instancia_efeito = NEW.id_instancia_efeito_saida;
		SELECT efeito.nome INTO nome_do_efeito FROM efeito.efeito WHERE efeito.id_efeito = id_efeito;

		RAISE EXCEPTION 'instancia_efeito_saída ''%'' é do efeito ''% - %''. O plug de saída ''% - %'' não pertence a esse efeito',
				NEW.id_instancia_efeito_saida,
				id_do_efeito,
				nome_do_efeito,
				NEW.id_plug_saida,
				nome FROM efeito.plug_saida WHERE id_plug_saida = NEW.id_plug_saida;
	END IF;

	-- Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se
	IF NOT EXISTS(
		SELECT *
		  FROM instancia.instancia_efeito
		  JOIN efeito.efeito USING (id_efeito)
		  JOIN efeito.plug_entrada USING (id_efeito)

		 WHERE id_instancia_efeito = NEW.id_instancia_efeito_entrada
		   AND id_plug_entrada = NEW.id_plug_entrada
	) THEN
		SELECT instancia_efeito.id_efeito INTO id_do_efeito FROM instancia.instancia_efeito WHERE id_instancia_efeito = NEW.id_instancia_efeito_entrada;
		SELECT efeito.nome INTO nome_do_efeito FROM efeito.efeito WHERE efeito.id_efeito = id_efeito;

		RAISE EXCEPTION 'instancia_efeito_entrada ''%'' é do efeito ''% - %''. O plug de entrada ''% - %'' não pertence a esse efeito',
				NEW.id_instancia_efeito_entrada,
				id_do_efeito,
				nome_do_efeito,
				NEW.id_plug_entrada,
				nome FROM efeito.plug_entrada WHERE id_plug_entrada = NEW.id_plug_entrada;
	END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_gerenciar_conexao
AFTER INSERT OR UPDATE ON instancia.conexao
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_gerenciar_conexao();

COMMENT ON TRIGGER trigger_gerenciar_conexao ON instancia.conexao IS 'Trigger que verifica as seguintes restrições para INSERT OR UPDATE em instancia.conexao:

 - Somente instâncias do mesmo patch podem ser conectadas entre si;
 - Plug de SAÍDA deve pertencer ao efeito no qual a instancia refere-se;
 - Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se.';



/*
-- Testes
--  1. Em uma conexão, somente instâncias do mesmo patch podem ser conectadas entre si; 
INSERT INTO instancia.conexao (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (1,  1,  12, 226); -- "Aqui, ao tentarmos inserir uma conexão entre patches diferentes, o erro é lançado"

UPDATE instancia.conexao
   SET id_instancia_efeito_saida=1, id_plug_saida=1, id_instancia_efeito_entrada=12, id_plug_entrada=126   
 WHERE id_conexao=1

--  2. Plug saída não pertencente ao efeito de saída
INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (10000, 1, 50, 2, 1);

UPDATE instancia.conexao 
   set id_instancia_efeito_saida=1, id_plug_saida=50, id_instancia_efeito_entrada=2, id_plug_entrada=1
 where id_conexao = 1;

--  3. Plug entrada não pertencente ao efeito de entrada
INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (10001, 1, 2, 2, 50);

UPDATE instancia.conexao 
   SET id_instancia_efeito_saida=1, id_plug_saida=2, id_instancia_efeito_entrada=2, id_plug_entrada=50 
 WHERE id_conexao = 1; 
*/

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


COMMENT ON TRIGGER trigger_gerenciar_conexao_ciclos ON instancia.conexao IS 'Trigger que verifica as seguintes restrições para INSERT OR UPDATE em instancia.conexao:

 * Não deve haver ciclos no nível de instancia_efeito.

Seguem exemplos. A, B, C e D são exemplos de instancia.instancia_efeito:

 * Não há ciclo: START -> A -> B -> C -> END
 * Há ciclo: START -> A -> B -> D -> A -- CICLO!';
 
-- 1. Não devem haver ciclos
-- START -> A -> B -> C -> END
-- START -> A -> B -> D -> A -- CICLO!
/*
INSERT INTO instancia.banco (nome)
     VALUES ('Marllones Stronda');

INSERT INTO instancia.patch (id_patch, id_banco, nome)
     VALUES (10000, 3, 'Testosterona demais');

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (10001,    2,  10000), -- Placa de áudio - SAIDA dos instrumentos
            (10002,    5,  10000), -- Zamtube
            (10003,   50,  10000), -- Tap Vibrato
            (10004,  192,  10000), -- Invada Compressor (stereo)
            (10005,    1,  10000); -- Placa de áudio - ENTRADA dos amplificadores

INSERT INTO instancia.conexao (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (10001,  1,  10002,   7), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "ZamTube - Audio Input 1"
            (10002,  6,  10003,  33), -- "ZamTube - Audio Output 1" -> "TAP Vibrato - Input"
	    (10003, 33,  10004, 260), -- "TAP Vibrato - Output" -> "Invada Compressor (stereo) - In L"
	    (10004, 291, 10005,   2), -- "Invada Compressor (stereo) - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"
	    (10004, 291, 10003,  33); -- "Invada Compressor (stereo) - Out L" -> "TAP Vibrato - Input" -- CICLO!
*/

-- Triggers para instancia.instancia_efeito
CREATE OR REPLACE FUNCTION instancia.funcao_gerar_configuracao_efeito_parametro() RETURNS trigger AS $$
    BEGIN
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
		DELETE FROM instancia.configuracao_efeito_parametro WHERE id_instancia_efeito = OLD.id_instancia_efeito;
	END IF;

	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		INSERT INTO instancia.configuracao_efeito_parametro (id_instancia_efeito, id_parametro, valor)

		SELECT NEW.id_instancia_efeito, id_parametro, valor_padrao AS valor
		  FROM efeito.parametro
		 WHERE id_efeito = NEW.id_efeito;
	END IF;

	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_gerar_configuracao_efeito_parametro
AFTER INSERT OR UPDATE OR DELETE ON instancia.instancia_efeito
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_gerar_configuracao_efeito_parametro();

COMMENT ON TRIGGER trigger_gerar_configuracao_efeito_parametro ON instancia.instancia_efeito IS 'Trigger que verifica as seguintes restrições para INSERT, UPDATE ou DELETE em instancia.instancia_efeito:

 * Para uma instancia_efeito criada, serão inseridos automaticamente instancia.configuracao_efeito_parametro para cada parâmetro do efeito da instância.
   O valor será o efeito.parametro.valor_padrao;
 * Para uma instancia_efeito alterada ou excluída, serão alterados ou excluidos automaticamente instancia.configuracao_efeito_parametro para cada parâmetro do efeito da instância.
   O valor será o efeito.parametro.valor_padrao.
';

-- Exemplos
/*
-- 1. INSERIR
INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (10000, 300, 1);
SELECT COUNT(*), COUNT(*) > 0 FROM instancia.configuracao_efeito_parametro WHERE id_instancia_efeito = 10000

-- 2. ATUALIZAR
UPDATE instancia.instancia_efeito
   SET id_efeito = 310
 WHERE id_instancia_efeito = 10000;

SELECT COUNT(*), COUNT(*) > 0 FROM instancia.configuracao_efeito_parametro WHERE id_instancia_efeito = 10000;

SELECT * FROM instancia.configuracao_efeito_parametro
  JOIN efeito.parametro USING (id_parametro)
 WHERE id_instancia_efeito = 10000
   AND id_efeito != 310;

-- 3. DELETAR
DELETE FROM instancia.configuracao_efeito_parametro
 WHERE id_instancia_efeito = 10000;

SELECT COUNT(*), COUNT(*) = 0 FROM instancia.configuracao_efeito_parametro WHERE id_instancia_efeito = 10000
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


CREATE TRIGGER trigger_atualizar_valor_instancia_efeito_parametro
AFTER UPDATE ON instancia.configuracao_efeito_parametro
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_atualizar_valor_instancia_efeito_parametro();

COMMENT ON TRIGGER trigger_atualizar_valor_instancia_efeito_parametro ON instancia.configuracao_efeito_parametro IS 'Trigger que verifica as seguintes restrições para UPDATE em instancia.configuracao_efeito_parametro:

 - Valor de um parâmetro (instancia.configuracao_efeito_parametro.valor) deve estar entre o mínimo e o máximo do parâmetro correspondente ([efeito.parametro.minimo, efeito.parametro.maximo])';

/*
-- 1 - Menor
UPDATE instancia.configuracao_efeito_parametro
 SET valor = -5000
  WHERE id_configuracao_efeito_parametro = 1;

-- 2 - Maior
UPDATE instancia.configuracao_efeito_parametro
 SET valor = 5000
  WHERE id_configuracao_efeito_parametro = 1;
*/

-- Não podem haver efeitos de categorias restritivas repetidos em um patch
CREATE OR REPLACE FUNCTION instancia.funcao_limitar_instancia_efeito() RETURNS trigger AS $$
    BEGIN
	IF EXISTS (
		SELECT *
		  FROM instancia.instancia_efeito
		  JOIN efeito.efeito USING (id_efeito)
		  JOIN efeito.categoria_efeito USING (id_efeito)
		  JOIN efeito.categoria USING (id_categoria)

		 WHERE id_efeito = NEW.id_efeito
		   AND restritiva = TRUE
		   AND id_patch = NEW.id_patch
	) THEN
		RAISE EXCEPTION 'A instância que está tentando persistir possui uma categoria que é RESTRITIVA. Já há uma instância do efeito ''% - %'' para o patch %. Logo, não é possível inserí-la',
			NEW.id_efeito,
			nome FROM efeito.efeito WHERE id_efeito = NEW.id_efeito,
			NEW.id_patch;
	END IF;

	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_limitar_instancia_efeito
BEFORE INSERT OR UPDATE ON instancia.instancia_efeito
   FOR EACH ROW EXECUTE PROCEDURE instancia.funcao_limitar_instancia_efeito();

COMMENT ON TRIGGER trigger_limitar_instancia_efeito ON instancia.instancia_efeito IS 'Trigger que verifica as seguintes restrições para CREATE e UPDATE em instancia.instancia_efeito:

 - Não podem haver efeitos de categorias restritivas repetidos em um mesmo patch';

/*
-- 1 - INSERT
INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (10000, 2, 1); -- Placa de áudio - SAIDA dos instrumentos

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (10000, 1, 1); -- Placa de áudio - ENTRADA dos instrumentos

-- 2 - UPDATE
UPDATE instancia.instancia_efeito
   SET id_efeito=1, id_patch=1
 WHERE id_instancia_efeito=1

UPDATE instancia.instancia_efeito
   SET id_efeito=2, id_patch=1
 WHERE id_instancia_efeito=1
*/

------------------------------------------
-- Dados de exemplo - Efeito
------------------------------------------


------------------------------------------
-- Dados de exemplo - Instância
------------------------------------------


------------------------------------------
-- Consultas de exemplo
------------------------------------------
-- View 1 - Efeitos
SELECT * FROM efeito.view_efeito_descricao
 ORDER BY empresa, nome;

-- View 2 - Patchs
SELECT * FROM instancia.view_patch_detalhes;


SELECT * FROM dicionario_dados.database;
SELECT * FROM dicionario_dados.atributo;
SELECT * FROM dicionario_dados.schema;
SELECT * FROM dicionario_dados.trigger;
SELECT * FROM dicionario_dados.relacao;

INSERT INTO efeito.empresa (nome, site) 
      VALUES 
             ('ZamAudio', 'http://www.zamaudio.com'),
             ('x42', 'http://gareus.org/'),
             ('Robin', 'http://gareus.org/'),
             ('NickBailey', 'http://nickbailey.co.nr'),
             ('TAP', 'http://moddevices.com'),
             ('MOD', 'http://moddevices.com'),
             ('SHIRO', 'https://github.com/ninodewit/SHIRO-Plugins'),
             ('Shiro', 'https://github.com/ninodewit/SHIRO-Plugins'),
             ('Rakarrack', 'http://rakarrack.sourceforge.net'),
             ('MDA', 'http://moddevices.com'),
             ('Invada', 'http://www.invadarecords.com/Downloads.php?ID=00000264'),
             ('Guitarix', 'http://guitarix.sourceforge.net'),
             ('mayank', 'http://www.e7mac.com/experiments/'),
             ('Freaked', 'https://github.com/pjotrompet'),
             ('FOMP', 'http://drobilla.net'),
             ('FluidGM', 'https://github.com/falkTX/FluidPlug'),
             ('FluidSynth', 'https://github.com/falkTX/FluidPlug'),
             ('OpenAV', ''),
             ('DISTRHO', 'https://github.com/DISTRHO/ndc-Plugs'),
             ('CAPS', 'http://moddevices.com'),
             ('Calf', 'http://calf-studio-gear.org'),
             ('BLOP', ''),
             ('Dowell', 'https://amsynth.github.io'),
             ('Antanas', 'http://www.hippie.lt'),
             ('ZynAddSubFX', 'http://zynaddsubfx.sourceforge.net');

 INSERT INTO efeito.categoria (nome) 
      VALUES 
             ('Utility'),
             ('Mixer'),
             ('Filter'),
             ('Spatial'),
             ('Generator'),
             ('Instrument'),
             ('Modulator'),
             ('Simulator'),
             ('Distortion'),
             ('Reverb'),
             ('Delay'),
             ('Spectral'),
             ('Pitch Shifter'),
             ('Dynamics'),
             ('Limiter'),
             ('Equaliser'),
             ('Parametric'),
             ('Multiband'),
             ('Compressor'),
             ('Chorus'),
             ('Phaser'),
             ('Expander'),
             ('Flanger'),
             ('Oscillator'),
             ('Lowpass'),
             ('Highpass'),
             ('Analyser'),
             ('Amplifier'),
             ('Waveshaper'),
             ('Gate');

 INSERT INTO efeito.efeito (nome, descricao, identificador, id_empresa, id_tecnologia) 
      VALUES 
           ('ZaMultiCompX2', 'Flagship of zam-plugins:
Stereo version of ZaMultiComp, with individual threshold controls for each band and real-time visualisation of comp curves.
', 'urn:zamaudio:ZaMultiCompX2', 2, 5),
           ('ZaMultiComp', 'Mono multiband compressor, with 3 adjustable bands.
', 'urn:zamaudio:ZaMultiComp', 2, 2),
           ('ZamTube', 'Wicked distortion effect.
Wave digital filter physical model of a triode tube amplifier stage, with modelled tone stacks from real guitar amplifiers (thanks D. Yeh et al).
', 'urn:zamaudio:ZamTube', 2, 3),
           ('ZamHeadX2', 'HRTF acoustic filtering plugin for directional sound.
', 'urn:zamaudio:ZamHeadX2', 2, 4),
           ('ZamGEQ31', '31 band graphic equaliser, good for eq of live spaces, removing unwanted noise from a track etc.
', 'urn:zamaudio:ZamGEQ31', 2, 5),
           ('ZamGateX2', 'Gate plugin for ducking low gain sounds, stereo version.
', 'urn:zamaudio:ZamGateX2', 2, 2),
           ('ZamGate', 'Gate plugin for ducking low gain sounds.
', 'urn:zamaudio:ZamGate', 2, 3),
           ('ZamEQ2', 'Two band parametric equaliser with high and low shelving circuits.
', 'urn:zamaudio:ZamEQ2', 2, 4),
           ('ZamDelay', 'A delay with bpm and dividing options
', 'urn:zamaudio:ZamDelay', 2, 5),
           ('ZamCompX2', 'Stereo version of ZamComp with knee slew control.
', 'urn:zamaudio:ZamCompX2', 2, 2),
           ('ZamComp', 'A powerful mono compressor strip. Adds real beef to a kick or snare drum with the right settings.
', 'urn:zamaudio:ZamComp', 2, 3),
           ('ZaMaximX2', ' ... ', 'urn:zamaudio:ZaMaximX2', 2, 4),
           ('ZamAutoSat', 'An automatic saturation plugin, has been known to provide smooth levelling to live mic channels.
You can apply this plugin generously without affecting the tone.
', 'urn:zamaudio:ZamAutoSat', 2, 5),
           ('Stereo X-Fade', 'A stereo crossfade plugin', 'http://gareus.org/oss/lv2/xfade', 3, 2),
           ('No Delay Line', 'Artificial Latency - nodelay is a simple audio delay-line that can report its delay as latency. The effect should be transparent when used with a LV2 host that implements latency compensation.', 'http://gareus.org/oss/lv2/nodelay', 4, 3),
           ('MIDI Velocity Adjust', 'Change the velocity of note events with separate controls for Note-on and Note-off. The input range 1 - 127 is mapped to the range between Min and Max. If Min is greater than Max, the range is reversed. The offsets value is added to the velocity event after mapping the Min/Max range.', 'http://gareus.org/oss/lv2/midifilter#velocityscale', 3, 4),
           ('MIDI Velocity-Range Filter', 'Filter MIDI note-on events according to velocity. Note-on events outside the allowed range are discarded. If a Note-off is received for a note that was previously filtered, it is also not passed though. If the allowed range changes, note-off events are sent to currently active notes that end up outside the valid range.', 'http://gareus.org/oss/lv2/midifilter#velocityrange', 3, 5),
           ('MIDI Sostenuto', 'This filter delays note-off messages by a given time, emulating a piano sostenuto pedal. When the pedal is released, note-off messages that are queued will be sent immediately. The delay-time can be changed dynamically, changes do affects note-off messages that are still queued.', 'http://gareus.org/oss/lv2/midifilter#sostenuto', 3, 2),
           ('Scale CC Value', 'Modify the value (data-byte) of a MIDI control change message.', 'http://gareus.org/oss/lv2/midifilter#scalecc', 3, 3),
           ('MIDI Velocity Randomization', 'Randomize Velocity of MIDI notes (both note on and note off).', 'http://gareus.org/oss/lv2/midifilter#randvelocity', 3, 4),
           ('MIDI Quantization', 'Live event quantization. This filter aligns incoming MIDI events to a fixed time-grid. Since the effect operates on a live-stream it will introduce latency: Events will be delayed until the next ''tick''. If the plugin-host provides BBT information, the events are aligned to the host''s clock otherwise the effect runs on its own time.', 'http://gareus.org/oss/lv2/midifilter#quantize', 3, 5),
           ('MIDI Thru', 'MIDI All pass. This plugin has no effect and is intended as example.', 'http://gareus.org/oss/lv2/midifilter#passthru', 3, 2),
           ('MIDI N-Tap Delay', 'This effect repeats notes N times. Where N is either a fixed number or unlimited as long as a given key is pressed. BPM and delay-time variable and allow tempo-ramps. On every repeat the given velocity-adjustment is added or subtracted, the result is clamped between 1 and 127.', 'http://gareus.org/oss/lv2/midifilter#ntapdelay', 3, 3),
           ('MIDI Note Toggle', 'Toggle Notes: play a note to turn it on, play it again to turn it off.', 'http://gareus.org/oss/lv2/midifilter#notetoggle', 3, 4),
           ('Note2CC', 'Convert MIDI note-on messages to control change messages.', 'http://gareus.org/oss/lv2/midifilter#notetocc', 3, 5),
           ('MIDI Duplicate Blocker', 'MIDI Duplicate Blocker. Filter out overlapping note on/off and duplicate messages.', 'http://gareus.org/oss/lv2/midifilter#nodup', 3, 2),
           ('MIDI Remove Active Sensing', 'Filter to block all active sensing events. Active sensing messages are optional MIDI messages and intended to be sent repeatedly to tell a receiver that a connection is alive, however they can clutter up the MIDI channel or be inadvertently recorded when dumping raw MIDI data to disk.', 'http://gareus.org/oss/lv2/midifilter#noactivesensing', 3, 3),
           ('MIDI Monophonic Legato', 'Hold a note until the next note arrives. -- Play the same note again to switch it off.', 'http://gareus.org/oss/lv2/midifilter#monolegato', 3, 4),
           ('MIDI Chromatic Transpose', 'Chromatic transpose of midi notes and key-pressure. If an inversion point is set, the scale is mirrored around this point before transposing. Notes that end up outside the valid range 0..127 are discarded.', 'http://gareus.org/oss/lv2/midifilter#miditranspose', 3, 5),
           ('MIDI Strum', 'A midi arpeggio effect intended to simulate strumming a stringed instrument (e.g. guitar). A chord is ''collected'' and the single notes of the chord are played back spread out over time. The ''Note Collect Timeout'' allows for the effect to be played live with midi-keyboard, it compensates for a human not pressing keys at the same point in time. If the effect is used with a sequencer that can send chords with all note-on at the exactly time, it should be set to zero.', 'http://gareus.org/oss/lv2/midifilter#midistrum', 3, 2),
           ('MIDI Channel Unisono', 'Duplicate MIDI events from one channel to another.', 'http://gareus.org/oss/lv2/midifilter#mididup', 3, 3),
           ('MIDI Delayline', 'MIDI delay line. Delay all MIDI events by a given time which is give as BPM and beats. If the delay includes a random factor, this effect takes care of always keeping note on/off events sequential regardless of the randomization.', 'http://gareus.org/oss/lv2/midifilter#mididelay', 3, 4),
           ('MIDI Chord', 'Harmonizer - make chords from single (fundamental) note in a given musical scale. The scale as well as intervals can be automated freely (currently held chords will change). Note-ons are latched, for multiple/combined chords only single note-on/off will be triggered for the duration of the combined chords. If a off-scale note is given, it will be passed through - no chord is allocated. Note: Combine this effect with the ''MIDI Enforce Scale'' filter to weed them out.', 'http://gareus.org/oss/lv2/midifilter#midichord', 3, 5),
           ('MIDI Keys Transpose', 'Flexible 12-tone map. Allow to map a note within an octave to another note in the same octave-range +- 12 semitones. Alternatively notes can also be masked (disabled). If two keys are mapped to the same note, the corresponding note on/events are latched: only the first note on and last note off will be sent. The settings can be changed dynamically: Note-on/off events will be sent accordingly.', 'http://gareus.org/oss/lv2/midifilter#mapkeyscale', 3, 2),
           ('MapCC', 'Change one control message into another -- combine with scalecc to modify/scale the actual value.', 'http://gareus.org/oss/lv2/midifilter#mapcc', 3, 3),
           ('MIDI Keysplit', 'Change midi-channel number depending on note. The plugin keeps track of transposed midi-notes in case and sends note-off events accordingly if the range is changed even if a note is active. However the split-point and channel-assignments for each manual should only be changed when no notes are currently played. ', 'http://gareus.org/oss/lv2/midifilter#keysplit', 3, 4),
           ('MIDI Key-Range Filter', 'This filter allows to define a range of allowed midi notes. Notes-on/off events outside the allowed range are discarded. If the range changes, note-off events are sent to currently active notes that end up outside the valid range.', 'http://gareus.org/oss/lv2/midifilter#keyrange', 3, 5),
           ('MIDI Event Filter', 'Notch style message filter. Suppress specific messages. For flexible note-on/off range see also ''keyrange'' and ''velocityrange''.', 'http://gareus.org/oss/lv2/midifilter#eventblocker', 3, 2),
           ('MIDI Enforce Scale', 'Filter note-on/off events depending on musical scale. If the key is changed note-off events of are sent for all active off-key notes.', 'http://gareus.org/oss/lv2/midifilter#enforcescale', 3, 3),
           ('MIDI Channel Map', 'Rewrite midi-channel number. This filter only affects midi-data which is channel relevant (ie note-on/off, control and program changes, key and channel pressure and pitchbend). MIDI-SYSEX and Realtime message are always passed thru unmodified.', 'http://gareus.org/oss/lv2/midifilter#channelmap', 3, 4),
           ('MIDI Channel Filter', 'Simple MIDI channel filter. Only data for selected channels may pass. This filter only affects midi-data which is channel relevant (ie note-on/off, control and program changes, key and channel pressure and pitchbend). MIDI-SYSEX and Realtime message are always passed on. This plugin is intended for live-use, button-control. See also ''MIDI Channel Map'' filter.', 'http://gareus.org/oss/lv2/midifilter#channelfilter', 3, 5),
           ('CC2Note', 'Convert MIDI control change messages to note-on/off messages. Note off is queued 10msec later.', 'http://gareus.org/oss/lv2/midifilter#cctonote', 3, 2),
           ('LV2 Convolution Stereo', 'Zero latency Mono to Stereo Signal Convolution Processor; 2 chan IR', 'http://gareus.org/oss/lv2/convoLV2#Stereo', 4, 3),
           ('LV2 Convolution Mono=>Stereo', 'Zero latency True Stereo Signal Convolution Processor; 2 signals, 4 chan IR (L -> L, R -> R, L -> R, R -> L)', 'http://gareus.org/oss/lv2/convoLV2#MonoToStereo', 4, 4),
           ('LV2 Convolution Mono', 'Zero latency Mono Signal Convolution Processor', 'http://gareus.org/oss/lv2/convoLV2#Mono', 4, 5),
           ('Stereo Balance Control', 'balance.lv2 facilitates adjusting stereo-microphone recordings (X-Y, A-B, ORTF). But it also generally useful as ''Input Channel Conditioner''.	It allows for attenuating the signal on one of the channels as well as delaying the signals (move away from the microphone). To round off the feature-set channels can be swapped or the signal can be downmixed to mono after the delay.
	It features a Phase-Correlation meter as well as peak programme meters according to IEC 60268-18 (5ms integration, 20dB/1.5 sec fall-off) for input and output signals.
	The meters can be configure on the right side of the GUI, tilt it using the ''a'' key.', 'http://gareus.org/oss/lv2/balance', 4, 2),
           ('Triceratops', 'A Big Synth', 'http://nickbailey.co.nr/triceratops', 5, 3),
           ('TAP Vibrato', 'This plugin modulates the pitch of its input signal with a low-frequency sinusoidal signal. It is useful for guitar and synth tracks, and it can also come handy if a strange effect is needed.

source: http://tap-plugins.sourceforge.net/ladspa/vibrato.html
', 'http://moddevices.com/plugins/tap/vibrato', 6, 4),
           ('TAP Tubewarmth', 'TAP TubeWarmth adds the character of vacuum tube amplification to your audio tracks by emulating the sonically desirable nonlinear characteristics of triodes. In addition, this plugin also supports emulating analog tape saturation.

source: http://tap-plugins.sourceforge.net/ladspa/tubewarmth.html
', 'http://moddevices.com/plugins/tap/tubewarmth', 6, 5),
           ('TAP Tremolo', 'The tremolo effect is probably one of the most ancient effects, originated in the earliest days of the history of studio recording. It lost some of its popularity over time (and with the emerge of more exciting digital effects), but you still hear this effect on newer recordings from time to time.

source: http://tap-plugins.sourceforge.net/ladspa/tremolo.html
', 'http://moddevices.com/plugins/tap/tremolo', 6, 2),
           ('TAP Sigmoid Booster', 'This plugin applies a time-invariant nonlinear amplitude transfer function to the signal. Depending on the signal and the plugin settings, various related effects (compression, soft limiting, emulation of tape saturation, mild distortion) can be achieved.

source: http://tap-plugins.sourceforge.net/ladspa/sigmoid.html
', 'http://moddevices.com/plugins/tap/sigmoid', 6, 3),
           ('TAP Rotary Speaker', 'This plugin simulates the sound of rotating speakers. Two pairs of rotating speakers are simulated, each pair fixed on a vertical axis, with their horns spreading the sound in opposite directions. The two pairs of speakers are rotating with different revolutions (frequencies). The incoming sound is split into a low and a high part (with a low-pass and a high-pass filter, using a crossover frequency of 1 kHz). The low part is fed into the "Rotor" pair of speakers, and the high part into the "Horn" pair. A pair of horizontally aligned microphones is used to pick up the resulting sound. The distance of the microphones (the width of the stereo image of the effect) is adjustable.

source: http://tap-plugins.sourceforge.net/ladspa/rotspeak.html
', 'http://moddevices.com/plugins/tap/rotspeak', 6, 4),
           ('TAP Reverberator', 'TAP Reverberator is unique among reverberators freely available on the Linux platform. It supports creating no less than 43 reverberation effects, but its design permits this to be extended even further by the user, without doing any actual programming. Please take a look at TAP Reverb Editor, a separate JACK application for more information about this.

The design is based on the comb/allpass filter model. Comb filters create early reflections and allpass filters add to this by creating a dense reverberation effect. The output of the set of comb and allpass filters (also called the reverberator chamber) is processed further by sending it through a bandpass filter. The resulting band-limited reverberation is very similar to the natural reverberation that occurs in acoustic rooms. To achieve an even more natural-sounding effect, all comb filters have high-frequency compensation in their feedback loop. This is to model that the reflection ratio of acoustic surfaces is the function of frequency: higher frequencies are attenuated more, and thus decay time of higher frequency components is significantly shorter.

To enhance the reverberation sound even further, a special option called Enhanced Stereo is provided. When turned on (which is the default), it results in an added spatial spread of the reverb sound. This feature is most noticeable when applying the plugin to mono tracks: the sound of these tracks will "open up" in space.

source: http://tap-plugins.sourceforge.net/ladspa/reverb.html
', 'http://moddevices.com/plugins/tap/reverb', 6, 5),
           ('TAP Reflector', 'This plugin creates a psychedelic reverse audio effect. Overlapping time intervals of incoming samples are treated as blocks called ''fragments''. Each fragment is reversed in time, and faded in and out while played back to the output, hence creating a nearly constant signal level with the mixture resembling a normal reverse-played track -- with the difference that the audio actually progresses forward, only pieces of it are reversed.

source: http://tap-plugins.sourceforge.net/ladspa/reflector.html
', 'http://moddevices.com/plugins/tap/reflector', 6, 2),
           ('TAP Pitch Shifter', 'This plugin gives you the opportunity to change the pitch of individual tracks or full mixes, in the range of plus/minus one octave. Audio length (tempo) is not affected by this plugin, since audio is completely resampled. Besides being a special effect for creating foxy guitar tracks, it may come handy if your (otherwise very attractive) singer or chorus-girl was a bit indisposed at the time of recording: with the power of Ardour automation, you are given a chance to correct smaller pitch errors.

source: http://tap-plugins.sourceforge.net/ladspa/pitch.html
', 'http://moddevices.com/plugins/tap/pitch', 6, 3),
           ('TAP Pink/Fractal Noise', 'This plugin came to life as a secondary product of the development of TAP Fractal Doubler. It adds pink noise to the incoming signal using a one-dimensional random fractal line generated by the Midpoint Displacement Method, which is a computationally cheap method suitable for generating random fractals.

source: http://tap-plugins.sourceforge.net/ladspa/pinknoise.html
', 'http://moddevices.com/plugins/tap/pinknoise', 6, 4),
           ('TAP Scaling Limiter', 'You want to maximize the loudness of your master tracks. Your drummer has the habit of playing with varying velocity. You want to squeeze high transient spikes down into the bulk of the audio. You want a limiter with transparent sound, but without distortion. This is for you, then. The unique design of this innocent looking plugin results in the ability to achieve signal level limiting without audible artifacts.

Most limiters operate on the same basis as compressors: they monitor the signal level, and when it gets above a threshold level they reduce the gain on a momentary basis, resulting in an unpleasant "pumping" effect. Or even worse, they chop the signal at the top. This plugin actually scales each half-cycle individually down to a smaller level so the peak is placed exactly at the limit level. This operation (from zero-cross to zero-cross) results in an instantaneous blending of peaks and transient spikes down into the bulk of the audio.

source: http://tap-plugins.sourceforge.net/ladspa/limiter.html
', 'http://moddevices.com/plugins/tap/limiter', 6, 5),
           ('TAP Equalizer', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://moddevices.com/plugins/tap/eq', 6, 2),
           ('TAP Equalizer/BW', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://moddevices.com/plugins/tap/eqbw', 6, 3),
           ('TAP Stereo Echo', 'This plugin supports conventional mono and stereo delays, ping-pong delays and the Haas effect (also known as Cross Delay Stereo). A relatively simple yet quite effective plugin.

source: http://tap-plugins.sourceforge.net/ladspa/echo.html
', 'http://moddevices.com/plugins/tap/echo', 6, 4),
           ('TAP Stereo Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://moddevices.com/plugins/tap/dynamics-st', 6, 5),
           ('TAP Mono Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://moddevices.com/plugins/tap/dynamics', 6, 2),
           ('TAP Fractal Doubler', 'Originally developed to do vocal doubling, this plugin is suitable for doubling tracks with vocals, acoustic/electric guitars, bass and just about any other instrument on them. The effect is created by applying small changes to the pitch and timing of the incoming signal. These changes are created by one-dimensional random fractal lines producing pink noise.

source: http://tap-plugins.sourceforge.net/ladspa/doubler.html
', 'http://moddevices.com/plugins/tap/doubler', 6, 3),
           ('TAP DeEsser', 'TAP DeEsser is a plugin for attenuating higher pitched frequencies in vocals such as those found in ''ess'', ''shh'' and ''chh'' sounds.
Almost any vocal recording will contain ''ess'' sounds, whether a strong vocal delivery, from bad recording, speech impediments or simply many ''ess'' words spoken together.
Wind instruments and other musical instruments can also create shrill high-pitched noises. Audio engineers need to control these harsh ''ess'' sounds in most recordings.
', 'http://moddevices.com/plugins/tap/deesser', 6, 4),
           ('TAP Chorus/Flanger', 'This plugin is an implementation capable of creating traditional Chorus and Flanger effects, spiced up a bit to make use of stereo processing.
It sounds best on guitar and synth tracks.
', 'http://moddevices.com/plugins/tap/chorusflanger', 6, 5),
           ('TAP AutoPanner', 'The AutoPanner is a very well-known effect; its hardware incarnation originates in the age of voltage controlled synthesizers.
Its main use is to liven up synth tracks in the mix.
', 'http://moddevices.com/plugins/tap/autopan', 6, 2),
           ('SooperLooper', 'Basic looping plugin
', 'http://moddevices.com/plugins/sooperlooper', 7, 3),
           ('Shiroverb', 'Shiroverb is a shimmer-reverb based on the "Gigaverb"-genpatch, ported from the implementation by Juhana Sadeharju, and the "Pitch-Shift"-genpatch, both in Max MSP.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/shiroverb', 8, 4),
           ('Pitchotto', 'Pitchotto is a pitch-shifter based on the "Pitch-Shift"-genpatch in Max, where Phase-shifting is used to achieve different intervals.
There are two shifted signals available, both with variable delay-lengths for arpeggio-like sounds.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/pitchotto', 9, 5),
           ('Modulay', 'Modulay is a delay with variable types of modulation based on the setting of the Morph-knob.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/modulay', 8, 2),
           ('Larynx', 'Larynx is a simple vibrato with a tone control.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/larynx', 8, 3),
           ('setBfree Whirl Speaker - Extended Version', 'A rotating loudspeaker emulator designed to imitate the sound and properties of the sound modification device that brought world-wide fame to the name of Don Leslie', 'http://gareus.org/oss/lv2/b_whirl#extended', 3, 4),
           ('setBfree Whirl Speaker', 'A rotating loudspeaker emulator designed to imitate the sound of device that brought world-wide fame to the name of Don Leslie', 'http://gareus.org/oss/lv2/b_whirl#simple', 3, 5),
           ('setBfree DSP Tonewheel Organ', 'setBfree is a MIDI-controlled, software synthesizer designed to imitate the sound and properties of the electromechanical organs and sound modification devices that brought world-wide fame to the names and products of Laurens Hammond and Don Leslie.', 'http://gareus.org/oss/lv2/b_synth', 3, 2),
           ('setBfree Organ Reverb', 'A Schroeder Reverberator', 'http://gareus.org/oss/lv2/b_reverb', 3, 3),
           ('setBfree Organ Overdrive', 'A mean fuzz/overdrive used for the setBfree Tonewheel Organ.', 'http://gareus.org/oss/lv2/b_overdrive', 3, 4),
           ('rkr Reverb', 'Adapted from the ZynAddSubFX Reverb', 'http://rakarrack.sourceforge.net/effects.html#reve', 10, 5),
           ('rkr Parametric EQ', '3 band parametric peak-filter equalizer.', 'http://rakarrack.sourceforge.net/effects.html#eqp', 10, 2),
           ('rkr Distortion', 'Adapted from the ZynAddSubFX Distortion        
This is a waveshaper, and not particularly an amp or stompbox modeling effect. This must be used judiciously with EQ''s as well as the LPF and HPF settings (Low Pass Filter, High Pass Filter)

', 'http://rakarrack.sourceforge.net/effects.html#dist', 10, 3),
           ('rkr StompBox:Fuzz', 'Physically-informed fuzz stompbox emulation. Based on several popular schematics, this is designed to capture the sound of an era more than emulate a specific model.', 'http://rakarrack.sourceforge.net/effects.html#StompBox_fuzz', 10, 4),
           ('rkr WahWah', 'Wah effect controllable by the input volume envelope or by LFO.', 'http://rakarrack.sourceforge.net/effects.html#wha', 10, 5),
           ('rkr Pan', 'LFO controlled auto-panning/stereo tremelo effect. Useful to expand your stereo image.', 'http://rakarrack.sourceforge.net/effects.html#pan', 10, 2),
           ('rkr Harmonizer (no midi)', 'Pitch shifter that harmonizes with your dry signal. This works best for monophonic sounds (a single note at a time). Also allows selection of root and chord for intelligent harmonies.', 'http://rakarrack.sourceforge.net/effects.html#har_no_mid', 10, 3),
           ('rkr EQ', '10 band graphical equalizer with resonance control.', 'http://rakarrack.sourceforge.net/effects.html#eql', 10, 4),
           ('rkr Echo', 'Configurable echo effect with a reverse echo feature.', 'http://rakarrack.sourceforge.net/effects.html#eco', 10, 5),
           ('rkr Derelict', 'A very configurable waveshaping distortion module with resonance control of the filters for extra color.', 'http://rakarrack.sourceforge.net/effects.html#dere', 10, 2),
           ('rkr Musical Delay', 'Dual delay with delay times selectable by tempo and note subdivision.', 'http://rakarrack.sourceforge.net/effects.html#delm', 10, 3),
           ('rkr Compressor', 'A flexible compressor with optional soft knee and makeup gain.', 'http://rakarrack.sourceforge.net/effects.html#comp', 10, 4),
           ('rkr Flanger/Chorus', 'A flanger or chorus (depending on delay time) effect. Allows for fractional delays for a more intense effect.', 'http://rakarrack.sourceforge.net/effects.html#chor', 10, 5),
           ('rkr Cabinet', 'Equalizer with preset curves to match the effect of various guitar cabinets.', 'http://rakarrack.sourceforge.net/effects.html#cabe', 10, 2),
           ('rkr AlienWah', 'This effect features two alternating comb filters for a vocal/formant-like wah sound. It could be considered a combined flanger and phaser. It can be extreme or add very subtle shimmer', 'http://rakarrack.sourceforge.net/effects.html#awha', 10, 3),
           ('rkr Analog Phaser', 'A physically-informed, highly-configurable digital model of an analog FET phaser effect.', 'http://rakarrack.sourceforge.net/effects.html#aphas', 10, 4),
           ('rkr Vocoder', '32 band vocoder. This type of effect is well known for creating robot-like voices in popular music. The input is divided into frequency bands and each band''s volume is controlled by an auxiliary input''s frequency curve such that the output signal is filtered to sound like the aux signal.', 'http://rakarrack.sourceforge.net/effects.html#Vocoder', 10, 5),
           ('rkr Vibe', 'The UniVibe was intended as a rotating speaker emulation. It does a poor job of that, but in its own right became a popular phase-shifter effect. This version has optional feedback to achieve some additional tones.', 'http://rakarrack.sourceforge.net/effects.html#Vibe', 10, 2),
           ('rkr VaryBand', 'Multi-band tremolo effect allowing 2 LFOs to modulate volume of any combination of 4 frequency bands.', 'http://rakarrack.sourceforge.net/effects.html#VaryBand', 10, 3),
           ('rkr Valve', 'Tube distortion emulation with extra distortion available.', 'http://rakarrack.sourceforge.net/effects.html#Valve', 10, 4),
           ('rkr Synthfilter', 'A filter like what can be found in synthesizers. Up to 12 lowpass + 12 highpass filters with resonance. Cutoff frequency is controllable by LFO or volume envelope.', 'http://rakarrack.sourceforge.net/effects.html#Synthfilter', 10, 5),
           ('rkr Sustainer', 'A very simple, no-frills soft knee compressor good for making notes sustain. Brighter than the full Rakarrack Compressor.', 'http://rakarrack.sourceforge.net/effects.html#Sustainer', 10, 2),
           ('rkr StompBox', 'Physically-informed distortion stompbox emulation with 8 different distortion-character modes. Intended to allow quick dialing-in to the tone you want.', 'http://rakarrack.sourceforge.net/effects.html#StompBox', 10, 3),
           ('rkr StereoHarmonizer (no midi)', 'Pitch shifter that harmonizes 2 voices with your dry signal. This works best for monophonic sounds (a single note at a time). This version has a detune for stereo chorus effects. Also allows selection of root and chord for intelligent harmonies.', 'http://rakarrack.sourceforge.net/effects.html#StereoHarm_no_mid', 10, 4),
           ('rkr Shuffle', 'Creates interesting spatial effects. Converts stereo signal to Mid/Side and applys a parametric four band EQ to M or S channel. Effect based on Stereo Shuffling paper by Michael Gerzon.', 'http://rakarrack.sourceforge.net/effects.html#Shuffle', 10, 5),
           ('rkr Shifter', 'Pitch shifter with easy controls for expression pedal controled whammy effects. Also has a mode for envelope based control.', 'http://rakarrack.sourceforge.net/effects.html#Shifter', 10, 2),
           ('rkr Shelf Boost', 'Low-shelf filter for simple control of your tone.', 'http://rakarrack.sourceforge.net/effects.html#ShelfBoost', 10, 3),
           ('rkr Sequence', '8-step modulation sequencer. Each step is user-adjustable. Signal amplitude, filter cutoff frequency, or pitch shifting modulations available.', 'http://rakarrack.sourceforge.net/effects.html#Sequence', 10, 4),
           ('rkr Ring', 'A ring modulator with monophonic frequency recognition for synthesis.', 'http://rakarrack.sourceforge.net/effects.html#Ring', 10, 5),
           ('rkr Reverbtron', 'Convolution-based reverb effect. IR samples can be converted to .rvb format and loaded into this effect for a less cpu-intensive convolution. Several files included.', 'http://rakarrack.sourceforge.net/effects.html#Reverbtron', 10, 2),
           ('rkr OpticalTrem', 'An optical tremolo effect emulation such as often built into a guitar amplifier. This varies the signal volume through an LFO.', 'http://rakarrack.sourceforge.net/effects.html#Otrem', 10, 3),
           ('rkr MuTroMojo', 'State variable filter with envelope or LFO modulation. Allows it to act like a mixable blend of highpass, lowpass or bandpass filter. Similar to a mutron III. Also useful for classic wah pedal emulation when wah parameter is controlled by an expression pedal.', 'http://rakarrack.sourceforge.net/effects.html#MuTroMojo', 10, 4),
           ('rkr Infinity', 'This is the audio equivalent of a barber pole effect, with 8 filter bands continuously sweeping up or down. This has enough flexibility to create effects anywhere from subtle to insane.', 'http://rakarrack.sourceforge.net/effects.html#Infinity', 10, 5),
           ('rkr Expander', 'Analog BJT modeled dynamic expander for subtler noise suppression than a gate typically offers. Can also be used for interesting evelope-triggered swell and fade effects.', 'http://rakarrack.sourceforge.net/effects.html#Expander', 10, 2),
           ('rkr Exciter', 'Harmonic exciter that allows you to adjust the volume of each of 10 harmonics.', 'http://rakarrack.sourceforge.net/effects.html#Exciter', 10, 3),
           ('rkr Echoverse', 'Configurable echo designed to be stable for thick, in-your-face walls of sound.', 'http://rakarrack.sourceforge.net/effects.html#Echoverse', 10, 4),
           ('rkr Echotron', 'An extremely-configurable delay that allows up to 127 taps. Individual tap timing can be customized and loaded through text files. You can also have a custom filter on each tap. Several example files included.', 'http://rakarrack.sourceforge.net/effects.html#Echotron', 10, 5),
           ('rkr Dual Flange', 'Two flange effects cascaded to create unique and more intense tones than available through a single flanger.', 'http://rakarrack.sourceforge.net/effects.html#Dual_Flange', 10, 2),
           ('rkr DistBand', 'A multi-band distortion allowing different character distortion of different frequencies. It is a waveshaping distortion with a different waveshaper selectable for each band.', 'http://rakarrack.sourceforge.net/effects.html#DistBand', 10, 3),
           ('rkr CompBand', 'Multi-band compressor with 4 frequency bands and wet/dry mix control. Each band has individual ratio and threshold controls.', 'http://rakarrack.sourceforge.net/effects.html#CompBand', 10, 4),
           ('rkr Coil Crafter', 'A equalizer that makes your pickups sound like different pickups. Can switch a strat to sound like humbuckers in a strat etc.', 'http://rakarrack.sourceforge.net/effects.html#CoilCrafter', 10, 5),
           ('rkr Arpie', 'A pitch shifter that changes the shifting amount in a rhythmic pattern. Adds pulse and brightness to your sound.', 'http://rakarrack.sourceforge.net/effects.html#Arpie', 10, 2),
           ('ToggleSwitch', 'This toggled switch enables the output depending on the button state.
', 'http://moddevices.com/plugins/mod-devel/ToggleSwitch4', 7, 3),
           ('SwitchTrigger4', 'The Switch Trigger gets one audio stream as input and chooses one of four outputs
to route the audio. The output channel can be selected by triggering the corresponding
control.

The switch trigger was designed to use the MOD on stage. By addressing each control to a
footswitch, the musician can quickly access a desired chain of effects.
', 'http://moddevices.com/plugins/mod-devel/SwitchTrigger4', 7, 4),
           ('SwitchBox2', 'This switch box receives an audio input and channel it by one of it''s two outputs.

', 'http://moddevices.com/plugins/mod-devel/SwitchBox2', 7, 5),
           ('LowPassFilter', 'A simple low pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies below the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://moddevices.com/plugins/mod-devel/LowPassFilter', 7, 2),
           ('HighPassFilter', 'A simple high pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies above the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://moddevices.com/plugins/mod-devel/HighPassFilter', 7, 3),
           ('Gain 2x2', 'Stereo version of the simple volume gain plugin without "zipping" noise while messing with the gain parameter.
', 'http://moddevices.com/plugins/mod-devel/Gain2x2', 7, 4),
           ('Gain', 'Simple volume gain plugin without "zipping" noise while messing with the gain parameter.
', 'http://moddevices.com/plugins/mod-devel/Gain', 7, 5),
           ('CrossOver 3', 'This plugin receives an input signal and outputs 3 filtered signals. First one is filtered with a low pass filter (LPF), the second with a band pass filter (BPF) and the third with a high pass filter (HPF), cutoff frequency used on LPF and as the lower frequency from BPF is controlled by "Freq 1" and cutoff frequency used as the higher frequency on BPF and in HPF is controlled by "Freq 2". "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1", "Gain 2" and "Gain 3" controls the gains of all outputs respectively.


', 'http://moddevices.com/plugins/mod-devel/CrossOver3', 7, 2),
           ('CrossOver 2', 'This plugin receives an input signal and outputs 2 filtered signals. First one is filtered with a low pass filter (LPF) and the second, with a high pass filter (HPF), both cutoff frequencies are determined by "Freq" parameter. "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1" and "Gain 2" controls the gains of both outputs respectively.

', 'http://moddevices.com/plugins/mod-devel/CrossOver2', 7, 3),
           ('BandPassFilter', 'A band pass filter, "Freq" determines its Center frequency, "Q" works on the filter bandwith and "Order" is the filter''s order
(or how fast frequencies above the higher cutoff frequency and below the lower cutoff frequency will decay).
Higher the order, faster the decay.
', 'http://moddevices.com/plugins/mod-devel/BandPassFilter', 7, 4),
           ('Super Whammy', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/SuperWhammy', 7, 5),
           ('Super Capo', 'It''s a pitch shifter which can rise the pitch until 24 semitones (steps).
Because it''s more limited than Super Whammy it uses less processing, but still more than Capo.
', 'http://moddevices.com/plugins/mod-devel/SuperCapo', 7, 2),
           ('HarmonizerCS', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/HarmonizerCS', 7, 3),
           ('Harmonizer2', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/Harmonizer2', 7, 4),
           ('Harmonizer', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/Harmonizer', 7, 5),
           ('Drop', 'It''s a pitch shifter which can drop the pitch until 12 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/Drop', 7, 2),
           ('Capo', 'It''s a pitch shifter which can rise the pitch until 4 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/Capo', 7, 3),
           ('2Voices', 'It''s a pitch shifter which can rise the pitch until 4 semitones (steps).
Despite being more limited than Super Whammy it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/2Voices', 7, 4),
           ('MDA Vocoder', '16-band vocoder for applying the spectrum of one sound (the modulator, usually a voice or rhythm part) to the waveform of another (the carrier, usually a synth pad or sawtooth wave).
Note that both carrier and modulator signals are taken from one input channel, which therefore must be stereo for normal operation. This is different to some other vocoder plug-ins where one of the input signals is taken from another plug-in in a different channel.', 'http://moddevices.com/plugins/mda/Vocoder', 11, 5),
           ('MDA VocInput', 'This plug-in produces a voice-like signal on the right channel to be used as a carrier signal with vocoder and other vocoder plug-ins. The input signal passes through on the left channel.', 'http://moddevices.com/plugins/mda/VocInput', 11, 2),
           ('MDA Transient', '', 'http://moddevices.com/plugins/mda/Transient', 11, 3),
           ('MDA Tracker', 'This plug-in tracks the frequency of the input signal with an oscillator, ring modulator or filter.  The pitch tracking only works with monophonic inputs, but can create interesting effects on unpitched sounds such as drums.
This plug can be used with white or pink noise inputs to generate random pitch sequences.  Interesting evolving soundscapes can be made with a drum loop input and Tracker, RezFilter and Delay in series.', 'http://moddevices.com/plugins/mda/Tracker', 11, 4),
           ('MDA ThruZero', 'Tape flanger and ADT
This plug simulates tape-flanging, where two copies of a signal cancel out completely as the tapes pass each other. It can also be used for other "modulated delay" effects such as phasing and simple chorusing.', 'http://moddevices.com/plugins/mda/ThruZero', 11, 5),
           ('MDA TestTone', '', 'http://moddevices.com/plugins/mda/TestTone', 11, 2),
           ('MDA TalkBox', '', 'http://moddevices.com/plugins/mda/TalkBox', 11, 3),
           ('MDA SubSynth', 'More bass than you could ever need! Be aware that you may be adding low frequency content outside the range of your monitor speakers.  To avoid clipping, follow with a limiter plug-in (this can also give some giant hip-hop drum sounds!).', 'http://moddevices.com/plugins/mda/SubSynth', 11, 4),
           ('MDA Stereo', '', 'http://moddevices.com/plugins/mda/Stereo', 11, 5),
           ('MDA Splitter', 'This plug-in can split a signal based on frequency or level, for example for producing dynamic effects where only loud drum hits are sent to a reverb. Other functions include a simple "spectral gate" in INVERSE mode and a conventional gate and filter for separating drum sounds in NORMAL mode.', 'http://moddevices.com/plugins/mda/Splitter', 11, 2),
           ('MDA Shepard', 'This plug-in actually generates "Risset tones". Discrete stepping "Shepard tones" will hopefully be included in a future version. Continuously rising/falling tone generator.', 'http://moddevices.com/plugins/mda/Shepard', 11, 3),
           ('MDA RoundPan', 'Like all 3D processes the result depends on where you sit relative to the speakers, and mono compatibility is not guaranteed. This plug-in must be used in a stereo channel or bus!', 'http://moddevices.com/plugins/mda/RoundPan', 11, 4),
           ('MDA RingMod', 'Simple ring modulator with sine-wave oscillator.
Can be used as a high-frequency enhancer for drum sounds (when mixed with the original), adding dissonance to pitched material, and severe tremolo (at low frequency settings).', 'http://moddevices.com/plugins/mda/RingMod', 11, 5),
           ('MDA RezFilter', '', 'http://moddevices.com/plugins/mda/RezFilter', 11, 2),
           ('MDA RePsycho!', ' Event-based pitch shifter
Chops audio into individual beats and shifts each beat downwards in pitch. Only allowing downwards shifts helps keep timing very tight - depending on complexity, whole rhythm sections can be shifted!

Alternative uses include a triggered flanger or sub-octave doubler (both with mix set to 50% or less) and a swing quantizer (with a high threshold so not all beats trigger).
', 'http://moddevices.com/plugins/mda/RePsycho', 11, 3),
           ('MDA Piano', '', 'http://moddevices.com/plugins/mda/Piano', 11, 4),
           ('MDA Overdrive', 'Possible uses include adding body to drum loops, fuzz guitar, and that ''standing outside a nightclub'' sound. This plug does not simulate valve distortion, and any attempt to process organ sounds through it will be extremely unrewarding!', 'http://moddevices.com/plugins/mda/Overdrive', 11, 5),
           ('MDA MultiBand', 'As well as just "squashing everything" this plug-in can be used to "overcook" the mid-frequencies while leaving the low end unprocessed, enhancing playback over small speakers without affecting the overall sound too much.
To give more control when mastering (and to offer something different from other dynamics processors) in Mono mode this plug does not compress any stereo information, but in Stereo mode only the stereo component is processed giving control over ambience and space with a similar sound to strereo "shufflers" - but be careful with the levels!  The stereo width control works as a "mono depth" control in Stereo mode.', 'http://moddevices.com/plugins/mda/MultiBand', 11, 2),
           ('MDA Loudness', 'The ear is less sensitive to low frequencies when listening at low volume. This plug-in is based on the Stevens-Davis equal loudness contours and allows the bass level to be adjusted to simulate or correct for this effect.
Example uses:

If a mix was made with a very low or very high monitoring level, the amount of bass can sound wrong at a normal monitoring level. Use Loudness to adjust the bass content.
Check how a mix would sound at a much louder level by decreasing Loudness. (although the non-linear behaviour of the ear at very high levels is not simulated by this plug-in).

Fade out without the sound becoming "tinny" by activating Link and using Loudness to adjust the level without affecting the tonal balance.', 'http://moddevices.com/plugins/mda/Loudness', 11, 3),
           ('MDA Limiter', '', 'http://moddevices.com/plugins/mda/Limiter', 11, 4),
           ('MDA Leslie', 'No overdrive or speaker cabinet simulation is added - you may want to combine this plug-in with Combo.  For a much thicker sound try combining two Leslie plug-ins in series!', 'http://moddevices.com/plugins/mda/Leslie', 11, 5),
           ('MDA JX10', '  A polyphonic synthesizer with a lot of options to modulate the filter, with envelope and/or lfo.
  When Vibrato is set to PWM, the two oscillators are phase-locked and will produce a square wave if set to the same pitch. Pitch modulation of one oscillator then causes Pulse Width Modulation. (pitch modulation of both oscillators for vibrato is still available from the modulation wheel). Unlike other synths, in PWM mode the oscillators can still be detuned to give a wider range of PWM effects.
    ', 'http://moddevices.com/plugins/mda/JX10', 11, 2),
           ('MDA Image', 'Allows the level and pan of mono and stereo components to be adjusted separately, or components to be separated for individual processing before recombining with a second Image plug-in.', 'http://moddevices.com/plugins/mda/Image', 11, 3),
           ('MDA ePiano', '    It''s a virtual ePiano plugin. Based around 12 carefully sampled and mastered Rhodes Piano samples.
    ', 'http://moddevices.com/plugins/mda/EPiano', 11, 4),
           ('MDA Dynamics', '', 'http://moddevices.com/plugins/mda/Dynamics', 11, 5),
           ('MDA DX10', 'Sounds similar to the later Yamaha DX synths including the heavy bass but with a warmer, cleaner tone.  This plug-in is 8-voice polyphonic.', 'http://moddevices.com/plugins/mda/DX10', 11, 2),
           ('MDA DubDelay', 'Delay with feedback saturation and time/pitch modulation
', 'http://moddevices.com/plugins/mda/DubDelay', 11, 3),
           ('MDA Dither', 'When a waveform is rounded to the nearest 16 (or whatever)-bit value this causes distortion. Dither allows you to exchange this rough sounding signal-dependant distortion for a smooth background hiss.
Some sort of dither should always be used when reducing the word length of digital audio, such as from 24-bit to 16-bit. In many cases the background noise in a recording will act as dither, but dither will still be required on fades and on very clean recordings such as purely synthetic sources.

Noise shaping makes the background hiss of dither sound quieter, but adds more high-frequency noise than ''ordinary'' dither. This high frequency noise can be a problem if a recording is later processed in any way (including gain changes) especially if noise shaping is applied a second time.

If you are producing an absolutely final master at 16 bits or less, use noise shaped dither. In all other situations use a non-noise-shaped dither such as high-pass-triangular. When mastering for MP3 or other compressed formats be aware that noise shaping may take some of the encoder''s ''attention'' away from the real signal at high frequencies.

No gain changes should be applied after this plug-in. Make sure any master output fader is set to 0.0 dB in the host application.

Very technical note This plug-in follows Steinberg''s convention that a signal level of 1.0 corresponds to a 16-bit output of 32768. If your host application does not allow this exact gain setting the effectiveness of dither may be reduced (check for harmonic distortion of a 1 kHz sine wave using a spectrum analyser).', 'http://moddevices.com/plugins/mda/Dither', 11, 4),
           ('MDA Detune', 'A low-quality stereo pitch shifter for the sort of chorus and detune effects found on multi-effects hardware.', 'http://moddevices.com/plugins/mda/Detune', 11, 5),
           ('MDA Delay', '', 'http://moddevices.com/plugins/mda/Delay', 11, 2),
           ('MDA Degrade', '', 'http://moddevices.com/plugins/mda/Degrade', 11, 3),
           ('MDA De-ess', 'Reduce excessive sibilants (/s/ /t/ /sh/ etc.) in vocals and speech.
For stronger de-essing you may want to use two plug-ins in series, or apply processing twice.', 'http://moddevices.com/plugins/mda/DeEss', 11, 4),
           ('MDA Combo', 'This plug-in can sound quite subtle but comes alive when used on guitar with the drive turned up!  Remember that distortion may not sound good on time-based effects such as delay and reverb, so put those effects after this plug, or after a separate distortion plug with Combo acting only as a speaker simulator.', 'http://moddevices.com/plugins/mda/Combo', 11, 5),
           ('MDA BeatBox', 'Contains three samples (kick, snare and hat) designed to be triggered by incoming audio in three frequency ranges.  The default samples are based on the Roland CR-78.
To record your own sounds, use the Record control to monitor the plug''s input, then with the source stopped select the slot to record into, play your sound, then with the source stopped again, switch back to monitoring.  This process is easier in an ''off line'' editor such as WaveLab, rather than during a live mixdown in a DAW.', 'http://moddevices.com/plugins/mda/BeatBox', 11, 2),
           ('MDA Bandisto', 'This plug is like MultiBand but uses 3 bands of clipping instead of compression.  This is unlikely to be a plug you use every day, but when you want to recreate the sound of torn bass-bins you know where to come!', 'http://moddevices.com/plugins/mda/Bandisto', 11, 3),
           ('MDA Ambience', 'A plugin that simulates a room.
', 'http://moddevices.com/plugins/mda/Ambience', 11, 4),
           ('DS1', 'Analog distortion emulation of the classic Boss DS-1 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Boss DS-1 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://moddevices.com/plugins/mod-devel/DS1', 7, 5),
           ('Open Big Muff', 'Analog distortion emulation of the classic Electro-Harmonix Big Muff Pi (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Big Muff Pi is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://moddevices.com/plugins/mod-devel/BigMuffPi', 7, 2),
           ('Invada Stereo Phaser (sum L+R in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/sum', 12, 3),
           ('Invada Stereo Phaser (stereo in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/stereo', 12, 4),
           ('Invada Stereo Phaser (mono in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/mono', 12, 5),
           ('Invada Delay Munge (sum L+R in)', 'A wet only delay with munged delays, the pitch can be modulated by a lfo.
', 'http://invadarecords.com/plugins/lv2/delay/sum', 12, 2),
           ('Invada Delay Munge (mono in)', 'A wet only delay with munged delays, the pitch can be modulated by a lfo.
', 'http://invadarecords.com/plugins/lv2/delay/mono', 12, 3),
           ('Invada Tube Distortion (stereo)', 'Tube distortion, with a DC offset options
', 'http://invadarecords.com/plugins/lv2/tube/stereo', 12, 4),
           ('Invada Tube Distortion (mono)', 'Tube distortion, with a DC offset options
', 'http://invadarecords.com/plugins/lv2/tube/mono', 12, 5),
           ('Invada Test Tones', '    A sine generator to test connections
', 'http://invadarecords.com/plugins/lv2/testtone', 12, 2),
           ('Invada Input Module', '    Lets you modify the basics of a stereo signal, such as stereo width, panning and phase
', 'http://invadarecords.com/plugins/lv2/input', 12, 3),
           ('Invada Low Pass Filter (stereo)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/lpf/stereo', 12, 4),
           ('Invada Low Pass Filter (mono)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/lpf/mono', 12, 5),
           ('Invada High Pass Filter (stereo)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/hpf/stereo', 12, 2),
           ('Invada High Pass Filter (mono)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/hpf/mono', 12, 3),
           ('Invada Early Reflection Reverb (sum L+R in)', '    A Room simulator wich let you set the height, width and length of the room.
', 'http://invadarecords.com/plugins/lv2/erreverb/sum', 12, 4),
           ('Invada Early Reflection Reverb (mono in)', '    A Room simulator wich let you set the height, width and length of the room.
', 'http://invadarecords.com/plugins/lv2/erreverb/mono', 12, 5),
           ('Invada Compressor (stereo)', 'An easy to use high-quality compressor. 
', 'http://invadarecords.com/plugins/lv2/compressor/stereo', 12, 2),
           ('Invada Compressor (mono)', 'An easy to use high-quality compressor.
', 'http://invadarecords.com/plugins/lv2/compressor/mono', 12, 3),
           ('GxVoxTonebender', 'Analog distortion emulation of the classic Vox Tone Bender (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Vox Tone Bender is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_voxtb_#_voxtb_', 13, 4),
           ('GxWah', '
Analog wah emulation of the classic Dunlop Crybaby (*).

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Crybaby is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gxautowah#wah', 13, 5),
           ('GxTuner', '
...

', 'http://guitarix.sourceforge.net/plugins/gxtuner#tuner', 13, 2),
           ('GxTubeVibrato', '
Attempt at a true vibrato
And it works well!
Sounds very sweet with tubes wrapped

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxtubevibrato#tubevibrato', 13, 3),
           ('GxTubeTremelo', '
Model of a vactrol tremolo unit by "transmogrify"
c.f. http://sourceforge.net/apps/phpbb/guitarix/viewtopic.php?f=7&t=44&p=233&hilit=transmogrifox#p233
http://transmogrifox.webs.com/vactrol.m

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxtubetremelo#tubetremelo', 13, 4),
           ('GxTubeDelay', '
...

', 'http://guitarix.sourceforge.net/plugins/gxtubedelay#tubedelay', 13, 5),
           ('GxTubeScreamer', 'Analog distortion emulation of the classic Ibanez TS-9 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Ibanez TS-9 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxts9#ts9sim', 13, 2),
           ('GxTiltTone', 'A simple Tilt Tone control (*)

(*) The Tilt control imposes a shelving function, which attenuates half of frequency band and augments the other half. In other words, it is special type of a tone control that, unlike the typical tone control that boosts or cuts just the highs or mids or lows, shifts both highs and lows at once.

*Unofficial documentation

source: http://www.tubecad.com/2013/06/blog0266.htm
', 'http://guitarix.sourceforge.net/plugins/gxtilttone#tilttone', 13, 3),
           ('GxMetalHead', '
...

', 'http://guitarix.sourceforge.net/plugins/gxmetal_head#metal_head', 13, 4),
           ('GxMetalAmp', '
...

', 'http://guitarix.sourceforge.net/plugins/gxmetal_amp#metal_amp', 13, 5),
           ('GxEchoCat', '
A tape delay simulation plugin.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxechocat#echocat', 13, 2),
           ('GxBooster', '
A 2 band boost plugin. With this plugin you can boost the high and the low frequencies independently.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxbooster#booster', 13, 3),
           ('GxAutoWah', '
Analog wah emulation of the classic Dunlop Crybaby (*), in a auto-wah version.

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Crybaby is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gxautowah#autowah', 13, 4),
           ('GxZita_rev1-Stereo', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_zita_rev1_stereo#_zita_rev1_stereo', 13, 5),
           ('GxTremolo', '
Model of a vactrol tremolo unit by "transmogrify"
** c.f. http://sourceforge.net/apps/phpbb/guitarix/viewtopic.php?f=7&t=44&p=233&hilit=transmogrifox#p233
** http://transmogrifox.webs.com/vactrol.m

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_tremolo#_tremolo', 13, 2),
           ('Gxswitched_tremolo', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_switched_tremolo_#_switched_tremolo_', 13, 3),
           ('GxSustainer', 'Combine with the GxMuff to get an Electro-Harmonix Big Muff Pi sound (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Big Muff Pi is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_susta_#_susta_', 13, 4),
           ('Gx Studio Preamp Stereo', 'Based on the simple Alembic F-2B studio preamp (*)
2 sections of 12AX7 together with tonestack and volume
This is an identical circuit apart from coupling caps which you could do with filters

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Alembic F-2B is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_studiopre_st#studiopre_st', 13, 5),
           ('GxAlembic', 'Based on the simple Alembic F-2B studio preamp (*)
2 sections of 12AX7 together with tonestack and volume
This is an identical circuit apart from coupling caps which you could do with filters

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Alembic F-2B is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_studiopre#studiopre', 13, 2),
           ('Gxshimmizita', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_shimmizita_#_shimmizita_', 13, 3),
           ('GxScreamingBird', 'Emulation of the Electro-Harmonix Screaming Bird treble booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Screaming Bird is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_scream_#_scream_', 13, 4),
           ('Gxroom_simulator', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_room_simulator_#_room_simulator_', 13, 5),
           ('GxReverb-Stereo', '
"A Reverb simulates the component of sound that results from reflections from surrounding walls or objects. It is in effect a room simulator. Some people think it''s just a delay effect with some filters, but it''s way more complex than that."

*Unofficial documentation

source: http://audacity.sourceforge.net/manual-1.2/effects_reverb.html

', 'http://guitarix.sourceforge.net/plugins/gx_reverb_stereo#_reverb_stereo', 13, 2),
           ('GxRedeye Vibro Chump', '
A Fuzz, with a vibrato option.

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#vibrochump', 13, 3),
           ('GxRedeye Chump', '
A very complete fuzz

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#chump', 13, 4),
           ('GxRedeye Big Chump', '
More then the normal redeye fuzz

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#bigchump', 13, 5),
           ('GxRangemaster', 'Emulation of the Dallas Rangemaster treble booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dallas Rangemaster is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_rangem_#_rangem_', 13, 2),
           ('GxPhaser', '
"A phaser is an electronic sound processor used to filter a signal by creating a series of peaks and troughs in the frequency spectrum. The position of the peaks and troughs is typically modulated so that they vary over time, creating a sweeping effect. For this purpose, phasers usually include a low-frequency oscillator." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Phaser_%28effect%29

', 'http://guitarix.sourceforge.net/plugins/gx_phaser#_phaser', 13, 3),
           ('GxOC-2', '
A plugin that drops the original sound 1 and 2 octaves down to create an
extra fat sound

Partial emulation of the classic Boss OC-2 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Boss OC-2 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_oc_2_#_oc_2_', 13, 4),
           ('GxMuff', 'Analog distortion emulation of the Electro-Harmonix Muff (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Muff is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_muff_#_muff_', 13, 5),
           ('GxMole', 'Emulation of the Electro-Harmonix Mole bass booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Mole is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mole_#_mole_', 13, 2),
           ('GxMultiBandReverb', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_mbreverb_#_mbreverb_', 13, 3),
           ('GxMultiBandEcho', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_mbecho_#_mbecho_', 13, 4),
           ('GxMultiBandDistortion', 'A distortion that makes it possible to distort every frequency band individually, with crossovers

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mbdistortion_#_mbdistortion_', 13, 5),
           ('GxMultiBandDelay', 'A delay that makes it possible to delay every frequency band individually, with crossovers

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mbdelay_#_mbdelay_', 13, 2),
           ('GxMultiBandCompressor', '
"Multiband (also spelled multi-band) compressors can act differently on different frequency bands. The advantage of multiband compression over full-bandwidth (full-band, or single-band) compression is that unneeded audible gain changes or "pumping" in other frequency bands is not caused by changing signal levels in a single frequency band." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Dynamic_range_compression#Multiband_compression

', 'http://guitarix.sourceforge.net/plugins/gx_mbcompressor_#_mbcompressor_', 13, 3),
           ('Gxlivelooper', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_livelooper_#_livelooper_', 13, 4),
           ('GxJCM800pre ST', 'Emulation of the classic Marshall JCM800 preamp (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Marshall JCM 800 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_jcm800pre_st#_jcm800pre_st', 13, 5),
           ('GxJCM800pre', 'Emulation of the classic Marshall JCM800 preamp (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Marshall JCM 800 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://guitarix.sourceforge.net/plugins/gx_jcm800pre_#_jcm800pre_', 13, 2),
           ('GxHornet', 'Analog distortion emulation of the Dunlop Fuzz Face-based Hornet (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_hornet_#_hornet_', 13, 3),
           ('GxHogsFoot', 'Emulation of the Electro-Harmonix Hog''s Foot bass booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Hog''s Foot is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_hogsfoot_#_hogsfoot_', 13, 4),
           ('GxHighFrequencyBrightener', 'A High Frequency Brightener

', 'http://guitarix.sourceforge.net/plugins/gx_hfb_#_hfb_', 13, 5),
           ('GxGraphicEQ', '
"In the graphic equalizer, the input signal is sent to a bank of filters. Each filter passes the portion of the signal present in its own frequency range or band. The amplitude passed by each filter is adjusted using a slide control to boost or cut frequency components passed by that filter. The vertical position of each slider thus indicates the gain applied at that frequency band, so that the knobs resemble a graph of the equalizer''s response plotted versus frequency." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Equalization_%28audio%29#Graphic_equalizer

', 'http://guitarix.sourceforge.net/plugins/gx_graphiceq_#_graphiceq_', 13, 2),
           ('GxCrybabyGCB95', 'Analog wah emulation of the classic Dunlop GCB95 Crybaby (*), in a auto-wah version.

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop GCB95 Crybaby is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_gcb_95_#_gcb_95_', 13, 3),
           ('GxFuzzFaceFullerMod', 'Analog distortion emulation of the classic Dunlop Fuzz Face (Fuller Mods) (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fuzzfacefm_#_fuzzfacefm_', 13, 4),
           ('GxFuzzFaceJH-2', 'Analog distortion emulation of the classic Dunlop Fuzz Face JH-2 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fuzzface_#_fuzzface_', 13, 5),
           ('GxFuzz', 'A fuzz effect with lots of volume

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gx_fuzz_#fuzz_', 13, 2),
           ('GxFuzzMaster', 'Analog distortion emulation of the Vintage Fuzz Master (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Vintage Fuzz Master is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fumaster_#_fumaster_', 13, 3),
           ('GxFlanger', '
"Flanging /ˈflændʒɪŋ/ is an audio effect produced by mixing two identical signals together, one signal delayed by a small and gradually changing period, usually smaller than 20 milliseconds. This produces a swept comb filter effect: peaks and notches are produced in the resulting frequency spectrum, related to each other in a linear harmonic series. Varying the time delay causes these to sweep up and down the frequency spectrum. A flanger is an effects unit that creates this effect.

Part of the output signal is usually fed back to the input (a "re-circulating delay line"), producing a resonance effect which further enhances the intensity of the peaks and troughs. The phase of the fed-back signal is sometimes inverted, producing another variation on the flanging sound." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Flanging

', 'http://guitarix.sourceforge.net/plugins/gx_flanger#_flanger', 13, 4),
           ('GxExpander', '
"The expander is a compressor in reverse. There are two types of expander. In some, signals above the threshold remain at unity gain whereas signals below the threshold are reduced in gain, whereas in others the signal above the threshold also has the gain increased. Therefore you can use an expander as a noise reduction unit. Set the threshold to be just below the level of the player when playing. When the player stops the signal will fall below this threshold and the signal is reduced in gain thus reducing the noise or spill."

*Unofficial documentation

source: http://www.sae.edu/reference_material/audio/pages/Compression.htm

', 'http://guitarix.sourceforge.net/plugins/gx_expander#_expander', 13, 5),
           ('GxEcho-Stereo', '
A stereo echo plugin with independent delay time and delay volume for each channel. It also has a LFO modulator and two modes: linear and pingpong.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_echo_stereo#_echo_stereo', 13, 2),
           ('Gxduck_delay_st', '
The delayed signal added to output dependent of input signal amplitude. 
If the input signal is high. The delayed signall turned off, and vise versa.
The switching controlled by envelope follower

', 'http://guitarix.sourceforge.net/plugins/gx_duck_delay_st_#_duck_delay_st_', 13, 3),
           ('Gxduck_delay', '
The delayed signal added to output dependent of input signal amplitude. 
If the input signal is high. The delayed signall turned off, and vise versa.
The switching controlled by envelope follower

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_duck_delay_#_duck_delay_', 13, 4),
           ('Gxdigital_delay_st', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_digital_delay_st_#_digital_delay_st_', 13, 5),
           ('Gxdigital_delay', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_digital_delay_#_digital_delay_', 13, 2),
           ('Gxdetune', 'A detuner with an octave option

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_detune_#_detune_', 13, 3),
           ('GxDelay-Stereo', '
A stereo delay plugin with independent delay time and delay gain for each channel. It also has a LFO modulator and two modes: linear and pingpong.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_delay_stereo#_delay_stereo', 13, 4),
           ('GxColorSoundTonebender', 'Analog distortion emulation of the classic Colorsound Tonebender (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Colorsound Tonebender is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_cstb_#_cstb_', 13, 5),
           ('GxCompressor', '
"Compression (or more technically Dynamic range compression) is a subtle effect primarily for electric guitar where the highest and lowest points of the sound wave are "limited". This boosts the volume of softer picked notes, while capping the louder ones, giving a more even level of volume. This is frequently used in country music, where fast clean passages can sound uneven unless artificially ''squashed''." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Compression_%28electric_guitar%29

', 'http://guitarix.sourceforge.net/plugins/gx_compressor#_compressor', 13, 2),
           ('GxWahwah', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_colwah_#_colwah_', 13, 3),
           ('GxChorus-Stereo', '
"In music, a chorus effect (sometimes chorusing or chorused effect) occurs when individual sounds with roughly the same timbre and nearly (but never exactly) the same pitch converge and are perceived as one. While similar sounds coming from multiple sources can occur naturally (as in the case of a choir or string orchestra), it can also be simulated using an electronic effects unit or signal processing device." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Chorus_effect

', 'http://guitarix.sourceforge.net/plugins/gx_chorus_stereo#_chorus_stereo', 13, 4),
           ('GxCabinet', '
', 'http://guitarix.sourceforge.net/plugins/gx_cabinet#CABINET', 13, 5),
           ('GxBarkGraphicEQ', '
A Graphic Equalizer with Bark frequency scale.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_barkgraphiceq_#_barkgraphiceq_', 13, 2),
           ('GxAmplifier Stereo', 'Stereo version of gx_amp.

This plugin is the combination of guitarix''s head, tonestack and cabinet, which, in that order, composes the signal path. In the tube-amp part, "PreGain" corresponds to the gain used at the amp input, "Drive" controls the power amp gain, "Distortion" is a blend between clean and distorted sound (lower boundary is all clean, upper boundary all distorted) and "MasterGain" controls the output gain. Mainly, the responsible for the signal distortion are "PreGain" and "Drive" parameters. Besides that, there is a list of possible valve combinations so you can vary your distortion.

At the Tonestack part, we find a basic equalization set ("Bass", "Middle", "Treble" and "Presence") and a list of tone-responses from a few well-known amps, you can check this list in the link at the end of this description (there might be some version differences).

Finally, at the Cabinet path, we have "Cabinet", which corresponds to another output gain, it doesn''t distort the signal so it can be used as a Master output and there''s another list, containing a virtual sound of the cabinet of speakers selected (more details in the link below).

Based on:
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=EnhancedUI
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Tonestack
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Cabinet_Impulse_Response_convolution
', 'http://guitarix.sourceforge.net/plugins/gx_amp_stereo#GUITARIX_ST', 13, 3),
           ('GxAmplifier-X', 'This plugin is the combination of guitarix''s head, tonestack and cabinet, which, in that order, composes the signal path. In the tube-amp part, "PreGain" corresponds to the gain used at the amp input, "Drive" controls the power amp gain, "Distortion" is a blend between clean and distorted sound (lower boundary is all clean, upper boundary all distorted) and "MasterGain" controls the output gain. Mainly, the responsible for the signal distortion are "PreGain" and "Drive" parameters. Besides that, there is a list of possible valve combinations so you can vary your distortion.

At the Tonestack part, we find a basic equalization set ("Bass", "Middle", "Treble" and "Presence") and a list of tone-responses from a few well-known amps, you can check this list in the link at the end of this description (there might be some version differences).

Finally, at the Cabinet path, we have "Cabinet", which corresponds to another output gain, it doesn''t distort the signal so it can be used as a Master output and there''s another list, containing a virtual sound of the cabinet of speakers selected (more details in the link below).

Based on:
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=EnhancedUI
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Tonestack
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Cabinet_Impulse_Response_convolution
', 'http://guitarix.sourceforge.net/plugins/gx_amp#GUITARIX', 13, 4),
           ('Granulator', 'A realtime granulator plays small chunks of audio in the delay time setted', 'http://faust-lv2.googlecode.com/Granulator', 14, 5),
           ('Prefreak', 'A blurry pre-delay; can be used in combination with Prefreak to complete the reverb', 'http://faust-lv2.googlecode.com/Prefreak', 15, 2),
           ('Freaktail', 'The tail of a Reverb, can be used in combination with Prefreak to complete the reverb', 'http://faust-lv2.googlecode.com/Freaktail', 15, 3),
           ('Freakclip', 'Clipped Filter', 'http://faust-lv2.googlecode.com/Freakclip', 15, 4),
           ('Triple chorus', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The same as CS Chorus 2, but has three separate outputs.  Plan L,C,R for a nice stereo effect.', 'http://drobilla.net/plugins/fomp/triple_chorus', 16, 5),
           ('reverb', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	This is a stereo reverb plugin based on the well-known greverb.', 'http://drobilla.net/plugins/fomp/reverb', 16, 2),
           ('CS Phaser 1 with LFO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	Similar to CS Phaser 1, but the external modulation has been replaced by a built-in LFO.', 'http://drobilla.net/plugins/fomp/cs_phaser1_lfo', 16, 3),
           ('CS Chorus 2', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 
	Functionally identical to variant 1, but upsamples the input to the delay lines in an attempt to mitigate the errors produced by the linear interpolation at the output.', 'http://drobilla.net/plugins/fomp/cs_chorus2', 16, 4),
           ('CS Chorus 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 
	Based on a CSound orchestra file by Sean Costello. There are two low frequency oscillators, each having three outputs that are 120 degrees apart in phase. The summed outputs modulate three delay lines. Make sure the static delay (first parameter) is at least equal to the sum of the two modulation depths.', 'http://drobilla.net/plugins/fomp/cs_chorus1', 16, 5),
           ('Auto-wah', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The auto-wah, is basically a combination of an envelope follower and a resonant lowpass filter. For increasing level both the frequency and the bandwidth of the filter will increase. How much is controlled by ''Drive''. For a normal wah, use a pedal to control ''Frequency'' and set ''Drive'' to zero.', 'http://drobilla.net/plugins/fomp/autowah', 16, 2),
           ('Saw VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. The ''edge'' for this saw variant (1/F amplitude spectrum) is made by integrating the anti-aliased pulse. Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments. Tests by Matthias Nagorni revealed the output sounded quite ''harsh'' when compared to his analogue instruments. Comparing the spectra, it became clear that a mathematically ''exact'' spectrum was not desirable from a musical point of view. For this reason, a built-in lowpass filter was added. The default setting (0.5) will yield output identical to that of the Moog Voyager.', 'http://drobilla.net/plugins/fomp/saw_vco', 16, 3),
           ('reverb-amb', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	This is a stereo reverb plugin based on the well-known greverb.', 'http://drobilla.net/plugins/fomp/reverb_amb', 16, 4),
           ('Rec VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. The ''edge'' for this rectangular variant is made by integrating the anti-aliased pulse. Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments. Tests by Matthias Nagorni revealed the output sounded quite ''harsh'' when compared to his analogue instruments. Comparing the spectra, it became clear that a mathematically ''exact'' spectrum was not desirable from a musical point of view. For this reason, a built-in lowpass filter was added. The default setting (0.5) will yield output identical to that of the Moog Voyager.', 'http://drobilla.net/plugins/fomp/rec_vco', 16, 5),
           ('Pulse VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. This is the pulse variant (flat amplitude spectrum). Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments.', 'http://drobilla.net/plugins/fomp/pulse_vco', 16, 2),
           ('4-Band Parametric Filter', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	There''s one plugin in this first release, a four-band parametric equaliser. Each section has an active/bypass switch, frequency, bandwidth and gain controls. There is also a global bypass switch and gain control. The 2nd order resonant filters are implemented using a Mitra-Regalia style lattice filter, which has the nice property of being stable even while parameters are being changed. All switches and controls are internally smoothed, so they can be used ''live'' whithout any clicks or zipper noises. This should make this plugin a good candidate for use in systems that allow automation of plugin control ports, such as Ardour, or for stage use.', 'http://drobilla.net/plugins/fomp/parametric1', 16, 3),
           ('Moog Low-Pass Filter 4', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The same as variant 3, but adds a selection of 0, 6, 12, 18 or 24 db/oct output.', 'http://drobilla.net/plugins/fomp/mvclpf4', 16, 4),
           ('Moog Low-Pass Filter 3', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on variant 2, with two differences. It uses the the technique described by Stilson and Smith to extend the constant-Q range, and the internal sample frequency is doubled, giving a better approximation to the non-linear behaviour at high freqencies. This variant has high Q over the entire frequency range and will oscillate up to above 10 kHz, while the two others show a decreasing Q at high frequencies. This filter is reasonably well tuned, and can be ''played'' as a VCO up to at least 5 kHz.', 'http://drobilla.net/plugins/fomp/mvclpf3', 16, 5),
           ('Moog Low-Pass Filter 2', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Uses five non-linear elements, in the input and in all four filter sections. It works by using the derivative of the nonlinearity (for which 1 / (1 + x * x) is reasonable approximation). The main advantage of this is that only one evaluation of the non-linear function is required for each section. The four variables that contain the filter state (c1...c4) represent not the voltage on the capacitors (as in the first filter) but the current flowing in the resistive part.', 'http://drobilla.net/plugins/fomp/mvclpf2', 16, 2),
           ('Moog Low-Pass Filter 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	A fairly simple design which does not even pretend to come close the ''real thing''. It uses a very crude approximation of the non-linear resistor in the first filter section only. Retained in this distribution because it''s a cheap (in terms of CPU usage) general purpose 24 dB/oct lowpass filter that could be useful.', 'http://drobilla.net/plugins/fomp/mvclpf1', 16, 3),
           ('Moog High-Pass Filter 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the voltage controlled highpass filter by Robert Moog, with some attention to the nonlinear effects.  This is quite different from the lowpass filters.  When you ''overdrive'' the filter, the cutoff frequency will rise.  This first version is really very experimental.', 'http://drobilla.net/plugins/fomp/mvchpf1', 16, 4),
           ('CS Phaser 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	This is similar to the CSound module ''phaser1''. It''s a series connection of 1 to 30 first order allpass filters with feedback. For ''Output mix'', the range -1 to 0 crossfades between the inverted output and the input, and the range 0 to 1 crossfades between the input and the non-inverted output. Without feedback, the maximum effect is at +/- 0.5. For both ''Feedback gain'' and ''Output mix'', the best polarity depends on whether the number of sections is even or odd.', 'http://drobilla.net/plugins/fomp/cs_phaser1', 16, 5),
           ('Fluid SynthPads', 'This plugin contains the ''Synth Pads'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthPads', 17, 2),
           ('Fluid SynthLeads', 'This plugin contains the ''Synth Leads'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthLeads', 17, 3),
           ('Fluid SynthFX', 'This plugin contains the ''Synth FX'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthFX', 17, 4),
           ('Fluid Strings', 'This plugin contains the ''Strings'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidStrings', 17, 5),
           ('Fluid SoundFX', 'This plugin contains the ''Sound FX'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSoundFX', 17, 2),
           ('Fluid Reeds', 'This plugin contains the ''Reed'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidReeds', 17, 3),
           ('Fluid Pipes', 'This plugin contains the ''Pipe'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPipes', 17, 4),
           ('Fluid Pianos', 'This plugin contains the ''Piano'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPianos', 17, 5),
           ('Fluid Percussion', 'This plugin contains the ''Percussion'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPercussion', 17, 2),
           ('Fluid Organs', 'This plugin contains the ''Organ'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidOrgans', 17, 3),
           ('Fluid Guitars', 'This plugin contains the ''Guitar'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidGuitars', 17, 4),
           ('Fluid Ethnic', 'This plugin contains the ''Ethnic'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidEthnic', 17, 5),
           ('Fluid Ensemble', 'This plugin contains the ''Ensemble'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidEnsemble', 17, 2),
           ('Fluid Drums', 'This plugin contains the ''Drums'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidDrums', 17, 3),
           ('Fluid Chromatic Percussion', 'This plugin contains the ''Chromatic Percussion'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidChromPerc', 17, 4),
           ('Fluid Brass', 'This plugin contains the ''Brass'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidBrass', 17, 5),
           ('Fluid Bass', 'This plugin contains the ''Bass'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidBass', 17, 2),
           ('AirFont320', 'AirFont 320 made in 2005 by Milton Paredes.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_AirFont320', 18, 3),
           ('Fabla 2.0', '', 'http://www.openavproductions.com/fabla2', 19, 4),
           ('Soul Force', 'A fairly standard waveshaping distortion plugin, made more interesting through the use of feedback to control the shaping.
Can get pretty loud and obnoxious.
', 'http://www.niallmoody.com/ndcplugs/soulforce.htm', 20, 5),
           ('Ping Pong Pan', 'Ping Pong Panning.
', 'http://distrho.sf.net/plugins/PingPongPan', 20, 2),
           ('Nekobi', 'Simple single-oscillator synth based on the Roland TB-303.
', 'http://distrho.sf.net/plugins/Nekobi', 20, 3),
           ('MVerb', 'Studio quality reverb, provides a practical demonstration of Dattorro’s figure-of-eight reverb structure.
', 'http://distrho.sf.net/plugins/MVerb', 20, 4),
           ('MaPitchshift', 'Max Gen Pitchshifter example.
', 'http://distrho.sf.net/plugins/MaPitchshift', 20, 5),
           ('MaGigaverb', 'Max Gen Gigaverb example.
', 'http://distrho.sf.net/plugins/MaGigaverb', 20, 2),
           ('MaFreeverb', 'Max Gen Freeverb example.
', 'http://distrho.sf.net/plugins/MaFreeverb', 20, 3),
           ('MaBitcrush', 'Max Gen Bitcrush example.
', 'http://distrho.sf.net/plugins/MaBitcrush', 20, 4),
           ('Kars', 'Simple karplus-strong plucked string synth.
', 'http://distrho.sf.net/plugins/Kars', 20, 5),
           ('Cycle Shifter', 'Reads in a cycle''s-worth of the input signal, then (once the whole cycle''s been read in) outputs it again, on top of the current output.
Works best with long/sustained sounds (e.g. strings, pads etc.), sounds like a weird kind of gentle distortion.
', 'http://www.niallmoody.com/ndcplugs/cycleshifter.htm', 20, 2),
           ('Amplitude Imposer', 'Takes 2 stereo inputs and imposes the amplitude envelope of the first one on the second one.
Also has a threshold level for the second input, so that when the signal falls below it, it is amplified up to the threshold, to give a greater signal to be amplitude modulated.
', 'http://www.niallmoody.com/ndcplugs/ampimposer.htm', 20, 3),
           ('3 Band Splitter', '3 Band Equalizer, splitted output version.
', 'http://distrho.sf.net/plugins/3BandSplitter', 20, 4),
           ('3 Band EQ', '3 Band Equalizer, stereo version.
', 'http://distrho.sf.net/plugins/3BandEQ', 20, 5),
           ('C* Wider - Stereo image Synthesis', 'In addition to provoding a basic panorama control, a perception of stereo width is created using complementary filters on the two output channels.

The output channels always sum to a flat frequency response.

The design of this plugin owes to the Orban 245F Stereo Synthesizer.

source: http://quitte.de/dsp/caps.html#Wider
', 'http://moddevices.com/plugins/caps/Wider', 21, 2),
           ('C* White - White noise generator', 'Mostly white pseudonoise, mixed and filtered from the output of two Dattorro multibit generators.

source: http://quitte.de/dsp/caps.html#White
', 'http://moddevices.com/plugins/caps/White', 21, 3),
           ('C* ToneStack - Tone stack emulation', 'This emulation of the tone stack of a traditional Fender-design instrument amplifier has been devised and implemented by David T. Yeh, with subsequent expansion to include more models by Tim Goetze.

Due to the nature of the original circuit, the bass, mid and treble controls are not operating independently as in a modern three-way equaliser.

All but the last model are using the procedural implementation with continuously updated direct form II filters and sample rate independency.  It must be noted that the "DC 30" preset has been included despite the slight difference in topology between the British original and the Fender circuit.

The "5F6-A LT" model is using the lattice filter implementation mentioned in [yeh06], operating on precomputed simulation data for 44.1 kHz.

source: http://quitte.de/dsp/caps.html#ToneStack
', 'http://moddevices.com/plugins/caps/ToneStack', 21, 4),
           ('C* SpiceX2', 'Stereo version of Spice. Bass compression is governed by the sum of both channels, as in CompressX2. Nevertheless, the amount of harmonic generation differing between the two channels can have subtle effects on the stereo image.

source: http://quitte.de/dsp/caps.html#Spice
', 'http://moddevices.com/plugins/caps/SpiceX2', 21, 5),
           ('C* Spice', 'This effect plugin is useful when more bass register definition or more treble presence is called for and generic equalisation does not work without noticeably raising the signal or noise level. A common application is refreshing of material that has been subjected to low-quality analog transmission.

Bass and treble portions of the signal are isolated using two 24 dB/octave Linkwitz-Riley crossover networks[lr76] to ensure a flat frequency response at zero effect intensity (controlled through the .gain settings). After compression, a polynomial waveshaper synthesises the first three overtones of the bass register. This enhances the perception of the fundamental frequency, being the difference tone of these harmonics. Treble band processing applies analog-style saturation with only simplistic antialiasing. Synthesised harmonic content is shaped through bandpass and highpass filters and mixed back into the crossover sum signal.

A stereo version is available as SpiceX2.

source: http://quitte.de/dsp/caps.html#Spice
', 'http://moddevices.com/plugins/caps/Spice', 21, 2),
           ('C* Sin - Sine wave generator', 'The old friend, indispensable for testing and tuning.

source: http://quitte.de/dsp/caps.html#Sin
', 'http://moddevices.com/plugins/caps/Sin', 21, 3),
           ('C* Scape - Stereo delay + Filters', 'A stereo delay with resonant filters and fractally modulated panning.

The delay times are set through the bpm control and the divider adjustment. Triplet and sixteenth settings create a dotted rhythm. With every beat, the filter resonance frequencies are retuned to random steps on an equal-tempered chromatic scale, to the reference set through the tune control.

source: http://quitte.de/dsp/caps.html#Scape
', 'http://moddevices.com/plugins/caps/Scape', 21, 4),
           ('C* Saturate', 'Please note that this plugin embodies a very basic building block of audio DSP, not an elaborate effect that will be pleasing to hear right away. To turn saturation into a musically useful effect it is usually combined with some sort of filtering and dynamics modulation.

The mode control chooses from a selection of clipping functions of varying character. Even-order harmonics can be added with the bias setting. Towards the maximum, sound will start to get scratchy and eventually starve away.

The plugin is 8x oversampled with 64-tap polyphase filters, effectively suppressing aliasing noise for most musical applications. Changes to the bias control induce short-lived energy at DC in the output. In order to reduce the computational load incurred when evaluating transcendental functions at eight times the nominal sample rate, these are approximated roughly, using Chebyshev polynomials whose coefficients depend on the amplitude''s floating point representation exponent.

source: http://quitte.de/dsp/caps.html#Saturate
', 'http://moddevices.com/plugins/caps/Saturate', 21, 5),
           ('C* PlateX2 - Stereo in/out Versatile plate reverb', 'This version of the Plate reverberator comes with stereo inputs.

source: http://quitte.de/dsp/caps.html#Plate
', 'http://moddevices.com/plugins/caps/PlateX2', 21, 2),
           ('C* Plate - Versatile plate reverb', 'This reverb processor is an adaptation of the design discussed in [dat97a]. Tuned for a soft attack and smooth ambience, it consists of a network of twelve delay lines of varying length. At its heart, two of these are modulated very subtly, in a chorus-like fashion.

The bandwidth control reduces high-frequency content before it enters the ''tank'', while damping controls how quickly the reverberating tail darkens.

source: http://quitte.de/dsp/caps.html#Plate
', 'http://moddevices.com/plugins/caps/Plate', 21, 3),
           ('C* PhaserII - Mono phaser modulated by a Lorenz fractal', 'This take on the classic effect features two modulation choices, traditional sine-based periodicity or smoothened fractal oscillation.

Very high resonance settings can cause self-oscillation peaking in excess of 0 dB.

source: http://quitte.de/dsp/caps.html#PhaserII
', 'http://moddevices.com/plugins/caps/PhaserII', 21, 4),
           ('C* Noisegate - Attenuate noise resident in silence', 'This plugin aims to reduce undesirable background noise and hum in otherwise silent passages.

When the signal''s instantaneous amplitude exceeds the opening threshold, the gate is opened. The time it takes until the gate is fully open can be set with the attack control. As soon as the signal''s RMS power level drops below the closing threshold, the gate closes. This takes a fixed time of 20 ms; closed gate attenuation is 60 dB.

To cope with powerline hum as often present in signals from electric guitars, a notch filter can be activated by setting the mains frequency control to a non-zero value.  The filter will prevent this frequency from contributing to the signal power measurement. This allows a low closing threshold setting without mains hum keeping the gate open unduly.  The default mains setting is 50 Hz.

source: http://quitte.de/dsp/caps.html#Noisegate
', 'http://moddevices.com/plugins/caps/Noisegate', 21, 5),
           ('C* Narrower - Stereo image width reduction', 'This plugin reduces the width of a stereophonic signal. Its primary use is for preventing fatigue from listening to ''creatively panned'' music on headphones.

Mid/side processing tends to sound more transparent for moderate strength settings.  However, it will more strongly attenuate signals that are panned to the far sides of the stereo image (rarely encountered in contemporary music production anymore but quite common, for example, on early Beatles recordings or others from that time).

source: http://quitte.de/dsp/caps.html#Narrower
', 'http://moddevices.com/plugins/caps/Narrower', 21, 2),
           ('C* Fractal - Audio stream from deterministic chaos', 'This plugin turns the oscillating state of a fractal attractor into an audio stream. The result is something that most would without much hesitation classify as noise.

The Lorenz attractor is one of the earliest models of deterministic chaos discovered deriving from the Navier-Stokes equationswp.

The Rössler system is similar but contains only one non-linearity.

The x, y and z controls set the amplitude of the respective variables of the attractor state in the output audio signal.

The attractor state variables are scaled and translated to stay mostly within the [-1,1] range and not contain a DC offset. Nevertheless, due to the unpredictable nature of the systems, peak limits cannot be guaranteed.  In addition, some energy near DC may be produced; therefore a configurable high-pass filter is part of the circuit. It can be turned off by setting the hp parameter to zero.

The output signal varies with the sample rate.

source: http://quitte.de/dsp/caps.html#Fractals
', 'http://moddevices.com/plugins/caps/Fractal', 21, 3),
           ('C* EqFA4p - 4-band parametric shelving equalizer', 'Four Mitra-Regalia peaking equaliser filters in series; a vector arithmetic re-implementation of Fons Adriaensens "Parametric1" equaliser with minor differences.

source: http://quitte.de/dsp/caps.html#EqFA4p
', 'http://moddevices.com/plugins/caps/EqFA4p', 21, 4),
           ('C* Eq4p - 4-band parametric equaliser', 'Four adjustable biquad filters in series, in a vector arithmetic implementation. The default setup is an identity filter with a mode configuration of lowshelve, band, band, hishelve, all at zero gain.

The Q control value maps non-linearly to actual filter Q: a zero control value results in filter Q of ½, a value of 0.3 corresponds to a Butterworth-equivalent Q of ½√2, and the maximum control setting of 1 results in a filter Q of 50.

Parallelisation of the serial filter topology causes its response to lag by three samples.

Control response is smoothened by crossfading between two filter banks.

source: http://quitte.de/dsp/caps.html#Eq4p
', 'http://moddevices.com/plugins/caps/Eq4p', 21, 5),
           ('C* Eq10X2 - 10-band equalizer', 'The controls of this stereo version of Eq apply to both channels.

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://moddevices.com/plugins/caps/Eq10X2', 21, 2),
           ('C* Eq10 - 10-band equalizer', 'A classic octave-band biquad-filter design, basically a direct digital translation of the analog original. There''s also a stereo version (Eq10X2).

Frequency bands centered above Nyquist are automatically disabled.

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://moddevices.com/plugins/caps/Eq10', 21, 3),
           ('C* CompressX2 - Stereo compressor', 'This stereo version of Compress applies uniform compression to both channels in proportion to their combined power.

source: http://quitte.de/dsp/caps.html#Compress
', 'http://moddevices.com/plugins/caps/CompressX2', 21, 4),
           ('C* Compress - Mono compressor', 'This compressor has been designed primarily to create natural-sounding sustain for the electric guitar without sacrificing its brightly percussive character. However, it appears to apply well to a variety of other sound sources, and with CompressX2 a stereo version is available as well.

To be able produce strong compression and still maintain a natural sound, the design catches (attack-phase) power spikes with a soft saturation circuit, converting them into additional harmonic content and enforcing a strict limit on the output level. Saturating operation is the default setting of the mode control. Three anti-aliasing options are available, 2x oversampling with 32-tap filters and 4x with 64 and 128 taps.

The measure control select which indicator of loudness to base calculations on: peak – instantaneous amplitude – measurement allows the unit to react very quickly, while rms – root mean square power – is of a gentler kind.

Compression amount is controlled through the strength knob, from 0 effectively disabling the effect, up to a maximum ratio of 16:1. The attack and release controls map higher values to slower reactions.

source: http://quitte.de/dsp/caps.html#Compress
', 'http://moddevices.com/plugins/caps/Compress', 21, 5),
           ('C* Click - Metronome', 'A sample-accurate metronome. Two simplistic modal synthesis models are available for the click: box is a small wooden box struck with a soft wooden mallet, stick a scratchy stick hit. In addition, there''s also a very synthetic beep, and finally dirac, a very nasty single-sample pulse of 0 dB amplitude and little immediate musical use.
All click sounds are synthesised once when the plugin is loaded and then played back from memory.

source: http://quitte.de/dsp/caps.html#Click
', 'http://moddevices.com/plugins/caps/Click', 21, 2),
           ('C* ChorusI - Mono chorus/flanger', 'A standard mono chorus with optional feedback. The parameter range suits subtle effects as well as all-out flanging.

Modifying the delay time t when feedback is active will cause audible ''zipper'' noise.

source: http://quitte.de/dsp/caps.html#ChorusI
', 'http://moddevices.com/plugins/caps/ChorusI', 21, 3),
           ('C* CEO - Chief Executive Oscillator', 'The Chief Executive Oscillator forever calls for more profit.

Sound data created with the flite[flite] application.

source: http://quitte.de/dsp/caps.html#CEO
', 'http://moddevices.com/plugins/caps/CEO', 21, 4),
           ('C* CabinetIV - Idealised loudspeaker cabinet emulation', 'This plugin applies an acoustic instrument body modeling technique to recreate the timbre-shaping of an electric instrument amplifier''s speaker cabinet. Nonlinear effects occurring in physical speakers under high load are not emulated.

A selection of several hundred response shapes automatically created in the likeness of classic cabinets has been narrowed down to a handful of idealised tones.  As with AmpVTS, which provides a matching recreation of traditional guitar amplification, the design and selection process has been ruled by musicality over fidelity.

The filter banks implemented are 64 2nd order IIR and one 128-tap FIR in parallel. Their parameter presets are shared between the 44.1 and 48 kHz sample rates, the higher rate implying that timbre brightens up. Higher sample rates produce the same tones by rate conversion, up to 192 kHz.

Despite the complexity, computational load is very modest thanks to vector arithmetic if a hardware implementation is available – if not, however, the load will be easily an order of magnitude higher, and possibly found to be prohibitive on less powerful hardware.

source: http://quitte.de/dsp/caps.html#CabinetIV
', 'http://moddevices.com/plugins/caps/CabinetIV', 21, 5),
           ('C* CabinetIII - Idealised loudspeaker cabinet emulation', 'A loudspeaker cabinet emulation far less demanding than the recommended CabinetIV.  Implemented as two sets of 31st-order IIR filters precomputed (using Prony''s method) for fs of 44.1 and 48 kHz.

The appropriate filter set is selected at runtime.  The alt switch allows the selection of the same fiter model for the alternative sample rate; at 48 kHz the alternative will sound slightly darker, at 44.1 slightly brighter.  At other sample rates, the plugin will not sound very much like a guitar speaker cabinet.

source: http://quitte.de/dsp/caps.html#CabinetIII
', 'http://moddevices.com/plugins/caps/CabinetIII', 21, 2),
           ('C* AutoFilter', 'A versatile selection of filters of varying character in band and lowpass configuration. The cutoff frequency can be modulated by both the input signal envelope and by a fractal oscillator. The default settings provide some sort of an automatic wah effect.

The extent of filter modulation is set through the range parameter. The shape of the modulation is mixed from the attractor and the envelope according to the lfo/env balance.

Filter stage gain can be used to add inter-stage saturation. To prevent this from causing audible aliasing, the plugin can be run in oversampled mode, at ratios selectable through the over control.

At very high Q and f combined, the filter stability may become compromised. Computational load varies greatly with the over and filter settings.

source: http://quitte.de/dsp/caps.html#AutoFilter
', 'http://moddevices.com/plugins/caps/AutoFilter', 21, 3),
           ('C* AmpVTS - Tube amp + Tone stack', 'Tracing the stages of a typical tube amplifier circuit, this plugin aims to recreate those features of traditional guitar amplification electronics that have proved musically useful, and to provide them with the most musical rather than the most authentic ranges of adjustment and character.  CabinetIV provides matching recreations of loudspeaker cabinets.

The processor consists – with some interconnections – of a configurable lowcut input filter, a ToneStack circuit of the procedural variant, a saturating ''preamp'' stage with adjustable gain and variable distortion asymmetry followed by the bright filter, compression characteristics determined by the attack and squash controls and finally a ''power amp'' stage with the amount of saturation depending on both gain and power settings.

Sound quality and computational load can be balanced with the over control affording a choice of 2x or 4x oversampling with 32-tap filters, or 8x with 64 taps.  Lower quality settings will sound slightly grittier and less transparent, and at high gain aliasing may become audible.

source: http://quitte.de/dsp/caps.html#AmpVTS
', 'http://moddevices.com/plugins/caps/AmpVTS', 21, 4),
           ('Calf Envelope Filter', '      The louder you play, the higher the filter
    ', 'http://calf.sourceforge.net/plugins/EnvelopeFilter', 22, 5),
           ('Calf X-Over 4 Band', '', 'http://calf.sourceforge.net/plugins/XOver4Band', 22, 2),
           ('Calf X-Over 3 Band', '', 'http://calf.sourceforge.net/plugins/XOver3Band', 22, 3),
           ('Calf X-Over 2 Band', '', 'http://calf.sourceforge.net/plugins/XOver2Band', 22, 4),
           ('Calf Vocoder', '', 'http://calf.sourceforge.net/plugins/Vocoder', 22, 5),
           ('Calf Vintage Delay', '    DELAY DELay delay
    ', 'http://calf.sourceforge.net/plugins/VintageDelay', 22, 2),
           ('Calf Transient Designer', '', 'http://calf.sourceforge.net/plugins/TransientDesigner', 22, 3),
           ('Calf Tape Simulator', '', 'http://calf.sourceforge.net/plugins/TapeSimulator', 22, 4),
           ('Calf Stereo Tools', '', 'http://calf.sourceforge.net/plugins/StereoTools', 22, 5),
           ('Calf Sidechain Limiter', '', 'http://calf.sourceforge.net/plugins/SidechainLimiter', 22, 2),
           ('Calf Sidechain Gate', '', 'http://calf.sourceforge.net/plugins/SidechainGate', 22, 3),
           ('Calf Sidechain Compressor', '', 'http://calf.sourceforge.net/plugins/SidechainCompressor', 22, 4),
           ('Calf Saturator', '', 'http://calf.sourceforge.net/plugins/Saturator', 22, 5),
           ('Calf Rotary Speaker', '', 'http://calf.sourceforge.net/plugins/RotarySpeaker', 22, 2),
           ('Calf Ring Modulator', '    ring ring!
    ', 'http://calf.sourceforge.net/plugins/RingModulator', 22, 3),
           ('Calf Reverse Delay', '', 'http://calf.sourceforge.net/plugins/ReverseDelay', 22, 4),
           ('Calf Reverb', '', 'http://calf.sourceforge.net/plugins/Reverb', 22, 5),
           ('Calf Pulsator', '', 'http://calf.sourceforge.net/plugins/Pulsator', 22, 2),
           ('Calf Phaser', '    Just phase it.
    ', 'http://calf.sourceforge.net/plugins/Phaser', 22, 3),
           ('Calf Organ', '    Sounds like an organ, or whatever else you want.
    ', 'http://calf.sourceforge.net/plugins/Organ', 22, 4),
           ('Calf Multiband Limiter', '', 'http://calf.sourceforge.net/plugins/MultibandLimiter', 22, 5),
           ('Calf Multiband Gate', '', 'http://calf.sourceforge.net/plugins/MultibandGate', 22, 2),
           ('Calf Multiband Compressor', '', 'http://calf.sourceforge.net/plugins/MultibandCompressor', 22, 3),
           ('Calf Multi Chorus', '    Why use one chorus if you can use more?
    ', 'http://calf.sourceforge.net/plugins/MultiChorus', 22, 4),
           ('Calf Monosynth', '', 'http://calf.sourceforge.net/plugins/Monosynth', 22, 5),
           ('Calf Mono Input', '', 'http://calf.sourceforge.net/plugins/MonoInput', 22, 2),
           ('Calf Mono Compressor', '', 'http://calf.sourceforge.net/plugins/MonoCompressor', 22, 3),
           ('Calf Limiter', '    Enough, is enough.
    ', 'http://calf.sourceforge.net/plugins/Limiter', 22, 4),
           ('Calf Haas Stereo Enhancer', '', 'http://calf.sourceforge.net/plugins/HaasEnhancer', 22, 5),
           ('Calf Gate', '    For when you don''t want noise
    ', 'http://calf.sourceforge.net/plugins/Gate', 22, 2),
           ('Calf Flanger', '    ''wieeuw'' -Flanger
    ', 'http://calf.sourceforge.net/plugins/Flanger', 22, 3),
           ('Calf Filterclavier', '    Play the filter with a keyboard!
    ', 'http://calf.sourceforge.net/plugins/Filterclavier', 22, 4),
           ('Calf Filter', '', 'http://calf.sourceforge.net/plugins/Filter', 22, 5),
           ('Calf Exciter', '', 'http://calf.sourceforge.net/plugins/Exciter', 22, 2),
           ('Calf Equalizer 8 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer8Band', 22, 3),
           ('Calf Equalizer 5 Band', '    Easy to use equalizer
    ', 'http://calf.sourceforge.net/plugins/Equalizer5Band', 22, 4),
           ('Calf Equalizer 30 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer30Band', 22, 5),
           ('Calf Equalizer 12 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer12Band', 22, 2),
           ('Calf Emphasis', '', 'http://calf.sourceforge.net/plugins/Emphasis', 22, 3),
           ('Calf Deesser', '', 'http://calf.sourceforge.net/plugins/Deesser', 22, 4),
           ('Calf Crusher', '', 'http://calf.sourceforge.net/plugins/Crusher', 22, 5),
           ('Calf Compressor', '    Compressor
    ', 'http://calf.sourceforge.net/plugins/Compressor', 22, 2),
           ('Calf Compensation Delay Line', '', 'http://calf.sourceforge.net/plugins/CompensationDelay', 22, 3),
           ('Calf Bass Enhancer', '', 'http://calf.sourceforge.net/plugins/BassEnhancer', 22, 4),
           ('Triangle', '', 'http://drobilla.net/plugins/blop/triangle', 23, 5),
           ('Square', '', 'http://drobilla.net/plugins/blop/square', 23, 2),
           ('Sawtooth', '', 'http://drobilla.net/plugins/blop/sawtooth', 23, 3),
           ('Tracker', '', 'http://drobilla.net/plugins/blop/tracker', 23, 4),
           ('Clock Square', '', 'http://drobilla.net/plugins/blop/sync_square', 23, 5),
           ('Clock Pulse', '', 'http://drobilla.net/plugins/blop/sync_pulse', 23, 2),
           ('64 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_64', 23, 3),
           ('32 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_32', 23, 4),
           ('16 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_16', 23, 5),
           ('Random Wave', '', 'http://drobilla.net/plugins/blop/random', 23, 2),
           ('Quantiser (50 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_50', 23, 3),
           ('Quantiser (20 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_20', 23, 4),
           ('Quantiser (100 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_100', 23, 5),
           ('Pulse', '', 'http://drobilla.net/plugins/blop/pulse', 23, 2),
           ('4 Pole Resonant Low-Pass', '', 'http://drobilla.net/plugins/blop/lp4pole', 23, 3),
           ('Control to CV Interpolator', '', 'http://drobilla.net/plugins/blop/interpolator', 23, 4),
           ('Retriggerable DAHDSR Envelope', '', 'http://drobilla.net/plugins/blop/dahdsr', 23, 5),
           ('Amplifier', '', 'http://drobilla.net/plugins/blop/amp', 23, 2),
           ('Retriggerable ADSR Envelope', '', 'http://drobilla.net/plugins/blop/adsr_gt', 23, 3),
           ('ADSR Envelope', '', 'http://drobilla.net/plugins/blop/adsr', 23, 4),
           ('Roomy', 'A spacious open algorithmic reverb.', 'http://www.openavproductions.com/artyfx#roomy', 19, 5),
           ('Kuiza', 'A 4 band equalizer with preset bands.', 'http://www.openavproductions.com/artyfx#kuiza', 19, 2),
           ('Filta', 'Highpass lowpass filter combination.', 'http://www.openavproductions.com/artyfx#filta', 19, 3),
           ('Whaaa', 'A wah pedal.', 'http://www.openavproductions.com/artyfx#whaaa', 19, 4),
           ('Vihda', 'A stereo widener plugin based on a mid-side matrix with inversion of the right channel.', 'http://www.openavproductions.com/artyfx#vihda', 19, 5),
           ('Satma', 'A distortion maximizer effect.', 'http://www.openavproductions.com/artyfx#satma', 19, 2),
           ('Panda', 'A compressor expander limiter that can squeeze the dynamics out of any signal.', 'http://www.openavproductions.com/artyfx#panda', 19, 3),
           ('Masha', 'A beat-stutter type effect.', 'http://www.openavproductions.com/artyfx#masha', 19, 4),
           ('Ducka', 'Sidechain envelope plugin, changes the volume of the main audio based on the amplitude of a sidechain signal.', 'http://www.openavproductions.com/artyfx#ducka', 19, 5),
           ('Driva', 'Digital guitar distortion, including multiple different tone sorts and waveshaping functions.', 'http://www.openavproductions.com/artyfx#driva', 19, 2),
           ('Della', 'BPM dependant delay with feedback', 'http://www.openavproductions.com/artyfx#della', 19, 3),
           ('Bitta', 'Bit crushing causes bit-reduction type distortion', 'http://www.openavproductions.com/artyfx#bitta', 19, 4),
           ('amsynth', 'A Very Big Synth', 'http://code.google.com/p/amsynth/amsynth', 24, 5),
           ('abGate', '', 'http://hippie.lt/lv2/gate', 25, 2),
           ('ZynReverb', '', 'http://zynaddsubfx.sourceforge.net/fx#Reverb', 26, 3),
           ('ZynPhaser', '', 'http://zynaddsubfx.sourceforge.net/fx#Phaser', 26, 4),
           ('ZynEcho', '', 'http://zynaddsubfx.sourceforge.net/fx#Echo', 26, 5),
           ('ZynDynamicFilter', '', 'http://zynaddsubfx.sourceforge.net/fx#DynamicFilter', 26, 2),
           ('ZynDistortion', '', 'http://zynaddsubfx.sourceforge.net/fx#Distortion', 26, 3),
           ('ZynChorus', '', 'http://zynaddsubfx.sourceforge.net/fx#Chorus', 26, 4),
           ('ZynAlienWah', '', 'http://zynaddsubfx.sourceforge.net/fx#AlienWah', 26, 5),
           ('ZynAddSubFX', '', 'http://zynaddsubfx.sourceforge.net', 26, 2);

 INSERT INTO efeito.categoria_efeito (id_categoria, id_efeito) 
      VALUES 
           (3, 16),
           (4, 16),
           (5, 18),
           (5, 19),
           (5, 20),
           (5, 21),
           (5, 22),
           (5, 23),
           (5, 24),
           (5, 25),
           (5, 26),
           (5, 27),
           (5, 28),
           (5, 29),
           (5, 30),
           (5, 31),
           (5, 32),
           (5, 33),
           (5, 34),
           (5, 35),
           (5, 36),
           (5, 37),
           (5, 38),
           (5, 39),
           (5, 40),
           (5, 41),
           (5, 42),
           (5, 43),
           (5, 44),
           (6, 48),
           (7, 49),
           (8, 49),
           (9, 50),
           (10, 51),
           (9, 52),
           (11, 53),
           (9, 54),
           (12, 55),
           (13, 56),
           (14, 57),
           (15, 57),
           (7, 58),
           (16, 59),
           (17, 59),
           (5, 60),
           (18, 60),
           (5, 61),
           (18, 61),
           (13, 62),
           (16, 63),
           (16, 64),
           (14, 65),
           (16, 66),
           (9, 67),
           (6, 68),
           (3, 69),
           (12, 70),
           (14, 71),
           (15, 71),
           (13, 72),
           (9, 73),
           (10, 74),
           (10, 75),
           (7, 76),
           (8, 76),
           (12, 77),
           (11, 78),
           (12, 79),
           (5, 80),
           (18, 80),
           (19, 80),
           (11, 81),
           (11, 82),
           (5, 83),
           (6, 84),
           (14, 85),
           (15, 85),
           (5, 86),
           (18, 86),
           (20, 86),
           (12, 87),
           (11, 88),
           (13, 89),
           (16, 90),
           (21, 90),
           (9, 91),
           (22, 91),
           (5, 92),
           (9, 93),
           (23, 93),
           (9, 94),
           (23, 94),
           (9, 95),
           (9, 96),
           (9, 97),
           (11, 98),
           (5, 99),
           (16, 100),
           (21, 100),
           (11, 101),
           (14, 102),
           (15, 102),
           (6, 103),
           (14, 104),
           (15, 104),
           (5, 105),
           (5, 106),
           (9, 107),
           (12, 108),
           (9, 109),
           (5, 110),
           (9, 111),
           (16, 112),
           (24, 112),
           (11, 113),
           (12, 114),
           (13, 115),
           (9, 116),
           (25, 116),
           (11, 117),
           (16, 118),
           (21, 118),
           (5, 119),
           (13, 120),
           (3, 121),
           (3, 122),
           (3, 123),
           (5, 124),
           (5, 125),
           (3, 126),
           (3, 127),
           (5, 128),
           (5, 129),
           (5, 130),
           (14, 131),
           (14, 132),
           (14, 133),
           (14, 134),
           (14, 135),
           (14, 136),
           (14, 137),
           (14, 138),
           (14, 139),
           (14, 140),
           (16, 141),
           (14, 142),
           (9, 143),
           (25, 143),
           (7, 144),
           (5, 145),
           (14, 146),
           (6, 147),
           (16, 148),
           (7, 149),
           (6, 150),
           (9, 151),
           (5, 152),
           (14, 153),
           (15, 153),
           (7, 154),
           (8, 154),
           (11, 155),
           (16, 156),
           (21, 156),
           (16, 157),
           (16, 158),
           (17, 158),
           (10, 159),
           (7, 160),
           (8, 160),
           (6, 161),
           (7, 162),
           (8, 162),
           (16, 163),
           (7, 164),
           (8, 164),
           (13, 165),
           (11, 166),
           (14, 167),
           (15, 167),
           (13, 168),
           (11, 169),
           (16, 170),
           (10, 171),
           (7, 172),
           (11, 173),
           (12, 174),
           (11, 175),
           (11, 176),
           (9, 177),
           (23, 177),
           (9, 178),
           (23, 178),
           (9, 179),
           (23, 179),
           (13, 180),
           (13, 181),
           (11, 182),
           (11, 183),
           (7, 184),
           (26, 184),
           (3, 185),
           (5, 186),
           (27, 186),
           (5, 187),
           (27, 187),
           (5, 188),
           (28, 188),
           (5, 189),
           (28, 189),
           (12, 190),
           (12, 191),
           (16, 192),
           (21, 192),
           (16, 193),
           (21, 193),
           (11, 194),
           (5, 195),
           (3, 196),
           (29, 196),
           (9, 197),
           (9, 198),
           (13, 199),
           (11, 200),
           (11, 201),
           (10, 202),
           (10, 203),
           (13, 204),
           (3, 205),
           (5, 206),
           (12, 207),
           (9, 208),
           (9, 209),
           (11, 210),
           (10, 211),
           (10, 212),
           (12, 213),
           (11, 214),
           (12, 215),
           (12, 216),
           (16, 217),
           (30, 217),
           (16, 218),
           (30, 218),
           (16, 219),
           (30, 219),
           (11, 220),
           (9, 221),
           (23, 221),
           (14, 222),
           (15, 222),
           (11, 223),
           (11, 224),
           (12, 225),
           (13, 226),
           (11, 227),
           (13, 228),
           (16, 229),
           (21, 229),
           (3, 230),
           (10, 231),
           (10, 232),
           (11, 233),
           (11, 234),
           (11, 235),
           (5, 236),
           (18, 236),
           (5, 237),
           (11, 238),
           (11, 239),
           (11, 240),
           (11, 241),
           (9, 242),
           (25, 242),
           (16, 243),
           (24, 243),
           (13, 244),
           (13, 245),
           (13, 246),
           (13, 247),
           (13, 248),
           (14, 249),
           (15, 249),
           (13, 250),
           (11, 251),
           (16, 252),
           (21, 252),
           (9, 253),
           (9, 254),
           (22, 254),
           (10, 255),
           (5, 256),
           (18, 256),
           (10, 257),
           (10, 258),
           (12, 260),
           (11, 262),
           (9, 263),
           (22, 263),
           (12, 264),
           (9, 265),
           (23, 265),
           (9, 266),
           (22, 266),
           (9, 267),
           (22, 267),
           (5, 268),
           (7, 269),
           (26, 269),
           (12, 270),
           (7, 271),
           (26, 271),
           (7, 272),
           (26, 272),
           (5, 273),
           (18, 273),
           (19, 273),
           (5, 274),
           (27, 274),
           (5, 275),
           (27, 275),
           (5, 276),
           (27, 276),
           (5, 277),
           (27, 277),
           (5, 278),
           (28, 278),
           (9, 279),
           (23, 279),
           (7, 280),
           (8, 280),
           (7, 281),
           (8, 281),
           (7, 282),
           (8, 282),
           (7, 283),
           (8, 283),
           (7, 284),
           (8, 284),
           (7, 285),
           (8, 285),
           (7, 286),
           (8, 286),
           (7, 287),
           (8, 287),
           (7, 288),
           (8, 288),
           (7, 289),
           (8, 289),
           (7, 290),
           (8, 290),
           (7, 291),
           (8, 291),
           (7, 292),
           (8, 292),
           (7, 293),
           (8, 293),
           (7, 294),
           (8, 294),
           (7, 295),
           (8, 295),
           (7, 296),
           (8, 296),
           (7, 297),
           (8, 297),
           (7, 298),
           (8, 298),
           (11, 299),
           (31, 299),
           (6, 300),
           (7, 301),
           (8, 301),
           (12, 302),
           (14, 303),
           (15, 303),
           (12, 304),
           (12, 305),
           (7, 307),
           (8, 307),
           (16, 309),
           (30, 309),
           (5, 310),
           (18, 310),
           (5, 311),
           (18, 311),
           (6, 312),
           (7, 313),
           (10, 314),
           (16, 315),
           (16, 316),
           (7, 317),
           (26, 317),
           (13, 318),
           (11, 319),
           (12, 320),
           (12, 321),
           (9, 322),
           (23, 322),
           (3, 323),
           (6, 324),
           (7, 325),
           (5, 326),
           (18, 326),
           (5, 327),
           (18, 327),
           (5, 328),
           (18, 328),
           (5, 329),
           (18, 329),
           (16, 330),
           (21, 330),
           (16, 331),
           (21, 331),
           (3, 332),
           (9, 333),
           (22, 333),
           (7, 334),
           (26, 334),
           (10, 335),
           (10, 336),
           (5, 337),
           (10, 338),
           (5, 339),
           (3, 340),
           (3, 341),
           (3, 342),
           (5, 343),
           (13, 344),
           (10, 346),
           (6, 347),
           (16, 348),
           (17, 348),
           (16, 349),
           (24, 349),
           (16, 350),
           (21, 350),
           (11, 351),
           (10, 352),
           (9, 353),
           (13, 354),
           (12, 355),
           (9, 356),
           (9, 357),
           (7, 358),
           (8, 358),
           (16, 359),
           (17, 359),
           (16, 360),
           (24, 360),
           (16, 361),
           (21, 361),
           (9, 362),
           (7, 363),
           (8, 363),
           (3, 364),
           (16, 365),
           (21, 365),
           (16, 366),
           (17, 366),
           (6, 367),
           (16, 368),
           (24, 368),
           (9, 369),
           (5, 370),
           (5, 371),
           (14, 372),
           (5, 373),
           (18, 373),
           (5, 374),
           (18, 374),
           (5, 375),
           (18, 375),
           (5, 376),
           (18, 376),
           (5, 377),
           (16, 378),
           (21, 378),
           (11, 379),
           (16, 380),
           (21, 380),
           (3, 381),
           (14, 382),
           (7, 383),
           (26, 383),
           (7, 384),
           (26, 384),
           (7, 385),
           (26, 385),
           (7, 387),
           (26, 387),
           (7, 388),
           (26, 388),
           (7, 392),
           (26, 392),
           (7, 396),
           (26, 396),
           (5, 397),
           (27, 397),
           (3, 398),
           (16, 400),
           (30, 400),
           (12, 403),
           (5, 404),
           (18, 404),
           (5, 405),
           (11, 408),
           (13, 410),
           (11, 412),
           (13, 413),
           (11, 414),
           (7, 415),
           (8, 415),
           (16, 416),
           (32, 416),
           (12, 417),
           (9, 418),
           (23, 418),
           (13, 419),
           (5, 420),
           (11, 421),
           (9, 422),
           (22, 422),
           (9, 423),
           (23, 423),
           (7, 424),
           (8, 424);

 INSERT INTO efeito.parametro (id_efeito, nome, minimo, maximo, valor_padrao) 
      VALUES 
           (3, 'Attack1', 0.10000000149011612, 100, 10),
           (3, 'Attack2', 0.10000000149011612, 100, 10),
           (3, 'Attack3', 0.10000000149011612, 100, 10),
           (3, 'Release1', 1, 500, 80),
           (3, 'Release2', 1, 500, 80),
           (3, 'Release3', 1, 500, 80),
           (3, 'Knee1', 0, 8, 0),
           (3, 'Knee2', 0, 8, 0),
           (3, 'Knee3', 0, 8, 0),
           (3, 'Ratio1', 1, 20, 4),
           (3, 'Ratio2', 1, 20, 4),
           (3, 'Ratio3', 1, 20, 4),
           (3, 'Threshold 1', -60, 0, -20),
           (3, 'Threshold 2', -60, 0, -18),
           (3, 'Threshold 3', -60, 0, -16),
           (3, 'Makeup 1', 0, 30, 0),
           (3, 'Makeup 2', 0, 30, 0),
           (3, 'Makeup 3', 0, 30, 0),
           (3, 'Crossover freq 1', 20, 1400, 160),
           (3, 'Crossover freq 2', 1400, 14000, 1400),
           (3, 'ZamComp 1 ON', 0, 1, 0),
           (3, 'ZamComp 2 ON', 0, 1, 0),
           (3, 'ZamComp 3 ON', 0, 1, 0),
           (3, 'Listen 1', 0, 1, 0),
           (3, 'Listen 2', 0, 1, 0),
           (3, 'Listen 3', 0, 1, 0),
           (3, 'Detection (MAX/avg)', 0, 1, 1),
           (3, 'Master Trim', -12, 12, 0),
           (4, 'Attack1', 0.10000000149011612, 100, 10),
           (4, 'Attack2', 0.10000000149011612, 100, 10),
           (4, 'Attack3', 0.10000000149011612, 100, 10),
           (4, 'Release1', 1, 500, 80),
           (4, 'Release2', 1, 500, 80),
           (4, 'Release3', 1, 500, 80),
           (4, 'Knee1', 0, 8, 0),
           (4, 'Knee2', 0, 8, 0),
           (4, 'Knee3', 0, 8, 0),
           (4, 'Ratio1', 1, 20, 4),
           (4, 'Ratio2', 1, 20, 4),
           (4, 'Ratio3', 1, 20, 4),
           (4, 'Threshold 1', -60, 0, -20),
           (4, 'Threshold 2', -60, 0, -18),
           (4, 'Threshold 3', -60, 0, -16),
           (4, 'Makeup 1', 0, 30, 0),
           (4, 'Makeup 2', 0, 30, 0),
           (4, 'Makeup 3', 0, 30, 0),
           (4, 'Crossover freq 1', 20, 1400, 160),
           (4, 'Crossover freq 2', 1400, 14000, 1400),
           (4, 'ZamComp 1 ON', 0, 1, 0),
           (4, 'ZamComp 2 ON', 0, 1, 0),
           (4, 'ZamComp 3 ON', 0, 1, 0),
           (4, 'Listen 1', 0, 1, 0),
           (4, 'Listen 2', 0, 1, 0),
           (4, 'Listen 3', 0, 1, 0),
           (4, 'Master Trim', -12, 12, 0),
           (5, 'Tube Drive', -30, 30, 0),
           (5, 'Bass', 0, 1, 0.5),
           (5, 'Mids', 0, 1, 0.5),
           (5, 'Treble', 0, 1, 0),
           (5, 'Tone Stack Model', 0, 24, 0),
           (5, 'Output level', -15, 15, 0),
           (5, 'Quality Insane', 0, 1, 0),
           (6, 'Azimuth', -90, 270, 0),
           (6, 'Elevation', -45, 90, 0),
           (6, 'Width', 0, 2.5, 1),
           (7, 'Master Gain', -30, 30, 0),
           (7, '32Hz', -12, 12, 0),
           (7, '40Hz', -12, 12, 0),
           (7, '50Hz', -12, 12, 0),
           (7, '63Hz', -12, 12, 0),
           (7, '79Hz', -12, 12, 0),
           (7, '100Hz', -12, 12, 0),
           (7, '126Hz', -12, 12, 0),
           (7, '158Hz', -12, 12, 0),
           (7, '200Hz', -12, 12, 0),
           (7, '251Hz', -12, 12, 0),
           (7, '316Hz', -12, 12, 0),
           (7, '398Hz', -12, 12, 0),
           (7, '501Hz', -12, 12, 0),
           (7, '631Hz', -12, 12, 0),
           (7, '794Hz', -12, 12, 0),
           (7, '999Hz', -12, 12, 0),
           (7, '1257Hz', -12, 12, 0),
           (7, '1584Hz', -12, 12, 0),
           (7, '1997Hz', -12, 12, 0),
           (7, '2514Hz', -12, 12, 0),
           (7, '3165Hz', -12, 12, 0),
           (7, '3986Hz', -12, 12, 0),
           (7, '5017Hz', -12, 12, 0),
           (7, '6318Hz', -12, 12, 0),
           (7, '7963Hz', -12, 12, 0),
           (7, '10032Hz', -12, 12, 0),
           (7, '12662Hz', -12, 12, 0),
           (7, '16081Hz', -12, 12, 0),
           (7, '20801Hz', -12, 12, 0),
           (8, 'Attack', 0.10000000149011612, 500, 50),
           (8, 'Release', 0.10000000149011612, 500, 100),
           (8, 'Threshold', -60, 0, -60),
           (8, 'Makeup', -30, 30, 0),
           (9, 'Attack', 0.10000000149011612, 500, 50),
           (9, 'Release', 0.10000000149011612, 500, 100),
           (9, 'Threshold', -60, 0, -60),
           (9, 'Makeup', -30, 30, 0),
           (10, 'Boost/Cut 1', -50, 20, 0),
           (10, 'Bandwidth 1', 0.10000000149011612, 6, 1),
           (10, 'Frequency 1', 20, 14000, 500),
           (10, 'Boost/Cut 2', -50, 20, 0),
           (10, 'Bandwidth 2', 0.10000000149011612, 6, 1),
           (10, 'Frequency 2', 20, 14000, 3000),
           (10, 'Boost/Cut L', -50, 20, 0),
           (10, 'Frequency L', 20, 14000, 250),
           (10, 'Boost/Cut H', -50, 20, 0),
           (10, 'Frequency H', 20, 14000, 8000),
           (10, 'Master Gain', -12, 12, 0),
           (10, 'Peaks ON', 0, 1, 0),
           (11, 'Invert', 0, 1, 0),
           (11, 'Time', 1, 8000, 160),
           (11, 'Sync BPM', 0, 1, 0),
           (11, 'LPF', 20, 20000, 6000),
           (11, 'Divisor', 1, 5, 3),
           (11, 'Output Gain', -60, 0, 0),
           (11, 'Dry/Wet', 0, 1, 0.5),
           (11, 'Feedback', 0, 1, 0),
           (12, 'Attack', 0.10000000149011612, 100, 10),
           (12, 'Release', 1, 500, 80),
           (12, 'Knee', 0, 8, 0),
           (12, 'Ratio', 1, 20, 4),
           (12, 'Threshold', -80, 0, 0),
           (12, 'Makeup', 0, 30, 0),
           (12, 'Slew', 1, 150, 1),
           (12, 'Stereo Detection', 0, 1, 0),
           (13, 'Attack', 0.10000000149011612, 100, 10),
           (13, 'Release', 1, 500, 80),
           (13, 'Knee', 0, 8, 0),
           (13, 'Ratio', 1, 20, 4),
           (13, 'Threshold', -80, 0, 0),
           (13, 'Makeup', 0, 30, 0),
           (13, 'Slew', 1, 150, 1),
           (14, 'Release', 1, 100, 25),
           (14, 'Output Ceiling', -30, 0, -3),
           (14, 'Threshold', -30, 0, 0),
           (16, 'Signal A/B', -1, 1, 0),
           (16, 'Shape', 0, 1, 0),
           (16, 'Mode', 0, 1, 0),
           (17, 'delay (samples)', 0, 192000, 0),
           (17, 'report delay as latency', 0, 1, 1),
           (18, 'Channel', 0, 16, 0),
           (18, 'Note-on Min', 1, 127, 1),
           (18, 'Note-on Max', 0, 127, 127),
           (18, 'Note-on Offset', -64, 64, 0),
           (18, 'Note-off Min', 0, 127, 0),
           (18, 'Note-off Max', 0, 127, 127),
           (18, 'Note-off Offset', -64, 64, 0),
           (19, 'Filter Channel', 0, 16, 0),
           (19, 'Min Volume', 0, 127, 0),
           (19, 'Max Volume', 0, 127, 127),
           (19, 'Operation Mode', 0, 3, 1),
           (20, 'Filter Channel', 0, 16, 0),
           (20, 'Sostenuto [sec]', 0, 600, 0),
           (20, 'Pedal Mode', 0, 2, 1),
           (21, 'Filter Channel', 0, 16, 0),
           (21, 'Parameter (Min)', 0, 127, 0),
           (21, 'Parameter (Max)', 0, 127, 127),
           (21, 'Parameter Mode', 0, 3, 1),
           (21, 'Value Scale', -10, 10, 1),
           (21, 'Value Offset', -64, 64, 0),
           (21, 'Value Mode', 0, 3, 0),
           (22, 'Filter Channel', 0, 16, 0),
           (22, 'Velocity Randomization', 0, 127, 8),
           (22, 'Random Mode', 0, 1, 1),
           (23, 'BPM source', 0, 1, 1),
           (23, 'BPM', 1, 280, 120),
           (23, 'Quantization Grid', 0.00390625, 4, 0.25),
           (23, 'Note-off behaviour', 0, 1, 1),
           (25, 'Filter Channel', 0, 16, 0),
           (25, 'BPM source', 0, 1, 1),
           (25, 'BPM', 1, 280, 120),
           (25, 'Repeat-time in beats', 0.00390625, 16, 1),
           (25, 'Repeats', 0, 64, 3),
           (25, 'velocity ramp', -64, 64, -10),
           (26, 'Filter Channel', 0, 16, 0),
           (27, 'Filter Channel', 0, 16, 0),
           (27, 'Operation Mode', 0, 3, 0),
           (27, 'CC Parameter', 0, 127, 0),
           (27, 'Active Key (midi-note)', 0, 127, 48),
           (28, 'Filter Channel', 0, 16, 0),
           (30, 'Filter Channel', 0, 16, 0),
           (31, 'Filter Channel', 0, 16, 0),
           (31, 'Transpose', -72, 72, 0),
           (31, 'Inversion point', 0, 127, 0),
           (32, 'BPM source', 0, 1, 1),
           (32, 'BPM', 1, 280, 120),
           (32, 'Strum Direction', 0, 4, 2),
           (32, 'Note Collect Timeout [ms]', 0, 300, 15),
           (32, 'Strum Duration in Beats', 0, 4, 0.25),
           (32, 'Strum Acceleration', -1, 1, 0),
           (32, 'Velocity Change', -112, 112, 0),
           (32, 'Randomize Acceleration', 0, 1, 0),
           (32, 'Randomize Velocity', 0, 1, 0),
           (33, 'Source Channel', 1, 16, 1),
           (33, 'Duplicate to Channel', 1, 16, 2),
           (34, 'BPM source', 0, 1, 1),
           (34, 'BPM', 1, 280, 120),
           (34, 'Delay Beats 4/4', 0, 16, 1),
           (34, 'Randomize [Beats]', 0, 1, 0),
           (35, 'Filter Channel', 0, 16, 0),
           (35, 'Scale', 0, 11, 0),
           (35, 'prime', 0, 1, 1),
           (35, '3rd', 0, 1, 1),
           (35, '5th', 0, 1, 1),
           (35, '6th', 0, 1, 0),
           (35, '7th', 0, 1, 0),
           (35, 'octave', 0, 1, 1),
           (35, '9th', 0, 1, 0),
           (35, '11th', 0, 1, 0),
           (35, '13th', 0, 1, 0),
           (35, 'bass', 0, 1, 0),
           (36, 'Filter Channel', 0, 16, 0),
           (36, 'C', -13, 12, 0),
           (36, 'C#', -13, 12, 0),
           (36, 'D', -13, 12, 0),
           (36, 'D#', -13, 12, 0),
           (36, 'E', -13, 12, 0),
           (36, 'F', -13, 12, 0),
           (36, 'F#', -13, 12, 0),
           (36, 'G', -13, 12, 0),
           (36, 'G#', -13, 12, 0),
           (36, 'A', -13, 12, 0),
           (36, 'A#', -13, 12, 0),
           (36, 'B', -13, 12, 0),
           (37, 'Filter Channel', 0, 16, 0),
           (37, 'CC Input', 0, 127, 0),
           (37, 'CC Output', 0, 127, 0),
           (38, 'Filter Channel', 0, 16, 0),
           (38, 'Splitpoint', 0, 127, 48),
           (38, 'Channel Lower', 1, 16, 1),
           (38, 'Transpose Lower', -48, 48, 0),
           (38, 'Channel Upper', 1, 16, 2),
           (38, 'Transpose Upper', -48, 48, 0),
           (39, 'Filter Channel', 0, 16, 0),
           (39, 'Lowest Note', 0, 127, 0),
           (39, 'Highest Note', 0, 127, 127),
           (39, 'Operation Mode', 0, 3, 1),
           (40, 'Block Control Changes', 0, 1, 0),
           (40, 'Block Notes', 0, 1, 0),
           (40, 'Block Program Changes', 0, 1, 0),
           (40, 'Block Polykey-Pressure', 0, 1, 0),
           (40, 'Block Channel-Pressure', 0, 1, 0),
           (40, 'Block Pitch Bend', 0, 1, 0),
           (40, 'Block Sysex/RT messages', 0, 1, 0),
           (40, 'Block custom message', 0, 1, 0),
           (40, 'Custom Message Type', 0, 6, 0),
           (40, 'Custom message Channel', 0, 16, 0),
           (40, 'Custom message Data1', -1, 127, -1),
           (40, 'Custom message Data2', -1, 127, -1),
           (41, 'Filter Channel', 0, 16, 0),
           (41, 'Scale', 0, 11, 0),
           (41, 'Mode', 0, 2, 0),
           (42, 'Channel  1 to', 0, 16, 1),
           (42, 'Channel  2 to', 0, 16, 2),
           (42, 'Channel  3 to', 0, 16, 3),
           (42, 'Channel  4 to', 0, 16, 4),
           (42, 'Channel  5 to', 0, 16, 5),
           (42, 'Channel  6 to', 0, 16, 6),
           (42, 'Channel  7 to', 0, 16, 7),
           (42, 'Channel  8 to', 0, 16, 8),
           (42, 'Channel  9 to', 0, 16, 9),
           (42, 'Channel 10 to', 0, 16, 10),
           (42, 'Channel 11 to', 0, 16, 11),
           (42, 'Channel 12 to', 0, 16, 12),
           (42, 'Channel 13 to', 0, 16, 13),
           (42, 'Channel 14 to', 0, 16, 14),
           (42, 'Channel 15 to', 0, 16, 15),
           (42, 'Channel 16 to', 0, 16, 16),
           (43, 'Channel  1', 0, 1, 1),
           (43, 'Channel  2', 0, 1, 1),
           (43, 'Channel  3', 0, 1, 1),
           (43, 'Channel  4', 0, 1, 1),
           (43, 'Channel  5', 0, 1, 1),
           (43, 'Channel  6', 0, 1, 1),
           (43, 'Channel  7', 0, 1, 1),
           (43, 'Channel  8', 0, 1, 1),
           (43, 'Channel  9', 0, 1, 1),
           (43, 'Channel 10', 0, 1, 1),
           (43, 'Channel 11', 0, 1, 1),
           (43, 'Channel 12', 0, 1, 1),
           (43, 'Channel 13', 0, 1, 1),
           (43, 'Channel 14', 0, 1, 1),
           (43, 'Channel 15', 0, 1, 1),
           (43, 'Channel 16', 0, 1, 1),
           (44, 'Filter Channel', 0, 16, 0),
           (44, 'Operation Mode', 0, 3, 1),
           (44, 'CC Parameter to intercept', 0, 127, 0),
           (44, 'Key (midi-note) to use with fixed-key mode', 0, 127, 48),
           (48, 'Trim/Gain [dB]', -20, 20, 0),
           (48, 'Phase Invert Left', 0, 1, 0),
           (48, 'Phase Invert Right', 0, 1, 0),
           (48, 'Balance L/R', -1, 1, 0),
           (48, 'Gain Mode', 0, 2, 0),
           (48, 'Delay Left [samples]', 0, 2000, 0),
           (48, 'Delay Right [samples]', 0, 2000, 0),
           (48, 'Channel Assignment', 0, 4, 0),
           (49, 'Volume', 0, 2, 0.75),
           (49, 'Master tune', -7, 7, 0),
           (49, 'Drive', 0, 80, 0),
           (49, 'Filter mode', 0, 5, 1),
           (49, 'Filter cutoff', 0.000009999999747378752, 0.8799999952316284, 0.5),
           (49, 'Filter resonance', 0.000009999999747378752, 2, 0.42000383138656616),
           (49, 'Filter key follow', -1, 1, 0),
           (49, 'Legato', 0, 1, 0),
           (49, 'Sync', 0, 1, 0),
           (49, 'Warmth', 0, 1, 1),
           (49, 'FM', 0, 1, 0),
           (49, 'Panic', 0, 1, 0),
           (49, 'Active 1', 0, 1, 1),
           (49, 'Volume 1', 0, 1, 1),
           (49, 'pulsewidth 1', -0.5, 0.5, 0),
           (49, 'Waveform 1', 0, 3, 0),
           (49, 'Octave 1', -5, 5, -2),
           (49, 'Detune 1', -7, 7, 0),
           (49, 'Detune centre 1', 0, 1, 1),
           (49, 'Inertia 1', 0, 1, 0),
           (49, 'Active 2', 0, 1, 1),
           (49, 'Volume 2', 0, 1, 1),
           (49, 'pulsewidth 2', -0.5, 0.5, 0),
           (49, 'Waveform 2', 0, 3, 0),
           (49, 'Octave 2', -5, 5, -2),
           (49, 'Detune 2', -7, 7, 0.10000000149011612),
           (49, 'Detune centre 2', 0, 1, 1),
           (49, 'Inertia 2', 0, 1, 0),
           (49, 'Active 3', 0, 1, 1),
           (49, 'Volume 3', 0, 1, 1),
           (49, 'pulsewidth 3', -0.5, 0.5, 0),
           (49, 'Waveform 3', 0, 3, 0),
           (49, 'Octave 3', -5, 5, -2),
           (49, 'Detune 3', -7, 7, -0.10000000149011612),
           (49, 'Detune centre 3', 0, 1, 0),
           (49, 'Inertia 3', 0, 1, 0),
           (49, 'Attack 1', 0, 1, 0),
           (49, 'Decay 1', 0, 1, 0.75),
           (49, 'Sustain 1', 0, 1, 0),
           (49, 'Release 1', 0, 1, 0.30000001192092896),
           (49, 'Route one', 0, 1, 1),
           (49, 'Route one dest', 0, 14, 0),
           (49, 'Route two', 0, 1, 0),
           (49, 'Route one dest', 0, 14, 3),
           (49, 'Attack 2', 0, 1, 0),
           (49, 'Decay 2', 0, 1, 0.5),
           (49, 'Sustain 2', 0, 1, 0),
           (49, 'Release 2', 0, 1, 0),
           (49, 'Route one', 0, 1, 0.03999999910593033),
           (49, 'Route one dest', 0, 14, 1),
           (49, 'Route two', 0, 1, 0),
           (49, 'Route two dest', 0, 14, 4),
           (49, 'Attack 3', 0, 1, 0),
           (49, 'Decay 3', 0, 1, 0),
           (49, 'Sustain 3', 0, 1, 0),
           (49, 'Release 3', 0, 1, 0),
           (49, 'To LFO 1', 0, 1, 0),
           (49, 'To LFO 2', 0, 1, 0),
           (49, 'To LFO 3', 0, 1, 0),
           (49, 'LFO1 RETRIG', 0, 2, 0),
           (49, 'LFO1 SPEED', 1, 600, 120),
           (49, 'LFO1 WAVE', 0, 6, 0),
           (49, 'LFO1 TO DCO1 PITCH', 0, 1, 0),
           (49, 'LFO1 TO DCO2 PITCH', 0, 1, 0),
           (49, 'LFO1 TO DCO3 PITCH', 0, 1, 0),
           (49, 'LFO1 TO FILTER', 0, 0.25, 0),
           (49, 'LFO1 ROUTE ONE', 0, 1, 0),
           (49, 'LFO1 ROUTE ONE DEST', 0, 10, 2),
           (49, 'LFO1 ROUTE TWO', 0, 1, 0),
           (49, 'LFO1 ROUTE TWO DEST', 0, 10, 0),
           (49, 'LFO2 RETRIG', 0, 2, 0),
           (49, 'LFO2 SPEED', 1, 600, 120),
           (49, 'LFO2 WAVE', 0, 6, 0),
           (49, 'LFO2 TO DCO1 PITCH', 0, 1, 0),
           (49, 'LFO2 TO DCO2 PITCH', 0, 1, 0),
           (49, 'LFO2 TO DCO3 PITCH', 0, 1, 0),
           (49, 'LFO2 TO FILTER', 0, 0.25, 0),
           (49, 'LFO2 ROUTE ONE', 0, 1, 0),
           (49, 'LFO2 ROUTE ONE DEST', 0, 10, 0),
           (49, 'LFO2 ROUTE ', 0, 1, 0),
           (49, 'LFO2 ROUTE TWO DEST', 0, 10, 0),
           (49, 'LFO3 RETRIG', 0, 2, 0),
           (49, 'LFO3 SPEED', 1, 600, 120),
           (49, 'LFO3 WAVE', 0, 6, 0),
           (49, 'LFO3 TO DCO1 PITCH', 0, 1, 0),
           (49, 'LFO3 TO DCO2 PITCH', 0, 1, 0),
           (49, 'LFO3 TO DCO3 PITCH', 0, 1, 0),
           (49, 'LFO3 TO FILTER', 0, 0.25, 0),
           (49, 'LFO3 ROUTE ONE', 0, 1, 0),
           (49, 'LFO3 ROUTE ONE DEST', 0, 10, 0),
           (49, 'LFO3 ROUTE ', 0, 1, 0),
           (49, 'LFO3 ROUTE TWO DEST', 0, 10, 0),
           (49, 'Echo active', 0, 1, 0),
           (49, 'Echo speed', 512, 65536, 4096),
           (49, 'Echo decay', 0, 0.8999999761581421, 0.25),
           (49, 'Echo eq low', 0, 2, 1),
           (49, 'Echo eq mid', 0, 2, 1),
           (49, 'Echo eq high', 0, 2, 1),
           (49, 'Unison activate', 0, 1, 0),
           (49, 'DCO1 Unison', 0, 1, 0),
           (49, 'DCO2 Unison', 0, 1, 0),
           (49, 'DCO3 Unison', 0, 1, 0),
           (49, 'Modifier - dirt level', 0, 1, 0),
           (49, 'Reverb active', 0, 1, 0),
           (49, 'Reverb decay', 0, 15, 4),
           (49, 'Reverb active', 0, 0.800000011920929, 0),
           (49, 'Stereo mode', 0, 1, 1),
           (49, 'DCO1 Pan', 0, 1, 0.5),
           (49, 'DCO2 Pan', 0, 1, 0.5),
           (49, 'DCO3 Pan', 0, 1, 0.5),
           (49, 'Modifier - ring', 0, 1, 0),
           (49, 'Preset category', 0, 1, 0),
           (49, 'Pitch bend range', 0, 24, 24),
           (49, 'Midi Channel', 1, 16, 1),
           (50, 'Frequency', 0, 30, 3.75),
           (50, 'Depth', 0, 20, 1.25),
           (50, 'Drylevel', -90, 20, -90),
           (50, 'Wetlevel', -90, 20, 6.25),
           (51, 'Drive', 0.10000000149011612, 10, 5),
           (51, 'Tape--Tube Blend', -10, 10, 10),
           (52, 'Frequency', 0, 20, 5),
           (52, 'Depth', 0, 100, 50),
           (52, 'Gain', -70, 20, 0),
           (53, 'Pregain', -90, 20, 0),
           (53, 'Postgain', -90, 20, 0),
           (54, 'Horn Frequency', 0, 30, 0),
           (54, 'Rotor Frequency', 0, 30, 0),
           (54, 'Mic Distance', 0, 100, 0),
           (54, 'Rotor/Horn Mix', 0, 1, 0.5),
           (55, 'Decay', 0, 10000, 2800),
           (55, 'Dry Level', -70, 10, -4),
           (55, 'Wet Level', -70, 10, -12),
           (55, 'Comb Filters', 0, 1, 1),
           (55, 'Allpass Filters', 0, 1, 1),
           (55, 'Bandpass Filter', 0, 1, 1),
           (55, 'Enhanced Stereo', 0, 1, 1),
           (55, 'Reverb Type', 0, 42, 0),
           (56, 'Fragment Length', 100, 1600, 1000),
           (56, 'Dry Level', -90, 20, 0),
           (56, 'Wet Level', -90, 20, 0),
           (57, 'Semitone Shift', -12, 12, 0),
           (57, 'Rate Shift [%]', -50, 100, 0),
           (57, 'Dry Level', -90, 20, -90),
           (57, 'Wet Level', -90, 20, 0),
           (57, 'latency', 0, 16027, 0),
           (58, 'Fractal Dimension', 0, 1, 0.5),
           (58, 'Signal Level', -90, 20, 0),
           (58, 'Noise', -90, 5, -90),
           (59, 'Limit Level', -30, 20, 0),
           (59, 'Output Volume', -30, 20, 0),
           (60, 'Band 1 Gain [dB]', -50, 20, 0),
           (60, 'Band 2 Gain [dB]', -50, 20, 0),
           (60, 'Band 3 Gain [dB]', -50, 20, 0),
           (60, 'Band 4 Gain [dB]', -50, 20, 0),
           (60, 'Band 5 Gain [dB]', -50, 20, 0),
           (60, 'Band 6 Gain [dB]', -50, 20, 0),
           (60, 'Band 7 Gain [dB]', -50, 20, 0),
           (60, 'Band 8 Gain [dB]', -50, 20, 0),
           (60, 'Band 1 Freq [Hz]', 40, 280, 100),
           (60, 'Band 2 Freq [Hz]', 100, 500, 200),
           (60, 'Band 3 Freq [Hz]', 200, 1000, 400),
           (60, 'Band 4 Freq [Hz]', 400, 2800, 1000),
           (60, 'Band 5 Freq [Hz]', 1000, 5000, 3000),
           (60, 'Band 6 Freq [Hz]', 3000, 9000, 6000),
           (60, 'Band 7 Freq [Hz]', 6000, 18000, 12000),
           (60, 'Band 8 Freq [Hz]', 10000, 20000, 15000),
           (61, 'Band 1 Gain [dB]', -50, 20, 0),
           (61, 'Band 2 Gain [dB]', -50, 20, 0),
           (61, 'Band 3 Gain [dB]', -50, 20, 0),
           (61, 'Band 4 Gain [dB]', -50, 20, 0),
           (61, 'Band 5 Gain [dB]', -50, 20, 0),
           (61, 'Band 6 Gain [dB]', -50, 20, 0),
           (61, 'Band 7 Gain [dB]', -50, 20, 0),
           (61, 'Band 8 Gain [dB]', -50, 20, 0),
           (61, 'Band 1 Freq [Hz]', 40, 280, 100),
           (61, 'Band 2 Freq [Hz]', 100, 500, 200),
           (61, 'Band 3 Freq [Hz]', 200, 1000, 400),
           (61, 'Band 4 Freq [Hz]', 400, 2800, 1000),
           (61, 'Band 5 Freq [Hz]', 1000, 5000, 3000),
           (61, 'Band 6 Freq [Hz]', 3000, 9000, 6000),
           (61, 'Band 7 Freq [Hz]', 6000, 18000, 12000),
           (61, 'Band 8 Freq [Hz]', 10000, 20000, 15000),
           (61, 'Band 1 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 2 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 3 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 4 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 5 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 6 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 7 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (61, 'Band 8 Bandwidth [octaves]', 0.10000000149011612, 5, 1),
           (62, 'L Delay', 0, 2000, 300),
           (62, 'Left Feedback', 0, 100, 50),
           (62, 'Right Haas Delay', 0, 2000, 300),
           (62, 'Right Haas Feedback', 0, 100, 50),
           (62, 'Left Echo Level', -70, 10, -4),
           (62, 'Right Echo Level', -70, 10, -4),
           (62, 'Dry Level', -70, 10, -4),
           (62, 'Cross Mode', 0, 1, 1),
           (62, 'Haas Effect', 0, 1, 0),
           (62, 'Swap Outputs', 0, 1, 0),
           (63, 'Attack', 4, 500, 128),
           (63, 'Release', 4, 1000, 502),
           (63, 'Offset Gain', -20, 20, 0),
           (63, 'Makeup Gain', -20, 20, 0),
           (63, 'Stereo Mode', 0, 2, 0),
           (63, 'Function', 0, 14, 0),
           (64, 'Attack', 4, 500, 128),
           (64, 'Release', 4, 1000, 502),
           (64, 'Offset Gain', -20, 20, 0),
           (64, 'Makeup Gain', -20, 20, 0),
           (64, 'Function', 0, 14, 0),
           (65, 'Time Tracking', 0, 1, 0.5),
           (65, 'Pitch Tracking', 0, 1, 0.5),
           (65, 'Dry Level', -90, 20, 0),
           (65, 'Dry Left Position', 0, 1, 0),
           (65, 'Dry Right Position', 0, 1, 1),
           (65, 'Wet Level', -90, 20, 0),
           (65, 'Wet Left Position', 0, 1, 0),
           (65, 'Wet Right Position', 0, 1, 1),
           (66, 'Threshold Level', -50, 10, 0),
           (66, 'Frequency', 2000, 16000, 5500),
           (66, 'Sidechain Filter', 0, 1, 0),
           (66, 'Monitor', 0, 1, 0),
           (67, 'Frequency', 0, 5, 1.75),
           (67, 'L/R Phase Shift', 0, 180, 90),
           (67, 'Depth', 0, 100, 75),
           (67, 'Delay', 0, 100, 25),
           (67, 'Contour', 20, 20000, 100),
           (67, 'Dry Level', -90, 20, -3),
           (67, 'Wet Level', -90, 20, -3),
           (68, 'Frequency', 0, 20, 3),
           (68, 'Depth', 0, 100, 80),
           (68, 'Gain', -70, 20, 0),
           (69, 'Play/Pause', 0, 1, 0),
           (69, 'Record', 0, 1, 0),
           (69, 'Reset', 0, 1, 0),
           (69, 'Undo', 0, 1, 0),
           (69, 'Redo', 0, 1, 0),
           (70, 'shimmer', 0, 100, 50),
           (70, 'decay', 1, 100, 50),
           (70, 'damping', 0, 100, 50),
           (70, 'mix', 0, 100, 50),
           (70, 'ratio', 0.5, 2, 2),
           (70, 'roomsize', 1, 300, 150),
           (70, 'bandwidth', 0, 100, 75),
           (70, 'tone', 500, 6000, 1500),
           (71, 'ratio2', 0.5, 2, 2),
           (71, 'mix', 0, 1, 0.5),
           (71, 'delay1', 0.10000000149011612, 1000, 100),
           (71, 'ratio1', 0.5, 2, 0.5),
           (71, 'cutoff', 0, 3000, 2250),
           (71, 'blur', 0.009999999776482582, 0.25, 0.25),
           (71, 'delay2', 0.10000000149011612, 1000, 100),
           (72, 'repeats', 0, 110, 75),
           (72, 'mix', 0, 100, 75),
           (72, 'rate', 0.10000000149011612, 5, 2),
           (72, 'depth', 0.10000000149011612, 3, 1),
           (72, 'time', 20, 1000, 500),
           (72, 'morph', 0, 100, 50),
           (72, 'tone', 500, 6000, 3000),
           (73, 'tone', 500, 12000, 6000),
           (73, 'depth', 0.10000000149011612, 5, 1),
           (73, 'rate', 0.10000000149011612, 10, 5),
           (74, 'Motors Ac/Dc', 0, 8, 4),
           (74, 'Horn Level', -20, 20, 0),
           (74, 'Drum Level', -20, 20, 0),
           (74, 'Drum Stereo Width', 0, 2, 1),
           (74, 'Horn Speed Slow', 5, 200, 40.31999969482422),
           (74, 'Horn Speed Fast', 100, 1000, 423.3599853515625),
           (74, 'Horn Acceleration', 0.0010000000474974513, 10, 0.16099999845027924),
           (74, 'Horn Deceleration', 0.0010000000474974513, 10, 0.32100000977516174),
           (74, 'Horn Brake Position', 0, 1, 0),
           (74, 'Horn Filter-1 Type', 0, 8, 0),
           (74, 'Horn Filter-1 Frequency', 250, 8000, 4500),
           (74, 'Horn Filter-1 Quality', 0.009999999776482582, 6, 2.7455999851226807),
           (74, 'Horn Filter-1 Gain', -48, 48, -30),
           (74, 'Horn Filter-2 Type', 0, 8, 7),
           (74, 'Horn Filter-2 Frequency', 250, 8000, 300),
           (74, 'Horn Filter-2 Quality', 0.009999999776482582, 6, 1),
           (74, 'Horn Filter-2 Gain', -48, 48, -30),
           (74, 'Drum Speed Slow', 5, 100, 36),
           (74, 'Drum Speed Fast', 60, 600, 357.29998779296875),
           (74, 'Drum Acceleration', 0.009999999776482582, 20, 4.126999855041504),
           (74, 'Drum Deceleration', 0.009999999776482582, 20, 1.371000051498413),
           (74, 'Drum Brake Position', 0, 1, 0),
           (74, 'Drum Filter Type', 0, 8, 8),
           (74, 'Drum Filter Frequency', 50, 8000, 811.969482421875),
           (74, 'Drum Filter Quality', 0.009999999776482582, 6, 1.6016000509262085),
           (74, 'Drum Filter Gain', -48, 48, -38.929100036621094),
           (74, 'Horn Signal Leakage', -80, -3, -16.469999313354492),
           (74, 'Horn Radius', 9, 50, 19.200000762939453),
           (74, 'Drum Radius', 9, 50, 22),
           (74, 'Horn X-Axis Offset', -20, 20, 0),
           (74, 'Horn Z-Axis Offset', -20, 20, 0),
           (74, 'Microphone Distance', 9, 150, 42),
           (74, 'GUI to Plugin Notifications', 0, 1, 0),
           (74, 'Link Speed Control', -1, 1, 0),
           (74, 'Microphone Angle', 0, 180, 180),
           (74, 'Horn Stereo Width', 0, 2, 1),
           (75, 'Motors Ac/Dc', 0, 8, 4),
           (75, 'Horn Level', -20, 20, 10),
           (75, 'Drum Level', -20, 20, 0),
           (75, 'Drum Stereo Width', 0, 2, 1),
           (77, 'Dry/Wet', 0, 1, 0.30000001192092896),
           (77, 'Input Gain', 0, 1, 0.03999999910593033),
           (78, 'Bias', 0, 1, 0.873989999294281),
           (78, 'Feedback', 0, 1, 0.582099974155426),
           (78, 'SagToBias', 0, 1, 0.18799999356269836),
           (78, 'Postdiff feedback', 0, 1, 1),
           (78, 'Global feedback', 0, 1, 0.5825999975204468),
           (78, 'Input Gain', 0, 1, 0.35670000314712524),
           (78, 'Output Gain', 0, 1, 0.07873000204563141),
           (79, 'Bypass', 0, 1, 0),
           (79, 'Wet/Dry', 0, 127, 80),
           (79, 'Panning', -64, 63, 0),
           (79, 'Time', 0, 127, 63),
           (79, 'Initial Delay', 0, 127, 24),
           (79, 'Initial Delay Feedback', 0, 127, 0),
           (79, 'Lowpass Filter', 20, 26000, 4002),
           (79, 'Highpass Filter', 20, 20000, 27),
           (79, 'Damping', 64, 127, 83),
           (79, 'Type', 0, 1, 1),
           (79, 'Room Size', 1, 127, 64),
           (80, 'Bypass', 0, 1, 0),
           (80, 'Gain', -64, 63, 0),
           (80, 'Low Frequency', 20, 1000, 200),
           (80, 'Low Gain', -64, 63, 0),
           (80, 'Low Q', -64, 63, 0),
           (80, 'Mid Frequency', 80, 8000, 800),
           (80, 'Mid Gain', -64, 63, 0),
           (80, 'Mid Q', -64, 63, 0),
           (80, 'High Frequency', 6000, 26000, 12000),
           (80, 'Gain', -64, 63, 0),
           (80, 'High Q', -64, 63, 0),
           (81, 'Bypass', 0, 1, 0),
           (81, 'Wet/Dry', 0, 127, 84),
           (81, 'Panning', -64, 63, 0),
           (81, 'Left/Right Crossover', 0, 127, 87),
           (81, 'Drive', 0, 127, 56),
           (81, 'Level', 0, 127, 40),
           (81, 'Type', 0, 29, 0),
           (81, 'Negate (Polarity Switch)', 0, 1, 0),
           (81, 'Lowpass Filter', 20, 26000, 6703),
           (81, 'Highpass Filter', 20, 20000, 21),
           (81, 'Stereo', 0, 1, 0),
           (81, 'Prefilter', 0, 1, 0),
           (81, 'Suboctave', 0, 127, 0),
           (82, 'Bypass', 0, 1, 0),
           (82, 'Level', 0, 127, 20),
           (82, 'Tone', -64, 64, 0),
           (82, 'Mid', -64, 64, 0),
           (82, 'Bias', -64, 64, 0),
           (82, 'Gain', 0, 127, 64),
           (83, 'Bypass', 0, 1, 0),
           (83, 'Wet/Dry', 0, 127, 64),
           (83, 'Panning', -64, 63, 0),
           (83, 'Tempo', 1, 600, 80),
           (83, 'Randomness', 0, 127, 0),
           (83, 'LFO Type', 0, 11, 0),
           (83, 'LFO L/R Delay', -64, 63, 0),
           (83, 'Depth', 0, 127, 70),
           (83, 'Sensitivity', 0, 127, 90),
           (83, 'Invert', 0, 1, 0),
           (83, 'Smooth', 0, 127, 60),
           (83, 'Filter Type', 0, 4, 0),
           (84, 'Bypass', 0, 1, 0),
           (84, 'Wet/Dry', 0, 127, 64),
           (84, 'Panning', -64, 63, 0),
           (84, 'Tempo', 1, 600, 26),
           (84, 'Randomness', 0, 127, 0),
           (84, 'LFO Type', 0, 11, 0),
           (84, 'LFO L/R Delay', -64, 63, 0),
           (84, 'Extra Stereo Amount', 0, 127, 0),
           (84, 'Autopan', 0, 1, 1),
           (84, 'Extra Stereo Enable', 0, 1, 0),
           (85, 'Bypass', 0, 1, 0),
           (85, 'Wet/Dry', 0, 127, 64),
           (85, 'Pan', -64, 63, 0),
           (85, 'Gain', -64, 63, 0),
           (85, 'Interval', -12, 12, 0),
           (85, 'Filter Frequency', 20, 26000, 6000),
           (85, 'Select Chord Mode', 0, 1, 0),
           (85, 'Note', 0, 23, 0),
           (85, 'Chord', 0, 33, 0),
           (85, 'Filter Gain', -64, 63, 0),
           (85, 'Filter Q', -64, 63, 0),
           (86, 'Bypass', 0, 1, 0),
           (86, 'Gain', -64, 63, 0),
           (86, 'Q', -64, 63, 0),
           (86, '31 Hz', -64, 63, 0),
           (86, '63 Hz', -64, 63, 0),
           (86, '125 Hz', -64, 63, 0),
           (86, '250 Hz', -64, 63, 0),
           (86, '500 Hz', -64, 63, 0),
           (86, '1 kHz', -64, 63, 0),
           (86, '2 kHz', -64, 63, 0),
           (86, '4 kHz', -64, 63, 0),
           (86, '8 kHz', -64, 63, 0),
           (86, '16 kHz', -64, 63, 0),
           (87, 'Bypass', 0, 1, 0),
           (87, 'Wet/Dry', 0, 127, 67),
           (87, 'Panning', -64, 63, 0),
           (87, 'Delay', 20, 2000, 565),
           (87, 'Left/Right Delay Offset', -64, 63, 0),
           (87, 'Left/Right Crossover', 0, 127, 30),
           (87, 'Feedback', 0, 127, 59),
           (87, 'Damping', 0, 127, 0),
           (87, 'Reverse', 0, 127, 127),
           (87, 'Direct', 0, 1, 0),
           (88, 'Bypass', 0, 1, 0),
           (88, 'Wet/Dry', 0, 127, 84),
           (88, 'Panning', -64, 63, 0),
           (88, 'Left/Right Crossover', 0, 127, 87),
           (88, 'Drive', 0, 127, 56),
           (88, 'Level', 0, 127, 40),
           (88, 'Type', 0, 29, 0),
           (88, 'Negate (Polarity Switch)', 0, 1, 0),
           (88, 'Lowpass Filter', 20, 26000, 6703),
           (88, 'Highpass Filter', 20, 20000, 21),
           (88, 'Color', 0, 127, 0),
           (88, 'Prefilter', 0, 1, 0),
           (88, 'Suboctave', 0, 127, 0),
           (89, 'Bypass', 0, 1, 0),
           (89, 'Wet/Dry', 0, 127, 64),
           (89, 'Panning', -64, 63, -64),
           (89, 'Delay', 1, 6, 2),
           (89, 'Delay Offset', 1, 7, 7),
           (89, 'Left/Right Crossover', 0, 127, 0),
           (89, 'Feedback', 0, 127, 59),
           (89, 'Damping', 0, 127, 0),
           (89, 'Panning', -64, 63, 63),
           (89, 'Delay', 1, 6, 4),
           (89, 'Feedback', 0, 127, 59),
           (89, 'Tempo', 10, 480, 106),
           (89, 'Gain', 0, 127, 75),
           (89, 'Gain', 0, 127, 75),
           (90, 'Bypass', 0, 1, 0),
           (90, 'Threshold', -60, -3, -30),
           (90, 'RATIO', 2, 42, 2),
           (90, 'Output Gain', -40, 0, -6),
           (90, 'Attack Time', 10, 250, 20),
           (90, 'Release Time', 10, 500, 120),
           (90, 'Auto Output', 0, 1, 1),
           (90, 'Knee', 0, 100, 0),
           (90, 'Stereo', 0, 1, 0),
           (90, 'Peak', 0, 1, 0),
           (91, 'Bypass', 0, 1, 0),
           (91, 'Wet/Dry', 0, 127, 64),
           (91, 'Panning', -64, 63, 0),
           (91, 'Tempo', 1, 600, 33),
           (91, 'Randomness', 0, 127, 0),
           (91, 'LFO Type', 0, 11, 0),
           (91, 'LFO L/R Delay', -64, 63, 16),
           (91, 'Depth', 0, 127, 40),
           (91, 'Delay', 0, 127, 85),
           (91, 'Feedback', 0, 127, 64),
           (91, 'Left/Right Crossover', 0, 127, 118),
           (91, 'Subtract', 0, 1, 0),
           (91, 'Intense', 0, 1, 0),
           (92, 'Bypass', 0, 1, 0),
           (92, 'Gain', -64, 63, 0),
           (92, 'Preset', -64, 63, 0),
           (93, 'Bypass', 0, 1, 0),
           (93, 'Wet/Dry', 0, 127, 64),
           (93, 'Panning', -64, 63, 0),
           (93, 'Tempo', 1, 600, 80),
           (93, 'Randomness', 0, 127, 0),
           (93, 'LFO Type', 0, 11, 0),
           (93, 'LFO L/R Delay', -64, 63, -2),
           (93, 'Depth', 0, 127, 60),
           (93, 'Feedback', 0, 127, 105),
           (93, 'Delay', 0, 127, 25),
           (93, 'Left/Right Crossover', 0, 127, 0),
           (93, 'Phase', 0, 127, 64),
           (94, 'Bypass', 0, 1, 0),
           (94, 'Wet/Dry', 0, 127, 64),
           (94, 'Distort', 0, 100, 20),
           (94, 'Tempo', 1, 600, 14),
           (94, 'Randomness', 0, 127, 0),
           (94, 'LFO Type', 0, 11, 1),
           (94, 'LFO L/R Delay', 0, 127, 64),
           (94, 'Width', 0, 127, 110),
           (94, 'Feedback', -64, 64, 40),
           (94, 'Stages', 1, 12, 4),
           (94, 'Mismatch', 0, 100, 10),
           (94, 'Subtract', 0, 1, 0),
           (94, 'Phase Depth', 0, 127, 64),
           (94, 'Hyper', 0, 1, 1),
           (95, 'Bypass', 0, 1, 0),
           (95, 'Wet/Dry', 0, 127, 0),
           (95, 'Pan', -64, 64, 10),
           (95, 'Smear', 1, 127, 10),
           (95, 'Q', 40, 170, 71),
           (95, 'Level', 0, 11, 0),
           (95, 'Input Gain', 0, 127, 10),
           (95, 'Ring Mod. Depth', 0, 127, 50),
           (96, 'Bypass', 0, 1, 0),
           (96, 'Width', 0, 127, 64),
           (96, 'Tempo', 1, 600, 14),
           (96, 'Randomness', 0, 127, 0),
           (96, 'LFO Type', 0, 11, 1),
           (96, 'LFO L/R Delay', -64, 63, 32),
           (96, 'Pan', -64, 64, 0),
           (96, 'Wet/Dry', 0, 128, 64),
           (96, 'Feedback', -64, 64, 40),
           (96, 'Depth', 0, 127, 64),
           (96, 'Left/Right Crossover', 0, 128, 0),
           (96, 'Stereo', 0, 1, 0),
           (97, 'Bypass', 0, 1, 0),
           (97, 'Wet/Dry', 0, 127, 0),
           (97, 'Tempo', 1, 600, 64),
           (97, 'LFO Type', 0, 11, 0),
           (97, 'LFO L/R Delay', -64, 63, -2),
           (97, 'Tempo', 1, 600, 120),
           (97, 'LFO Type', 0, 11, 0),
           (97, 'LFO L/R Delay', -64, 63, -2),
           (97, 'Low/Mid1 Crossover', 20, 1000, 150),
           (97, 'Mid1/Mid2 Crossover', 1000, 8000, 1200),
           (97, 'Mid2/High Crossover', 2000, 26000, 12000),
           (97, 'Low Band Volume', 0, 3, 0),
           (97, 'Mid Band 1 Volume', 0, 3, 0),
           (97, 'Mid Band 2 Volume', 0, 3, 0),
           (97, 'High Band Volume', 0, 3, 0),
           (98, 'Bypass', 0, 1, 0),
           (98, 'Wet/Dry', 0, 127, 84),
           (98, 'Panning', -64, 63, 0),
           (98, 'Left/Right Crossover', 0, 127, 87),
           (98, 'Drive', 0, 127, 56),
           (98, 'Level', 0, 127, 40),
           (98, 'Negate (Polarity Switch)', 0, 1, 0),
           (98, 'Lowpass Filter', 20, 26000, 6703),
           (98, 'Highpass Filter', 20, 20000, 21),
           (98, 'Stereo', 0, 1, 0),
           (98, 'Prefilter', 0, 1, 0),
           (98, 'Distortion', 0, 127, 52),
           (98, 'Extra Distortion', 0, 1, 1),
           (98, 'Presence', 0, 100, 18),
           (99, 'Bypass', 0, 1, 0),
           (99, 'Wet/Dry', 0, 127, 0),
           (99, 'Distort', 0, 127, 0),
           (99, 'Tempo', 1, 600, 80),
           (99, 'Randomness', 0, 127, 0),
           (99, 'LFO Type', 0, 11, 0),
           (99, 'LFO L/R Delay', -64, 63, -2),
           (99, 'Width', 0, 127, 50),
           (99, 'Feedback', -64, 64, -30),
           (99, 'Lowpass Stages', 0, 12, 2),
           (99, 'Highpass Stages', 0, 12, 1),
           (99, 'Subtract Output', 0, 1, 0),
           (99, 'Depth', 0, 127, 100),
           (99, 'Envelope Sensitivity', -64, 64, -30),
           (99, 'Attack Time', 5, 1000, 80),
           (99, 'Release Time', 5, 500, 100),
           (99, 'HPF/LPF Offset', 0, 127, 0),
           (100, 'Bypass', 0, 1, 0),
           (100, 'Gain', 0, 127, 40),
           (100, 'Sustain', 1, 127, 64),
           (101, 'Bypass', 0, 1, 0),
           (101, 'Level', 0, 127, 0),
           (101, 'High', -64, 64, 0),
           (101, 'Mid', -64, 64, 0),
           (101, 'Low', -64, 64, 0),
           (101, 'Gain', 0, 127, 64),
           (101, 'Mode', 0, 7, 0),
           (102, 'Bypass', 0, 1, 0),
           (102, 'Wet/Dry', 0, 127, 64),
           (102, 'Left Gain', -64, 63, 0),
           (102, 'Left Interval', -12, 12, 0),
           (102, 'Left Chroma', -2000, 2000, 0),
           (102, 'Right Gain', -64, 64, 0),
           (102, 'Right Interval', -12, 12, 0),
           (102, 'Right Chroma', -2000, 2000, 0),
           (102, 'Select Chord Mode', 0, 1, 0),
           (102, 'Note', 0, 23, 4),
           (102, 'Chord', 0, 33, 0),
           (102, 'Left/Right Crossover', 0, 127, 0),
           (103, 'Bypass', 0, 1, 0),
           (103, 'Wet/Dry', 0, 127, 0),
           (103, 'Gain', -64, 64, 0),
           (103, 'Gain', -64, 64, 0),
           (103, 'Gain', -64, 64, 0),
           (103, 'Gain', -64, 64, 0),
           (103, 'Frequency', 20, 1000, 200),
           (103, 'Frequency', 40, 4000, 400),
           (103, 'Frequency', 1200, 8000, 2000),
           (103, 'Frequency', 6000, 26000, 12000),
           (103, 'Width', -64, 64, 0),
           (103, 'Filtered Band', 0, 1, 0),
           (104, 'Bypass', 0, 1, 0),
           (104, 'Wet/Dry', 0, 127, 0),
           (104, 'Pan', -64, 63, 0),
           (104, 'Gain', -64, 63, 0),
           (104, 'Attack', 1, 2000, 500),
           (104, 'Decay', 1, 2000, 500),
           (104, 'Thresold', -70, 20, 0),
           (104, 'Interval', 0, 12, 1),
           (104, 'Shift Down', 0, 1, 0),
           (104, 'Mode', 0, 2, 0),
           (104, 'Interval', 0, 127, 0),
           (105, 'Bypass', 0, 1, 0),
           (105, 'Gain', 0, 127, 0),
           (105, 'Presence', -64, 64, 0),
           (105, 'Tone', 220, 16000, 2020),
           (105, 'Stereo', 0, 1, 1),
           (105, 'Level', 1, 127, 10),
           (106, 'Bypass', 0, 1, 0),
           (106, 'Step 1', 0, 127, 64),
           (106, 'Step 2', 0, 127, 64),
           (106, 'Step 3', 0, 127, 84),
           (106, 'Step 4', 0, 127, 64),
           (106, 'Step 5', 0, 127, 24),
           (106, 'Step 6', 0, 127, 64),
           (106, 'Step 7', 0, 127, 84),
           (106, 'Step 8', 0, 127, 64),
           (106, 'Wet/Dry', 0, 127, 0),
           (106, 'Tempo', 1, 600, 120),
           (106, 'Q', -64, 64, 0),
           (106, 'Amplitude/Alt. Mode', 0, 1, 0),
           (106, 'Right Channel Step Lag', 0, 7, 0),
           (106, 'Modulation Mode', 0, 8, 0),
           (106, 'Step Adjustment Range', 1, 8, 1),
           (107, 'Bypass', 0, 1, 0),
           (107, 'Wet/Dry', 0, 127, 64),
           (107, 'Pan', -64, 64, 0),
           (107, 'Left/Right Crossover', 0, 127, 14),
           (107, 'Level', 0, 127, 0),
           (107, 'Depth', 0, 100, 1),
           (107, 'Frequency', 1, 20000, 64),
           (107, 'Stereo', 0, 1, 0),
           (107, 'Sine', 0, 100, 40),
           (107, 'Triangle', 0, 100, 4),
           (107, 'Sawtooth', 0, 100, 10),
           (107, 'Square', 0, 100, 0),
           (107, 'Input Gain', 0, 127, 64),
           (107, 'Auto-Frequency', 0, 1, 0),
           (108, 'Bypass', 0, 1, 0),
           (108, 'Wet/Dry', 0, 127, 64),
           (108, 'Fade', 0, 127, 0),
           (108, 'Safe', 0, 1, 1),
           (108, 'Length', 20, 1500, 500),
           (108, 'Initial Delay', 0, 500, 64),
           (108, 'Dampening', 0, 127, 99),
           (108, 'Level', 0, 127, 70),
           (108, 'Time Stretch', -64, 64, 0),
           (108, 'Feedback', -64, 64, 0),
           (108, 'Pan', -64, 63, 0),
           (108, 'Extra Stereo', 0, 1, 0),
           (108, 'Shuffle', 0, 1, 0),
           (108, 'Lowpass Filter', 20, 26000, 20000),
           (108, 'Diffusion', 0, 127, 0),
           (109, 'Bypass', 0, 1, 0),
           (109, 'Depth', 0, 127, 64),
           (109, 'Tempo', 1, 600, 33),
           (109, 'Randomness', 0, 127, 0),
           (109, 'LFO Type', 0, 11, 0),
           (109, 'LFO L/R Delay', -64, 63, 16),
           (109, 'Panning', -64, 63, 0),
           (109, 'Invert', 0, 1, 0),
           (110, 'Bypass', 0, 1, 0),
           (110, 'Wet/Dry', 0, 127, 0),
           (110, 'Resonance', 0, 127, 10),
           (110, 'Tempo', 1, 600, 128),
           (110, 'LFO Randomness', 0, 127, 0),
           (110, 'LFO Type', 0, 11, 0),
           (110, 'LFO L/R Delay', -64, 63, -2),
           (110, 'Depth', 0, 127, 50),
           (110, 'Envelope Sensitivity', -64, 64, -30),
           (110, 'Wah', 0, 127, 2),
           (110, 'Envelope Smoothing', 0, 127, 0),
           (110, 'Lowpass Level', -64, 64, 0),
           (110, 'Bandpass Level', -64, 64, 10),
           (110, 'Highpass Level', -64, 64, -30),
           (110, 'Filter Stages', 1, 6, 1),
           (110, 'Sweep Range', 10, 5000, 2000),
           (110, 'Starting Frequency', 30, 800, 300),
           (110, 'Modulate Resonance', 0, 1, 1),
           (110, 'Analog Gain Mode', 0, 1, 0),
           (110, 'Exponential Wah', 0, 1, 0),
           (111, 'Bypass', 0, 1, 0),
           (111, 'Wet/Dry', 0, 127, 64),
           (111, 'Band 1 Gain', -64, 64, 64),
           (111, 'Band 2 Gain', -64, 64, -64),
           (111, 'Band 3 Gain', -64, 64, 64),
           (111, 'Band 4 Gain', -64, 64, -64),
           (111, 'Band 5 Gain', -64, 64, 64),
           (111, 'Band 6 Gain', -64, 64, -64),
           (111, 'Band 7 Gain', -64, 64, 64),
           (111, 'Band 8 Gain', -64, 64, -64),
           (111, 'Resonance', -1000, 1000, 0),
           (111, 'Sweep Start', 0, 127, 0),
           (111, 'Sweep End', 0, 127, 0),
           (111, 'Tempo', 1, 600, 14),
           (111, 'Sweep L/R Delay', -64, 64, 0),
           (111, 'Sweep Tempo Subdivision', -16, 16, 0),
           (111, 'AutoPan Amount', 0, 127, 0),
           (111, 'Reverse Left Channel Sweep', 0, 1, 0),
           (111, 'Stages', 1, 12, 4),
           (112, 'Bypass', 0, 1, 0),
           (112, 'Threshold', -80, 0, -30),
           (112, 'Shape', 1, 50, 2),
           (112, 'Attack Time', 1, 5000, 20),
           (112, 'Release Time', 10, 1000, 120),
           (112, 'Lowpass Filter', 20, 26000, 3134),
           (112, 'Highpass Filter', 20, 20000, 76),
           (112, 'Output Gain', 1, 127, 10),
           (113, 'Bypass', 0, 1, 0),
           (113, 'Gain', 0, 127, 0),
           (113, '1st Harmonic', -64, 64, 0),
           (113, '2nd Harmonic', -64, 64, 0),
           (113, '3rd Harmonic', -64, 64, 0),
           (113, '4th Harmonic', -64, 64, 0),
           (113, '5th Harmonic', -64, 64, 0),
           (113, '6th Harmonic', -64, 64, 0),
           (113, '7th Harmonic', -64, 64, 0),
           (113, '8th Harmonic', -64, 64, 0),
           (113, '9th Harmonic', -64, 64, 0),
           (113, '10th Harmonic', -64, 64, 0),
           (113, 'Low-Pass Filter Cutoff', 20, 26000, 20000),
           (113, 'High-Pass Filter Cutoff', 20, 20000, 20),
           (114, 'Bypass', 0, 1, 0),
           (114, 'Wet/Dry', 0, 127, 67),
           (114, 'Panning', -64, 63, 0),
           (114, 'TEMPO', 1, 600, 128),
           (114, 'Left/Right Delay Offset', -64, 63, 0),
           (114, 'Angle', -64, 63, 0),
           (114, 'Feedback', 0, 127, 59),
           (114, 'Damping', 0, 127, 0),
           (114, 'Reverse', 0, 127, 0),
           (114, 'Subdivision', 1, 6, 1),
           (114, 'Extra Stereo', 0, 127, 0),
           (115, 'Bypass', 0, 1, 0),
           (115, 'Wet/Dry', 0, 127, 64),
           (115, 'Filter Depth', -64, 64, 0),
           (115, 'LFO Width', 0, 127, 41),
           (115, 'Number of Taps', 1, 127, 127),
           (115, 'TEMPO', 1, 600, 64),
           (115, 'Dampening', 0, 127, 99),
           (115, 'Left/Right Crossover', -64, 64, 20),
           (115, 'LFO L/R Delay', -64, 64, 0),
           (115, 'Feedback', -64, 64, 0),
           (115, 'Pan', -64, 63, 0),
           (115, 'Modulate Delays', 0, 1, 0),
           (115, 'Modulate Filters', 0, 1, 0),
           (115, 'LFO Type', 0, 11, 0),
           (115, 'Activate Filters', 0, 1, 0),
           (116, 'Bypass', 0, 1, 0),
           (116, 'Wet/Dry', 0, 127, 32),
           (116, 'Pan', -64, 64, 0),
           (116, 'Left/Right Crossover', 0, 127, 64),
           (116, 'Depth', 20, 2500, 20),
           (116, 'Sweep Width', 0, 6000, 4),
           (116, 'Offset Delays', 0, 100, 4),
           (116, 'Feedback', -64, 64, 0),
           (116, 'Lowpass Filter', 20, 20000, 2000),
           (116, 'Subtract', 0, 1, 0),
           (116, 'Sweep Through Zero', 0, 1, 0),
           (116, 'Tempo', 1, 600, 14),
           (116, 'LFO L/R Delay', 0, 127, 64),
           (116, 'LFO Type', 0, 11, 1),
           (116, 'Randomness', 0, 127, 0),
           (116, 'Intense', 0, 1, 1),
           (117, 'Bypass', 0, 1, 0),
           (117, 'Wet/Dry', 0, 127, 84),
           (117, 'Panning', -64, 63, 0),
           (117, 'Left/Right Crossover', 0, 127, 87),
           (117, 'Drive', 0, 127, 56),
           (117, 'Level', 0, 127, 40),
           (117, 'Low Band Type', 0, 29, 0),
           (117, 'Mid Band Type', 0, 29, 0),
           (117, 'High Band Type', 0, 29, 0),
           (117, 'Low Gain', 0, 100, 50),
           (117, 'Mid Gain', 0, 100, 14),
           (117, 'High Gain', 0, 100, 35),
           (117, 'Negate (Polarity Switch)', 0, 1, 0),
           (117, 'Low/Mid Crossover', 20, 1000, 150),
           (117, 'Mid/High Crossover', 800, 12000, 1200),
           (117, 'Stereo', 0, 1, 0),
           (118, 'Bypass', 0, 1, 0),
           (118, 'Wet/Dry', 0, 127, 0),
           (118, 'Low Band Ratio', 2, 42, 4),
           (118, 'Mid Band 1 Ratio', 2, 42, 4),
           (118, 'Mid Band 2 Ratio', 2, 42, 4),
           (118, 'High Band Ratio', 2, 42, 4),
           (118, 'Low Band Threshold', -70, 24, 0),
           (118, 'Mid Band 1 Threshold', -70, 24, 0),
           (118, 'Mid Band 2 Threshold', -70, 24, 0),
           (118, 'High Threshold', -70, 24, 0),
           (118, 'Low/Mid1 Crossover', 20, 1000, 200),
           (118, 'Mid1/Mid2 Crossover', 1000, 8000, 2000),
           (118, 'Mid2/High Crossover', 2000, 26000, 15000),
           (118, 'Gain', 0, 127, 88),
           (119, 'Bypass', 0, 1, 0),
           (119, 'Gain', 0, 127, 0),
           (119, 'Origin Pickup Frequency', 2600, 4500, 3000),
           (119, 'Origin Pickup Resonance', 10, 65, 20),
           (119, 'Destination Pickup Frequency', 2600, 4500, 2600),
           (119, 'Destination Pickup Resonance', 10, 65, 20),
           (119, 'Tone', 20, 4400, 200),
           (119, 'Neck Pickup', 0, 1, 0),
           (120, 'Bypass', 0, 1, 0),
           (120, 'Wet/Dry', 0, 127, 67),
           (120, 'Panning', -64, 63, 0),
           (120, 'Tempo', 1, 600, 565),
           (120, 'Left/Right Delay Offset', -64, 63, 0),
           (120, 'Left/Right Crossover', 0, 127, 30),
           (120, 'Feedback', 0, 127, 59),
           (120, 'Damping', 0, 127, 0),
           (120, 'Arpe''s Wet/Dry', 0, 127, 127),
           (120, 'Harmonics', 1, 8, 1),
           (120, 'Pattern', 0, 5, 0),
           (120, 'Subdivision', 0, 5, 3),
           (121, 'Channel One', 0, 1, 0),
           (121, 'Channel Two', 0, 1, 0),
           (121, 'Channel Three', 0, 1, 0),
           (121, 'Channel Four', 0, 1, 0),
           (122, 'Channel One', 0, 1, 0),
           (122, 'Channel Two', 0, 1, 0),
           (122, 'Channel Three', 0, 1, 0),
           (122, 'Channel Four', 0, 1, 0),
           (123, 'Channel', 0, 1, 0),
           (124, 'Freq', 20, 20000, 600),
           (124, 'Order', 0, 2, 0),
           (125, 'Freq', 20, 20000, 600),
           (125, 'Order', 0, 2, 0),
           (126, 'Level', -40, 40, 3),
           (127, 'Level', -40, 40, 3),
           (128, 'Freq 1', 20, 20000, 100),
           (128, 'Freq 2', 20, 20000, 1000),
           (128, 'Gain 1', -40, 40, 3),
           (128, 'Gain 2', -40, 40, 3),
           (128, 'Gain 3', -40, 40, 3),
           (128, 'Order', 0, 2, 0),
           (129, 'Freq', 20, 20000, 600),
           (129, 'Gain 1', -40, 40, 3),
           (129, 'Gain 2', -40, 40, 3),
           (129, 'Order', 0, 2, 0),
           (130, 'Freq', 200, 2000, 600),
           (130, 'Q', 0.7070000171661377, 5, 0.7070000171661377),
           (130, 'Order', 0, 2, 0),
           (131, 'Step', 0, 1, 0),
           (131, 'First', -12, 24, 0),
           (131, 'Last', -12, 24, 12),
           (131, 'Clean', 0, 1, 0),
           (131, 'Gain', -20, 20, 3),
           (132, 'Step', 0, 24, 0),
           (132, 'Gain', -20, 20, 3),
           (133, 'Tone', 0, 11, 0),
           (133, 'Tonic', -12, 12, 0),
           (133, 'Minor 2nd', -12, 12, 0),
           (133, 'Major 2nd', -12, 12, 0),
           (133, 'Minor 3rd', -12, 12, 0),
           (133, 'Major 3rd', -12, 12, 0),
           (133, 'Perfect 4th', -12, 12, 0),
           (133, 'Diminished 5th', -12, 12, 0),
           (133, 'Perfect 5th', -12, 12, 0),
           (133, 'Minor 6th', -12, 12, 0),
           (133, 'Major 6th', -12, 12, 0),
           (133, 'Minor 7th', -12, 12, 0),
           (133, 'Major 7th', -12, 12, 0),
           (133, 'Lowest note to change the pitch', 0, 14, 0),
           (133, 'Gain 1', -20, 20, 0),
           (133, 'Gain 2', -20, 20, 3),
           (134, 'Tone', 0, 11, 0),
           (134, 'Scale', 0, 2, 0),
           (134, 'Interval 1', 0, 11, 0),
           (134, 'Interval 2', 0, 11, 2),
           (134, 'Mode', 0, 2, 0),
           (134, 'Lowest note to change the pitch', 0, 14, 0),
           (134, 'Clean Gain', -20, 20, 0),
           (134, 'Gain 1', -20, 20, 3),
           (134, 'Gain 2', -20, 20, 3),
           (135, 'Tone', 0, 11, 0),
           (135, 'Scale', 0, 2, 0),
           (135, 'Interval', 0, 9, 0),
           (135, 'Mode', 0, 2, 0),
           (135, 'Lowest note to change the pitch', 0, 14, 0),
           (135, 'Gain 1', -20, 20, 0),
           (135, 'Gain 2', -20, 20, 3),
           (136, 'Step', -12, 0, 0),
           (136, 'Gain', -20, 20, 3),
           (137, 'Step', 0, 4, 0),
           (137, 'Gain', -20, 20, 3),
           (138, 'Step 1', -12, 24, 0),
           (138, 'Step 2', -12, 24, 0),
           (138, 'Gain 1', -20, 20, 3),
           (138, 'Gain 2', -20, 20, 3),
           (139, 'Swap carrier-modulator', 0, 1, 0),
           (139, 'Output', -20, 20, 0),
           (139, 'Hi Thru', 0, 100, 40),
           (139, 'Hi Band', 0, 100, 40),
           (139, 'Envelope', 14, 10000, 1602.239990234375),
           (139, 'Filter Q', 0, 100, 55),
           (139, 'Mid Freq', 200, 1600, 1000),
           (139, 'Quality', 0, 1, 1),
           (140, 'Tracking', 0, 1, 0),
           (140, 'Pitch', 0, 1, 0.5),
           (140, 'Breath', 0, 1, 0.20000000298023224),
           (140, 'S Thresh', 0, 1, 0.5),
           (140, 'Max Freq', 0, 1, 0.3499999940395355),
           (141, 'Attack', -100, 100, 50),
           (141, 'Release', -100, 100, 50),
           (141, 'Output', -20, 20, 0),
           (141, 'Filter', -10, 10, 0),
           (141, 'Att Hold', 0, 100, 35),
           (141, 'Rel Hold', 0, 100, 35),
           (142, 'Mode', 0, 1, 0),
           (142, 'Dynamics', 0, 100, 100),
           (142, 'Mix', 0, 100, 100),
           (142, 'Glide', 0, 100, 97),
           (142, 'Transpose', -36, 36, 0),
           (142, 'Maximum', 39, 7350, 6500),
           (142, 'Trigger', -60, 0, -30),
           (142, 'Output', -20, 20, 0),
           (143, 'Rate', 0.10000000149011612, 93.33999633789062, 20),
           (143, 'Depth', 0, 45.349998474121094, 20),
           (143, 'Mix', 0, 100, 47),
           (143, 'Feedback', -100, 100, -40),
           (143, 'Depth Mod', 0, 100, 100),
           (144, 'Mode', 0, 1, 0),
           (144, 'Level', 0, 1, 0.7099999785423279),
           (144, 'Channel', 0, 1, 0.5),
           (144, 'F1', 0, 1, 0.5699999928474426),
           (144, 'F2', 0, 1, 0.5),
           (144, 'Sweep', 0, 1, 0.30000001192092896),
           (144, 'Thru', 0, 1, 0),
           (144, 'Zero dB', 0, 1, 1),
           (145, 'Wet', 0, 200, 100),
           (145, 'Dry', 0, 200, 0),
           (145, 'Carrier', 0, 1, 0),
           (145, 'Quality', 5, 100, 100),
           (146, 'Type', 0, 1, 0.30000001192092896),
           (146, 'Level', 0, 100, 70),
           (146, 'Tune', 10, 320, 198),
           (146, 'Dry Mix', 0, 100, 50),
           (146, 'Thresh', -60, 0, -60),
           (146, 'Release', 1, 1569, 1),
           (147, 'Width', -100, 100, 56),
           (147, 'Delay', 0.44999998807907104, 47.619998931884766, 22.43000030517578),
           (147, 'Balance', -100, 100, 0),
           (147, 'Mod', 0, 47.619998931884766, 0),
           (147, 'Rate', 0.10000000149011612, 100, 50),
           (148, 'Mode', 0, 1, 0),
           (148, 'Freq', 100, 10000, 5050),
           (148, 'Freq SW', 0, 1, 0),
           (148, 'Level', -40, 0, -20),
           (148, 'Level SW', 0, 1, 0.5),
           (148, 'Envelope', 10, 1000, 505),
           (148, 'Output', -20, 20, 0),
           (149, 'Mode', 0, 1, 0),
           (149, 'Rate', -100, 100, -30),
           (149, 'Output', -20, 20, 0),
           (150, 'Pan', -180, 180, 0),
           (150, 'Auto', -515, 515, 309),
           (151, 'Freq', 0.10000000149011612, 16000, 110),
           (151, 'Fine', 0, 100, 0),
           (151, 'Feedback', 0, 100, 0),
           (152, 'Freq', 0, 100, 33),
           (152, 'Res', 0, 100, 70),
           (152, 'Output', -20, 20, 0),
           (152, 'Env->VCF', -100, 100, 70),
           (152, 'Attack', 0, 160.8300018310547, 0),
           (152, 'Release', 1.559999942779541, 15511.6396484375, 7250),
           (152, 'LFO->VCF', -100, 100, 40),
           (152, 'LFO Rate', 0.009999999776482582, 100, 40),
           (152, 'Trigger', -37, 3, -37),
           (152, 'Max Freq', 0, 100, 75),
           (153, 'Tune', -24, 0, -12),
           (153, 'Fine', -99, 0, 0),
           (153, 'Decay', -50, 50, -37),
           (153, 'Thresh', -30, 0, -25),
           (153, 'Hold', 10, 260, 162.33999633789062),
           (153, 'Mix', 0, 100, 90),
           (153, 'Quality', 0, 1, 0),
           (154, 'Envelope Decay', 0, 100, 50),
           (154, 'Envelope Release', 0, 100, 50),
           (154, 'Hardness Offset', -50, 50, 0),
           (154, 'Velocity to Hardness', 0, 100, 50),
           (154, 'Muffling Filter', 0, 100, 80.30000305175781),
           (154, 'Velocity to Muffling', 0, 100, 25.100000381469727),
           (154, 'Velocity Sensitivity', 0, 100, 37.599998474121094),
           (154, 'Stereo Width', 0, 200, 100),
           (154, 'Polyphony', 0, 1, 1),
           (154, 'Fine Tuning', -50, 50, 0),
           (154, 'Random Detuning', 0, 50, 12.300000190734863),
           (154, 'Stretch Tuning', -50, 50, 0),
           (155, 'Drive', 0, 100, 50),
           (155, 'Muffle', 0, 100, 0),
           (155, 'Output', -20, 20, 4),
           (156, 'Listen', 0, 1, 1),
           (156, 'L <> M', 87, 1020, 110.69999694824219),
           (156, 'M <> H', 111, 19606, 17153.7890625),
           (156, 'L Comp', 0, 30, 15),
           (156, 'M Comp', 0, 30, 0),
           (156, 'H Comp', 0, 30, 18),
           (156, 'L Out', -20, 20, -2),
           (156, 'M Out', -20, 20, 0),
           (156, 'H Out', -20, 20, 0),
           (156, 'Attack', 7, 1755, 387.6400146484375),
           (156, 'Release', 1, 1571, 946.343994140625),
           (156, 'Stereo', 0, 200, 110),
           (156, 'Process', 0, 1, 0),
           (157, 'Loudness', 0, 1, 0.699999988079071),
           (157, 'Output', 0, 1, 0.5),
           (157, 'Link', 0, 1, 0.3499999940395355),
           (158, 'Thresh', -40, 0, -16),
           (158, 'Output', -20, 20, 4),
           (158, 'Release', 1, 1571, 758.5),
           (158, 'Attack', 0, 1563, 234.4499969482422),
           (158, 'Knee', 0, 1, 0),
           (159, 'Mode', 0, 1, 0.5),
           (159, 'Lo Width', 0, 100, 50),
           (159, 'Lo Throb', 0, 100, 60),
           (159, 'Hi Width', 0, 100, 70),
           (159, 'Hi Depth', 0, 100, 70),
           (159, 'Hi Throb', 0, 100, 70),
           (159, 'X-Over', 150, 1510, 772.7999877929688),
           (159, 'Output', -20, 20, 0),
           (159, 'Speed', 0, 200, 100),
           (160, 'OSC Mix', 0, 1, 0.5),
           (160, 'OSC Tune', 0, 1, 0.5),
           (160, 'OSC Fine', 0, 1, 0.25),
           (160, 'Glide', 0, 1, 0.30000001192092896),
           (160, 'Gld Rate', 0, 1, 0.3199999928474426),
           (160, 'Gld Bend', 0, 1, 0.5),
           (160, 'VCF Freq', 0, 1, 0.8999999761581421),
           (160, 'VCF Reso', 0, 1, 0.6000000238418579),
           (160, 'VCF Env', 0, 1, 0.11999999731779099),
           (160, 'VCF LFO', 0, 1, 0),
           (160, 'VCF Vel', 0, 1, 0.5),
           (160, 'VCF Att', 0, 1, 0.8999999761581421),
           (160, 'VCF Dec', 0, 1, 0.8899999856948853),
           (160, 'VCF Sus', 0, 1, 0.8999999761581421),
           (160, 'VCF Rel', 0, 1, 0.7300000190734863),
           (160, 'ENV Att', 0, 1, 0),
           (160, 'ENV Dec', 0, 1, 0.5),
           (160, 'ENV Sus', 0, 1, 1),
           (160, 'ENV Rel', 0, 1, 0.7099999785423279),
           (160, 'LFO Rate', 0, 1, 0.8100000023841858),
           (160, 'Vibrato', 0, 1, 0.6499999761581421),
           (160, 'Noise', 0, 1, 0),
           (160, 'Octave', 0, 1, 0.5),
           (160, 'Tuning', 0, 1, 0.5),
           (161, 'Mode', 0, 1, 0),
           (161, 'S Width', -200, 200, 100),
           (161, 'S Pan', -100, 100, 0),
           (161, 'M Level', -200, 200, 100),
           (161, 'M Pan', -100, 100, 0),
           (161, 'Output', -20, 20, 0),
           (162, 'Envelope Decay', 0, 100, 50),
           (162, 'Envelope Release', 0, 100, 50),
           (162, 'Hardness', -50, 50, 0),
           (162, 'Treble Boost', -50, 50, 0),
           (162, 'Modulation', -100, 100, 0),
           (162, 'LFO Rate', 0.07000000029802322, 36.970001220703125, 23.28499984741211),
           (162, 'Velocity Sense', 0, 100, 0),
           (162, 'Stereo Width', 0, 200, 100),
           (162, 'Polyphonic', 0, 1, 1),
           (162, 'Fine Tuning', -50, 50, 0),
           (162, 'Random Tuning', 0, 50, 7.300000190734863),
           (162, 'Overdrive', 0, 100, 0),
           (163, 'Thresh', -40, 0, -16),
           (163, 'Ratio', -17, 0.5, -10),
           (163, 'Output', 0, 40, 4),
           (163, 'Attack', 2, 1571, 283.1400146484375),
           (163, 'Release', 1, 1571, 864.5999755859375),
           (163, 'Limiter', -20, 10, 10),
           (163, 'Gate Thr', -60, 0, -60),
           (163, 'Gate Att', 5, 15782, 5),
           (163, 'Gate Rel', 9, 17384, 173.92999267578125),
           (163, 'Mix', 0, 100, 100),
           (164, 'Attack', 0, 100, 0),
           (164, 'Decay', 0, 100, 65),
           (164, 'Release', 0, 100, 44.099998474121094),
           (164, 'Coarse', 0.009999999776482582, 40, 33.68000030517578),
           (164, 'Fine', 0.0010000000474974513, 0.75, 0.24699999392032623),
           (164, 'Mod Init', 0, 100, 23),
           (164, 'Mod Dec', 0, 100, 80),
           (164, 'Mod Sus', 0, 100, 5),
           (164, 'Mod Rel', 0, 100, 80),
           (164, 'Mod Vel', 0, 100, 90),
           (164, 'Vibrato', 0, 100, 0),
           (164, 'Octave', -3, 3, 0),
           (164, 'FineTune', -100, 100, 0),
           (164, 'Waveform', 0, 100, 44.70000076293945),
           (164, 'Mod Thru', 0, 100, 0),
           (164, 'LFO Rate', 0, 25, 10.350000381469727),
           (165, 'Delay', 0, 7341, 1835.25),
           (165, 'Feedback', -110, 110, 55),
           (165, 'Fb Tone', -100, 100, 0),
           (165, 'LFO Depth', 0, 100, 50),
           (165, 'LFO Rate', 0.10000000149011612, 100, 50),
           (165, 'FX Mix', 0, 100, 50),
           (165, 'Output', -34, 6, 0),
           (166, 'Word Len', 8, 24, 16),
           (166, 'Dither', 0, 3, 0),
           (166, 'Dith Amp', 0, 4, 2),
           (166, 'DC Trim', -2, 2, 0),
           (166, 'Zoom', -80, 0, 0),
           (167, 'Detune', 0, 300, 120),
           (167, 'Mix', 0, 99, 50),
           (167, 'Output', -20, 20, 0),
           (167, 'Latency', 5.800000190734863, 92.9000015258789, 92.9000015258789),
           (168, 'L Delay', 0, 1, 0.5),
           (168, 'R/L Delay', 0, 1, 0.27000001072883606),
           (168, 'Feedback', 0, 1, 0.699999988079071),
           (168, 'Fb Tone', 0, 1, 0.5),
           (168, 'FX Mix', 0, 1, 0.33000001311302185),
           (168, 'Output', 0, 1, 0.5),
           (169, 'Headroom', 0, 1, 0.800000011920929),
           (169, 'Quant', 0, 1, 0.5),
           (169, 'Rate', 0, 1, 0.6499999761581421),
           (169, 'Post Filter', 0, 1, 0.8999999761581421),
           (169, 'Non-Lin', 0, 1, 0.5799999833106995),
           (169, 'Output', 0, 1, 0.5),
           (170, 'Thresh', -60, 0, -30),
           (170, 'Freq', 1000, 12000, 7600),
           (170, 'HF Drive', -20, 20, 0),
           (171, 'Model', 0, 6, 1),
           (171, 'Drive', -100, 100, 50),
           (171, 'Bias', -100, 100, 0),
           (171, 'Output', -20, 20, 14),
           (171, 'Stereo', 0, 1, 0),
           (171, 'HPF Freq', 1, 50, 1),
           (171, 'HPF Reso', 0, 100, 50),
           (172, 'Hat Thr', -40, 0, -38),
           (172, 'Hat Rate', 40, 240, 130),
           (172, 'Hat Mix', -80, 12, -34),
           (172, 'Kik Thr', -40, 0, -20),
           (172, 'Kik Trig', 22, 3494, 300),
           (172, 'Kik Mix', -80, 1.0199999809265137, -34),
           (172, 'Snr Thr', -40, 0, -20),
           (172, 'Snr Trig', 22, 3494, 527.4000244140625),
           (172, 'Snr Mix', -80, 12, -34),
           (172, 'Dynamics', 1, 100, 50),
           (172, 'Record', 0, 4, 0),
           (172, 'Thru Mix', -41, 0, -41),
           (173, 'Listen', 0, 3, 3),
           (173, 'L <> M', 88, 1020, 550),
           (173, 'M <> H', 112, 19606, 9859),
           (173, 'L Dist', 0, 60, 45),
           (173, 'M Dist', 0, 60, 45),
           (173, 'H Dist', 0, 60, 45),
           (173, 'L Out', -20, 20, 6),
           (173, 'M Out', -20, 20, 0),
           (173, 'H Out', -20, 20, 0),
           (173, 'Mode', 0, 1, 0),
           (174, 'Size', 0, 10, 7),
           (174, 'HF Damp', 0, 100, 70),
           (174, 'Mix', 0, 100, 90),
           (174, 'Output', -20, 20, 0),
           (175, 'Tone', 0.009999999776482582, 0.9900000095367432, 0.5),
           (175, 'Level', 0.009999999776482582, 0.9900000095367432, 0.5),
           (175, 'Dist', 0.009999999776482582, 0.9900000095367432, 0.5),
           (176, 'Tone', 0, 1, 0.5),
           (176, 'Level', 0, 1, 0.5),
           (176, 'Sustain', 0, 1, 0.5),
           (177, 'Bypass', 0, 1, 0),
           (177, 'Period', 0.5, 500, 25),
           (177, 'Phase Offset', -180, 180, 45),
           (177, 'Width', 1, 15, 8),
           (177, 'Depth', 0, 100, 75.01000213623047),
           (177, 'Soft Clip', 0, 1, 1),
           (178, 'Bypass', 0, 1, 0),
           (178, 'Period', 0.5, 500, 25),
           (178, 'Phase Offset', -180, 180, 45),
           (178, 'Width', 1, 15, 8),
           (178, 'Depth', 0, 100, 75.01000213623047),
           (178, 'Soft Clip', 0, 1, 1),
           (179, 'Bypass', 0, 1, 0),
           (179, 'Period', 0.5, 500, 25),
           (179, 'Phase Offset', -180, 180, 45),
           (179, 'Width', 1, 15, 8),
           (179, 'Depth', 0, 100, 75.01000213623047),
           (179, 'Soft Clip', 0, 1, 1),
           (180, 'Bypass', 0, 1, 0),
           (180, 'Mode', 0, 1, 0),
           (180, 'Munge Mode', 0, 1, 0),
           (180, 'Munge', 0, 100, 50),
           (180, 'LFO', 2, 200, 20),
           (180, 'Depth', 0, 100, 0),
           (180, 'Delay 1', 0.019999999552965164, 2, 0.30000001192092896),
           (180, 'Feedback 1', 0, 133.3333282470703, 50),
           (180, 'Pan 1', -1, 1, -0.699999988079071),
           (180, 'Volume 1', 0, 100, 100),
           (180, 'Delay 2', 0.019999999552965164, 2, 0.20000000298023224),
           (180, 'Feedback 2', 0, 133.3333282470703, 50),
           (180, 'Pan 2', -1, 1, 0.699999988079071),
           (180, 'Volume 2', 0, 100, 100),
           (181, 'Bypass', 0, 1, 0),
           (181, 'Mode', 0, 1, 0),
           (181, 'Munge Mode', 0, 1, 0),
           (181, 'Munge', 0, 100, 50),
           (181, 'LFO', 2, 200, 20),
           (181, 'Depth', 0, 100, 0),
           (181, 'Delay 1', 0.019999999552965164, 2, 0.30000001192092896),
           (181, 'Feedback 1', 0, 133.3333282470703, 50),
           (181, 'Pan 1', -1, 1, -0.699999988079071),
           (181, 'Volume 1', 0, 100, 100),
           (181, 'Delay 2', 0.019999999552965164, 2, 0.20000000298023224),
           (181, 'Feedback 2', 0, 133.3333282470703, 50),
           (181, 'Pan 2', -1, 1, 0.699999988079071),
           (181, 'Volume 2', 0, 100, 100),
           (182, 'Bypass', 0, 1, 0),
           (182, 'Drive', 0, 18, 0),
           (182, 'DC Offset', -1, 1, 0),
           (182, 'Tube Phase', 0, 1, 0),
           (182, 'Mix', 0, 100, 75),
           (183, 'Bypass', 0, 1, 0),
           (183, 'Drive', 0, 18, 0),
           (183, 'DC Offset', -1, 1, 0),
           (183, 'Tube Phase', 0, 1, 0),
           (183, 'Mix', 0, 100, 75),
           (184, 'Active', 0, 1, 0),
           (184, 'Frequency', 20, 20000, 1000),
           (184, 'Trim', -24, 0, 0),
           (185, 'Bypass', 0, 1, 0),
           (185, 'Phase (L)', 0, 1, 0),
           (185, 'Phase (R)', 0, 1, 0),
           (185, 'Gain', -24, 24, 0),
           (185, 'Pan', -1, 1, 0),
           (185, 'Stereo Width', -1, 1, 0),
           (185, 'Soft Clip', 0, 1, 0),
           (186, 'Bypass', 0, 1, 0),
           (186, 'Frequency', 20, 20000, 1000),
           (186, 'Gain', 0, 12, 0),
           (186, 'Soft Clip', 0, 1, 0),
           (187, 'Bypass', 0, 1, 0),
           (187, 'Frequency', 20, 20000, 1000),
           (187, 'Gain', 0, 12, 0),
           (187, 'Soft Clip', 0, 1, 0),
           (188, 'Bypass', 0, 1, 0),
           (188, 'Frequency', 20, 20000, 1000),
           (188, 'Gain', 0, 12, 0),
           (188, 'Soft Clip', 0, 1, 0),
           (189, 'Bypass', 0, 1, 0),
           (189, 'Frequency', 20, 20000, 1000),
           (189, 'Gain', 0, 12, 0),
           (189, 'Soft Clip', 0, 1, 0),
           (190, 'Bypass', 0, 1, 0),
           (190, 'Room Length', 3, 100, 25),
           (190, 'Room Width', 3, 100, 30),
           (190, 'Room Height', 3, 30, 10),
           (190, 'Source Pan', -1, 1, -0.009999999776482582),
           (190, 'Source (F/B)', 0.5, 1, 0.800000011920929),
           (190, 'Listener Pan', -1, 1, 0.009999999776482582),
           (190, 'Listener (F/B)', 0, 0.5, 0.20000000298023224),
           (190, 'HPF', 20, 2000, 1000),
           (190, 'Warmth', 0, 100, 50),
           (190, 'Diffusion', 0, 100, 50),
           (191, 'Bypass', 0, 1, 0),
           (191, 'Room Length', 3, 100, 25),
           (191, 'Room Width', 3, 100, 30),
           (191, 'Room Height', 3, 30, 10),
           (191, 'Source Pan', -1, 1, -0.009999999776482582),
           (191, 'Source (F/B)', 0.5, 1, 0.800000011920929),
           (191, 'Listener Pan', -1, 1, 0.009999999776482582),
           (191, 'Listener (F/B)', 0, 0.5, 0.20000000298023224),
           (191, 'HPF', 20, 2000, 1000),
           (191, 'Warmth', 0, 100, 50),
           (191, 'Diffusion', 0, 100, 50),
           (192, 'Bypass', 0, 1, 0),
           (192, 'RMS', 0, 1, 0.5),
           (192, 'Attack', 0.000009999999747378752, 0.75, 0.014999999664723873),
           (192, 'Release', 0.0010000000474974513, 5, 0.05000000074505806),
           (192, 'Threshold', -36, 0, 0),
           (192, 'Ratio', 1, 20, 1),
           (192, 'Gain', -6, 36, 0),
           (192, 'Soft Clip', 0, 1, 1),
           (193, 'Bypass', 0, 1, 0),
           (193, 'RMS', 0, 1, 0.5),
           (193, 'Attack', 0.000009999999747378752, 0.75, 0.014999999664723873),
           (193, 'Release', 0.0010000000474974513, 5, 0.05000000074505806),
           (193, 'Threshold', -36, 0, 0),
           (193, 'Ratio', 1, 20, 1),
           (193, 'Gain', -6, 36, 0),
           (193, 'Soft Clip', 0, 1, 1),
           (194, 'ATTACK', 0, 1, 1),
           (194, 'VOLUME', 0.009999999776482582, 1, 0.05999999865889549),
           (194, 'WET/DRY', 0, 100, 25),
           (195, 'Wah', 0, 1, 0),
           (196, 'REFFREQ', 427, 453, 440),
           (196, 'Tuner Mode', 0, 54, 0),
           (196, 'TEMPERAMENT', 0, 2, 0),
           (196, 'THRESHOLD', -60, 4, -50),
           (196, 'RESET', -10, 10, 1),
           (196, 'LEVEL', -60, 4, -45),
           (196, 'CHANNELL', 0, 16, 0),
           (196, 'MIDI_ON', 0, 1, 0),
           (196, 'FASTNOTE', 0, 1, 0),
           (196, 'PITCHBEND', 0, 1, 0),
           (196, 'SINGLENOTE', 0, 1, 0),
           (196, 'BPM', 0, 360, 0),
           (196, 'VELOCITY', 0, 127, 64),
           (196, 'VERIFY', 1, 12, 1),
           (196, 'GATE', 0, 1, 0),
           (196, 'SYNTHFREQ', 30, 1000, 220),
           (196, 'GAIN', 0, 1, 1),
           (197, 'SineWave', 0, 1, 0),
           (197, 'Depth', 0, 1, 0),
           (197, 'Speed', 0.10000000149011612, 14, 0.10000000149011612),
           (197, 'Gain', -12, 22, 0),
           (198, 'SineWave', 0, 1, 0),
           (198, 'Depth', 0, 1, 0),
           (198, 'Speed', 0.10000000149011612, 14, 0.10000000149011612),
           (198, 'Gain', -12, 22, 0),
           (199, 'gain', -40, 16, -40),
           (199, 'feedback', 0, 10, 0),
           (199, 'delay', 0.10000000149011612, 5000, 0.10000000149011612),
           (199, 'level', -60, 0, -60),
           (200, 'Level', -20, 4, -11),
           (200, 'Tone', 100, 1000, 400),
           (200, 'Drive', 0, 1, 0.5),
           (201, 'Drive', 0, 20, 0),
           (201, 'Gain', 0, 20, 0),
           (201, 'Tone', 0, 1, 0.5),
           (202, 'TONE', 0, 1, 0.5),
           (202, 'DRIVE', 0, 1, 0.3199999928474426),
           (202, 'PREGAIN', -20, 20, 0),
           (202, 'GAIN1', -20, 20, 0),
           (203, 'TONE', 0, 1, 0.5),
           (203, 'DRIVE', 1, 20, 10.5),
           (203, 'PREGAIN', -20, 20, 0),
           (203, 'GAIN1', -20, 20, 0),
           (204, 'Input Gain', 0, 1, 0.5),
           (204, 'Swell', 0, 1, 0),
           (204, 'Sustain', 0, 1, 0),
           (204, 'OutputGain', 0, 1, 0.5),
           (204, 'Head 1', 0, 1, 0),
           (204, 'Head 2', 0, 1, 0),
           (204, 'Head 3', 0, 1, 0),
           (205, 'H Level', 0.5, 20, 1),
           (205, 'B Level', 0.5, 20, 1),
           (207, 'LEVEL', -70, 40, 0),
           (207, 'EQ2_FREQ', 160, 10000, 1500),
           (207, 'EQ1_LEVEL', -15, 15, 0),
           (207, 'EQ1_FREQ', 40, 2500, 315),
           (207, 'IN_DELAY', 20, 100, 60),
           (207, 'LOW_RT60', 1, 8, 3),
           (207, 'LF_X', 50, 1000, 200),
           (207, 'HF_DAMPING', 1500, 23520, 6000),
           (207, 'MID_RT60', 1, 8, 2),
           (207, 'DRY_WET_MIX', -1, 1, 0),
           (207, 'EQ2_LEVEL', -15, 15, 0),
           (208, 'Dry/Wet', 0, 100, 50),
           (208, 'Mode', 0, 1, 0),
           (208, 'Depth', 0, 1, 0.5),
           (208, 'Freq', 0.10000000149011612, 50, 5),
           (209, 'DEPTH', 0, 1, 0.5),
           (209, 'FREQ0', 0.25, 15, 1),
           (209, 'FREQ1', 0.25, 15, 1),
           (209, 'FREQ2', 0.25, 15, 1),
           (209, 'FREQ3', 0.25, 15, 1),
           (209, 'STEPS', 1, 4, 4),
           (209, 'SWITCHFREQ', 0.25, 5, 1),
           (210, 'SUSTAIN', 0, 1, 0.5),
           (210, 'VOLUME', 0, 1, 0.5),
           (211, 'Bright_L', 0, 1, 0),
           (211, 'Volume_L', 0, 20, 5),
           (211, 'Bass_L', 0, 1, 0.5),
           (211, 'Middle_L', 0, 1, 0.5),
           (211, 'Treble_L', 0, 1, 0.5),
           (211, 'Bright_R', 0, 1, 0),
           (211, 'Volume_R', 0, 20, 5),
           (211, 'Bass_R', 0, 1, 0.5),
           (211, 'Middle_R', 0, 1, 0.5),
           (211, 'Treble_R', 0, 1, 0.5),
           (212, 'Bright', 0, 1, 0),
           (212, 'Volume', 0, 20, 5),
           (212, 'Bass', 0, 1, 0.5),
           (212, 'Middle', 0, 1, 0.5),
           (212, 'Treble', 0, 1, 0.5),
           (213, 'CONTROL', 0, 1, 0.5),
           (213, 'DEPTH', 0, 1, 0),
           (213, 'DRYWET', 0, 1, 0.5),
           (213, 'ENVELOPE', 0.10000000149011612, 3, 1),
           (213, 'F1', 50, 1000, 200),
           (213, 'F2', 1500, 23520, 6000),
           (213, 'MODE', -3, 3, 0),
           (213, 'PSDRYWET', 0, 1, 0.5),
           (213, 'SHIFT', -6, 6, 0),
           (213, 'SPEED', 0.10000000149011612, 10, 0.10000000149011612),
           (213, 'T60DS', 1, 8, 3),
           (213, 'T60M', 1, 8, 2),
           (214, 'SCREAM', 0, 1, 0.5),
           (215, 'EFFECT', 0, 1, 0),
           (215, 'PREDELAYMS', 1, 200, 20),
           (215, 'RT', 0, 1, 0.30000001192092896),
           (215, 'ROOMSIZE', 0, 3, 1),
           (215, 'DRYWET', 0, 1, 0.5),
           (216, 'Dry/Wet', 0, 100, 50),
           (216, 'LFO', 0.20000000298023224, 5, 0.20000000298023224),
           (216, 'Roomsize', 0, 1, 0.5),
           (216, 'Damp', 0, 1, 0.20000000298023224),
           (216, 'Mode', 0, 1, 0),
           (217, 'Gain', 0, 10, 5),
           (217, 'Tone', -6, 6, 0),
           (217, 'Volume', 0, 10, 5),
           (217, 'Feedback', 0, 1, 0),
           (217, 'Speed', 0.10000000149011612, 10, 5),
           (217, 'Intensity', 0, 10, 0),
           (217, 'Sinewave', 0, 1, 0),
           (218, 'Gain', -20, 20, 0),
           (218, 'Tone', 0, 1, 0.5),
           (218, 'Volume', -20, 20, 0),
           (218, 'Feedback', 0, 1, 0),
           (218, 'Speed', 0.10000000149011612, 10, 5),
           (218, 'Intensity', 0, 10, 0),
           (218, 'Sinewave', 0, 1, 0),
           (219, 'Gain', 0, 10, 5),
           (219, 'Tone', -6, 6, 0),
           (219, 'Volume', 0, 10, 5),
           (219, 'Feedback', 0, 1, 0),
           (219, 'Speed', 0.10000000149011612, 10, 5),
           (219, 'Intensity', 0, 10, 0),
           (219, 'Sinewave', 0, 1, 0),
           (220, 'BOOST', 0, 1, 0.5),
           (220, 'WET_DRY', 0, 100, 100),
           (221, 'Dry/Wet', 0, 100, 50),
           (221, 'LEVEL', -60, 10, 0),
           (221, 'SPEED', 0, 10, 0.5),
           (222, 'DIRECT', 0, 1, 0.5),
           (222, 'OCTAVE1', 0, 1, 0.5),
           (222, 'OCTAVE2', 0, 1, 0.5),
           (223, 'TONE', 0, 1, 0.5),
           (223, 'VOLUME', 0, 1, 0.5),
           (224, 'BOOST', 0, 1, 0.5),
           (224, 'WET_DRY', 0, 100, 100),
           (225, 'ROOMSIZE1', 0, 1, 0.5),
           (225, 'ROOMSIZE2', 0, 1, 0.5),
           (225, 'ROOMSIZE3', 0, 1, 0.5),
           (225, 'ROOMSIZE4', 0, 1, 0.5),
           (225, 'ROOMSIZE5', 0, 1, 0.5),
           (225, 'CROSSOVER_B1_B2', 20, 20000, 80),
           (225, 'CROSSOVER_B2_B3', 20, 20000, 210),
           (225, 'CROSSOVER_B3_B4', 20, 20000, 1700),
           (225, 'CROSSOVER_B4_B5', 20, 20000, 5000),
           (225, 'DAMP1', 0, 1, 0.5),
           (225, 'DAMP2', 0, 1, 0.5),
           (225, 'DAMP3', 0, 1, 0.5),
           (225, 'DAMP4', 0, 1, 0.5),
           (225, 'DAMP5', 0, 1, 0.5),
           (225, 'WET_DRY1', 0, 100, 50),
           (225, 'WET_DRY2', 0, 100, 50),
           (225, 'WET_DRY3', 0, 100, 50),
           (225, 'WET_DRY4', 0, 100, 50),
           (225, 'WET_DRY5', 0, 100, 50),
           (226, 'PERCENT1', 0, 100, 10),
           (226, 'PERCENT2', 0, 100, 30),
           (226, 'PERCENT3', 0, 100, 45),
           (226, 'PERCENT4', 0, 100, 20),
           (226, 'PERCENT5', 0, 100, 0),
           (226, 'TIME1', 24, 360, 30),
           (226, 'TIME2', 24, 360, 60),
           (226, 'TIME3', 24, 360, 120),
           (226, 'TIME4', 24, 360, 150),
           (226, 'TIME5', 24, 360, 240),
           (226, 'LOW SHELF', 20, 20000, 80),
           (226, 'CROSSOVER_B2_B3', 20, 20000, 210),
           (226, 'CROSSOVER_B3_B4', 20, 20000, 1700),
           (226, 'CROSSOVER_B4_B5', 20, 20000, 5000),
           (227, 'DRIVE1', 0, 1, 0),
           (227, 'DRIVE2', 0, 1, 0.25),
           (227, 'DRIVE3', 0, 1, 0.6499999761581421),
           (227, 'DRIVE4', 0, 1, 0.25),
           (227, 'DRIVE5', 0, 1, 0),
           (227, 'GAIN', -40, 4, 0),
           (227, 'OFFSET1', 0, 0.5, 0.17000000178813934),
           (227, 'OFFSET2', 0, 0.5, 0.20000000298023224),
           (227, 'OFFSET3', 0, 0.5, 0.20000000298023224),
           (227, 'OFFSET4', 0, 0.5, 0.20000000298023224),
           (227, 'OFFSET5', 0, 0.5, 0.17000000178813934),
           (227, 'LOW SHELF', 20, 20000, 80),
           (227, 'CROSSOVER_B2_B3', 20, 20000, 210),
           (227, 'CROSSOVER_B3_B4', 20, 20000, 1700),
           (227, 'CROSSOVER_B4_B5', 20, 20000, 5000),
           (228, 'DELAY1', 24, 360, 30),
           (228, 'DELAY2', 24, 360, 60),
           (228, 'DELAY3', 24, 360, 90),
           (228, 'DELAY4', 24, 360, 120),
           (228, 'DELAY5', 24, 360, 150),
           (228, 'FEEDBACK1', 1, 100, 50),
           (228, 'FEEDBACK2', 1, 100, 50),
           (228, 'FEEDBACK3', 1, 100, 50),
           (228, 'FEEDBACK4', 1, 100, 50),
           (228, 'FEEDBACK5', 1, 100, 50),
           (228, 'GAIN1', -40, 2, -10),
           (228, 'GAIN2', -40, 2, -5),
           (228, 'GAIN3', -40, 2, -2),
           (228, 'GAIN4', -40, 2, 0),
           (228, 'GAIN5', -40, 2, -10),
           (228, 'LOW SHELF', 20, 20000, 80),
           (228, 'CROSSOVER_B2_B3', 20, 20000, 210),
           (228, 'CROSSOVER_B3_B4', 20, 20000, 1700),
           (228, 'CROSSOVER_B4_B5', 20, 20000, 5000),
           (229, 'MODE1', 1, 3, 1),
           (229, 'MODE2', 1, 3, 1),
           (229, 'MODE3', 1, 3, 1),
           (229, 'MODE4', 1, 3, 1),
           (229, 'MODE5', 1, 3, 1),
           (229, 'MAKEUP1', -50, 50, 13),
           (229, 'MAKEUP2', -50, 50, 13),
           (229, 'MAKEUP3', -50, 50, 13),
           (229, 'MAKEUP4', -50, 50, 13),
           (229, 'MAKEUP5', -50, 50, 13),
           (229, 'MAKEUPTHRESHOLD1', 0, 10, 2),
           (229, 'MAKEUPTHRESHOLD2', 0, 10, 2),
           (229, 'MAKEUPTHRESHOLD3', 0, 10, 2),
           (229, 'MAKEUPTHRESHOLD4', 0, 10, 2),
           (229, 'MAKEUPTHRESHOLD5', 0, 10, 2),
           (229, 'RATIO1', 1, 100, 13),
           (229, 'RATIO2', 1, 100, 10),
           (229, 'RATIO3', 1, 100, 4),
           (229, 'RATIO4', 1, 100, 8),
           (229, 'RATIO5', 1, 100, 11),
           (229, 'ATTACK1', 0.0010000000474974513, 1, 0.012000000104308128),
           (229, 'ATTACK2', 0.0010000000474974513, 1, 0.012000000104308128),
           (229, 'ATTACK3', 0.0010000000474974513, 1, 0.012000000104308128),
           (229, 'ATTACK4', 0.0010000000474974513, 1, 0.012000000104308128),
           (229, 'ATTACK5', 0.0010000000474974513, 1, 0.012000000104308128),
           (229, 'RELEASE1', 0.009999999776482582, 10, 1.25),
           (229, 'RELEASE2', 0.009999999776482582, 10, 1.25),
           (229, 'RELEASE3', 0.009999999776482582, 10, 1.25),
           (229, 'RELEASE4', 0.009999999776482582, 10, 1.25),
           (229, 'RELEASE5', 0.009999999776482582, 10, 1.25),
           (229, 'LOW SHELF', 20, 20000, 80),
           (229, 'CROSSOVER_B2_B3', 20, 20000, 210),
           (229, 'CROSSOVER_B3_B4', 20, 20000, 1700),
           (229, 'CROSSOVER_B4_B5', 20, 20000, 5000),
           (230, 'clip1', 0, 100, 100),
           (230, 'clip2', 0, 100, 100),
           (230, 'clip3', 0, 100, 100),
           (230, 'clip4', 0, 100, 100),
           (230, 'clips1', 0, 100, 0),
           (230, 'clips2', 0, 100, 0),
           (230, 'clips3', 0, 100, 0),
           (230, 'clips4', 0, 100, 0),
           (230, 'speed1', -0.8999999761581421, 0.8999999761581421, 0),
           (230, 'speed2', -0.8999999761581421, 0.8999999761581421, 0),
           (230, 'speed3', -0.8999999761581421, 0.8999999761581421, 0),
           (230, 'speed4', -0.8999999761581421, 0.8999999761581421, 0),
           (230, 'gain', -20, 12, 0),
           (230, 'level1', 0, 100, 50),
           (230, 'level2', 0, 100, 50),
           (230, 'level3', 0, 100, 50),
           (230, 'level4', 0, 100, 50),
           (230, 'mix', 0, 150, 100),
           (230, 'play1', 0, 1, 0),
           (230, 'play2', 0, 1, 0),
           (230, 'play3', 0, 1, 0),
           (230, 'play4', 0, 1, 0),
           (230, 'rplay1', 0, 1, 0),
           (230, 'rplay2', 0, 1, 0),
           (230, 'rplay3', 0, 1, 0),
           (230, 'rplay4', 0, 1, 0),
           (230, 'rec1', 0, 1, 0),
           (230, 'rec2', 0, 1, 0),
           (230, 'rec3', 0, 1, 0),
           (230, 'rec4', 0, 1, 0),
           (230, 'reset1', 0, 1, 0),
           (230, 'reset2', 0, 1, 0),
           (230, 'reset3', 0, 1, 0),
           (230, 'reset4', 0, 1, 0),
           (231, 'Pre Amp', 0, 1, 0.5),
           (231, 'Middle', 0, 1, 0.5),
           (231, 'Bass', 0, 1, 0.5),
           (231, 'Treble', 0, 1, 0.5),
           (231, 'Presence', 0, 100, 50),
           (231, 'Master Volume', -20, 20, 0),
           (232, 'Pre Amp', 0, 1, 0.5),
           (232, 'Middle', 0, 1, 0.5),
           (232, 'Bass', 0, 1, 0.5),
           (232, 'Treble', 0, 1, 0.5),
           (232, 'Presence', 0, 100, 50),
           (232, 'Master Volume', -20, 20, 0),
           (233, 'FUZZ', 0, 1, 0.5),
           (233, 'SUSTAIN', 0, 1, 0.5),
           (233, 'VOLUME', 0, 1, 0.5),
           (234, 'VOLUME', 0, 1, 0.5),
           (234, 'WET_DRY', 0, 100, 100),
           (235, 'INTENSITY', 0, 1, 0.5),
           (235, 'VOLUME', 0, 1, 0.5),
           (236, 'G10', -30, 20, 0),
           (236, 'G11', -30, 20, 0),
           (236, 'G1', -30, 20, 0),
           (236, 'G2', -30, 20, 0),
           (236, 'G3', -30, 20, 0),
           (236, 'G4', -30, 20, 0),
           (236, 'G5', -30, 20, 0),
           (236, 'G6', -30, 20, 0),
           (236, 'G7', -30, 20, 0),
           (236, 'G8', -30, 20, 0),
           (236, 'G9', -30, 20, 0),
           (237, 'VOLUME', -20, 4, 0),
           (237, 'WAH', 0, 1, 0.5),
           (238, 'DRIVE', 0, 1, 0.5),
           (238, 'FUZZ', 0, 0.9900000095367432, 0.5),
           (238, 'INPUT', 0, 1, 1),
           (238, 'LEVEL', 0, 1, 0.25),
           (239, 'FUZZ', 0, 1, 0.5),
           (239, 'LEVEL', 0, 1, 0.5),
           (240, 'INPUT', -20, 10, 0),
           (240, 'OUTPUT', 50, 100, 100),
           (240, 'DRIVE', -3, 100, 1),
           (240, 'TONE', 0, 1, 0.5),
           (241, 'TONE', 0, 1, 0.5),
           (241, 'VOLUME', 0.009999999776482582, 1, 0.10000000149011612),
           (241, 'WET_DRY', 0, 100, 100),
           (242, 'DEPTH', 0, 5, 0.5),
           (242, 'WIDTH', 0, 10, 5),
           (242, 'FREQ', 0.05000000074505806, 10, 0.20000000298023224),
           (242, 'FEEDBACK', -0.9900000095367432, 0.9900000095367432, -0.7070000171661377),
           (242, 'WET', 0, 100, 100),
           (242, 'MIX', -1, 1, 0),
           (243, 'RATIO', 1, 20, 2),
           (243, 'KNEE', 0, 20, 3),
           (243, 'THRESHOLD', -96, 10, -40),
           (243, 'RELEASE', 0, 10, 0.10000000149011612),
           (243, 'ATTACK', 0, 1, 0.0010000000474974513),
           (244, 'Mode', 0, 1, 0),
           (244, 'R Level', 0, 100, 30),
           (244, 'R Time', 1, 2000, 100),
           (244, 'L Level', 0, 100, 30),
           (244, 'L Time', 1, 2000, 100),
           (244, 'LFO', 0.20000000298023224, 5, 0.20000000298023224),
           (244, 'Link (L+R)', 0, 1, 0),
           (245, 'AMOUNT', 0, 56, 0.5),
           (245, 'ATTACK', 0.05000000074505806, 0.5, 0.10000000149011612),
           (245, 'COLORATION', -1, 1, 0),
           (245, 'EFFECT', -16, 4, 0),
           (245, 'FEEDBACK', 0, 1, 0),
           (245, 'PINGPONG', 0, 1, 0),
           (245, 'RELEASE', 0.05000000074505806, 2, 0.10000000149011612),
           (245, 'TIME', 1, 2000, 500),
           (246, 'AMOUNT', 0, 56, 0.5),
           (246, 'ATTACK', 0.05000000074505806, 0.5, 0.10000000149011612),
           (246, 'FEEDBACK', 0, 1, 0),
           (246, 'RELESE', 0.05000000074505806, 2, 0.10000000149011612),
           (246, 'TIME', 1, 2000, 500),
           (247, 'BPM', 24, 360, 120),
           (247, 'FEEDBACK', 1, 100, 50),
           (247, 'GAIN', 0, 120, 100),
           (247, 'HIGHPASS', 20, 20000, 120),
           (247, 'HOWPASS', 20, 20000, 12000),
           (247, 'LEVEL', 1, 100, 50),
           (247, 'MODE', 0, 3, 0),
           (247, 'NOTES', 1, 18, 5),
           (248, 'BPM', 24, 360, 120),
           (248, 'FEEDBACK', 1, 100, 50),
           (248, 'GAIN', 0, 120, 100),
           (248, 'HIGHPASS', 20, 20000, 120),
           (248, 'HOWPASS', 20, 20000, 12000),
           (248, 'LEVEL', 1, 100, 50),
           (248, 'MODE', 0, 3, 0),
           (248, 'NOTES', 1, 18, 5),
           (249, 'DETUNE', -0.25, 0.25, 0),
           (249, 'OCTAVE', 0, 2, 0),
           (249, 'COMPENSATE', 0, 1, 0),
           (249, 'LATENCY', 0, 2, 1),
           (249, 'WET', 0, 100, 50),
           (249, 'DRY', 0, 100, 50),
           (249, 'LOW', 0, 2, 1),
           (249, 'MIDDLELOW', 0, 2, 1),
           (249, 'MIDDLETREBLE', 0, 2, 1),
           (249, 'TREBLE', 0, 2, 1),
           (250, 'Mode', 0, 1, 0),
           (250, 'R Level', -20, 20, -10),
           (250, 'R Time', 1, 5000, 1000),
           (250, 'L Level', -20, 20, -10),
           (250, 'L Time', 1, 5000, 1000),
           (250, 'LFO', 0.20000000298023224, 5, 0.20000000298023224),
           (250, 'Link (L+R)', 0, 1, 0),
           (251, 'ATTACK', 0, 0.949999988079071, 0.949999988079071),
           (251, 'LEVEL', 0, 1, 0.75),
           (251, 'WET_DRY', 0, 100, 75),
           (252, 'RATIO', 1, 20, 2),
           (252, 'KNEE', 0, 20, 3),
           (252, 'THRESHOLD', -96, 10, -20),
           (252, 'RELEASE', 0, 10, 0.5),
           (252, 'ATTACK', 0, 1, 0.0020000000949949026),
           (253, 'WAH', 0, 1, 0),
           (253, 'FREQ', 24, 360, 24),
           (253, 'MODE', 0, 2, 0),
           (253, 'MODEL', 0, 6, 0),
           (253, 'WET_DRY', 0, 100, 100),
           (254, 'Level', 0, 1, 0.5),
           (254, 'Delay', 0, 0.20000000298023224, 0.019999999552965164),
           (254, 'Depth', 0, 1, 0.019999999552965164),
           (254, 'Freq', 0.10000000149011612, 10, 3),
           (255, 'Cabinet', 0.5, 5, 1),
           (255, 'Bass', -10, 10, 0),
           (255, 'Treble', -10, 10, 0),
           (255, 'Cab Model', 0, 18, 0),
           (256, 'G1', -30, 20, 0),
           (256, 'G2', -30, 20, 0),
           (256, 'G3', -30, 20, 0),
           (256, 'G4', -30, 20, 0),
           (256, 'G5', -30, 20, 0),
           (256, 'G6', -30, 20, 0),
           (256, 'G7', -30, 20, 0),
           (256, 'G8', -30, 20, 0),
           (256, 'G9', -30, 20, 0),
           (256, 'G10', -30, 20, 0),
           (256, 'G11', -30, 20, 0),
           (256, 'G12', -30, 20, 0),
           (256, 'G13', -30, 20, 0),
           (256, 'G14', -30, 20, 0),
           (256, 'G15', -30, 20, 0),
           (256, 'G16', -30, 20, 0),
           (256, 'G17', -30, 20, 0),
           (256, 'G18', -30, 20, 0),
           (256, 'G19', -30, 20, 0),
           (256, 'G20', -30, 20, 0),
           (256, 'G21', -30, 20, 0),
           (256, 'G22', -30, 20, 0),
           (256, 'G23', -30, 20, 0),
           (256, 'G24', -30, 20, 0),
           (257, 'MasterGain', -20, 20, -15),
           (257, 'PreGain', -20, 20, -15),
           (257, 'Distortion', 1, 100, 20),
           (257, 'Drive', 0.009999999776482582, 1, 0.25),
           (257, 'Middle', 0, 1, 0.5),
           (257, 'Bass', 0, 1, 0.5),
           (257, 'Treble', 0, 1, 0.5),
           (257, 'Cabinet', 1, 20, 10),
           (257, 'Presence', 1, 10, 5),
           (257, 'Model', 0, 17, 0),
           (257, 'Tonestack Model', 0, 26, 1),
           (257, 'Cab Model', 0, 18, 0),
           (258, 'MasterGain', -20, 20, 0),
           (258, 'PreGain', -20, 20, 0),
           (258, 'Distortion', 1, 100, 20),
           (258, 'Drive', 0.009999999776482582, 1, 0.25),
           (258, 'Middle', 0, 1, 0.5),
           (258, 'Bass', 0, 1, 0.5),
           (258, 'Treble', 0, 1, 0.5),
           (258, 'Cabinet', 1, 20, 10),
           (258, 'Presence', 1, 10, 5),
           (258, 'Model', 0, 17, 0),
           (258, 'Tonestack Model', 0, 26, 1),
           (258, 'Cab Model', 0, 18, 0),
           (259, 'delay length', 0.5, 10, 10),
           (259, 'grain density', 2, 16, 2),
           (259, 'grain length', 0.009999999776482582, 0.5, 0.10000000149011612),
           (259, 'mix', 0, 1, 0.5),
           (260, 'Blur', 0.0010000000474974513, 15, 1.6399999856948853),
           (260, 'Level', 0, 1.5, 0.25999999046325684),
           (261, 'Decay', 0.10000000149011612, 1, 0.9399999976158142),
           (261, 'Roomsize', 0.009999999776482582, 5, 0.7900000214576721),
           (261, 'Tail level', 0.10000000149011612, 1, 0.23999999463558197),
           (262, 'Clip', 0, 1, 1),
           (262, 'Delay', 0, 0.9990000128746033, 0.9959999918937683),
           (262, 'Drive', 1, 9.899999618530273, 1),
           (263, 'Delay', 0, 30, 22.5),
           (263, 'Mod Frequency 1', 0.003000000026077032, 10, 0.10000000149011612),
           (263, 'Mod Amplitude 1', 0, 10, 5),
           (263, 'Mod Frequency 2', 0.009999999776482582, 30, 0.550000011920929),
           (263, 'Mod Amplitude 2', 0, 3, 1.5),
           (264, 'Delay', 0.019999999552965164, 0.10000000149011612, 0.05999999865889549),
           (264, 'Xover', 50, 1000, 223.60699462890625),
           (264, 'RT-low', 1, 8, 2.75),
           (264, 'RT-mid', 1, 8, 2.75),
           (264, 'Damping', 1500, 24000, 6000),
           (264, 'F1-freq', 40, 10000, 159.0540008544922),
           (264, 'F1-gain', -20, 20, 0),
           (264, 'F2-freq', 40, 10000, 2514.8701171875),
           (264, 'F2-gain', -20, 20, 0),
           (264, 'Output mix', 0, 1, 0.5),
           (265, 'Input gain', -40, 10, -4),
           (265, 'Sections', 1, 30, 7),
           (265, 'Frequency', -6, 6, 5.599999904632568),
           (265, 'LFO frequency', 0.009999999776482582, 30, 1),
           (265, 'LFO waveform', -1, 1, 0),
           (265, 'Modulation gain', 0, 10, 7.659999847412109),
           (265, 'Feedback gain', -1, 1, 0.12999999523162842),
           (265, 'Output mix', -1, 1, 0.2199999988079071),
           (266, 'Delay', 0, 30, 7.5),
           (266, 'Mod Frequency 1', 0.003000000026077032, 10, 0.20000000298023224),
           (266, 'Mod Amplitude 1', 0, 10, 1.25),
           (266, 'Mod Frequency 2', 0.009999999776482582, 30, 0.550000011920929),
           (266, 'Mod Amplitude 2', 0, 3, 0.75),
           (267, 'Delay', 0, 30, 7.5),
           (267, 'Mod Frequency 1', 0.003000000026077032, 10, 0.20000000298023224),
           (267, 'Mod Amplitude 1', 0, 10, 2.5),
           (267, 'Mod Frequency 2', 0.009999999776482582, 30, 0.800000011920929),
           (267, 'Mod Amplitude 2', 0, 3, 0.75),
           (268, 'Drive', -20, 20, 0),
           (268, 'Decay', 0, 1, 0),
           (268, 'Range', 0, 1, 0.5),
           (268, 'Freq', 0, 1, 0.25),
           (268, 'Mix', 0, 1, 0.75),
           (269, 'Octave', -4, 4, 0),
           (269, 'Tune', 0, 1, 0),
           (269, 'Exp FM gain', 0, 4, 0),
           (269, 'Lin FM gain', 0, 4, 0),
           (269, 'LP filter', 0, 1, 1),
           (270, 'Delay', 0.019999999552965164, 0.10000000149011612, 0.05999999865889549),
           (270, 'Xover', 50, 1000, 223.60699462890625),
           (270, 'RT-low', 1, 8, 2.75),
           (270, 'RT-mid', 1, 8, 2.75),
           (270, 'Damping', 1500, 24000, 6000),
           (270, 'F1-freq', 40, 10000, 159.0540008544922),
           (270, 'F1-gain', -20, 20, 0),
           (270, 'F2-freq', 40, 10000, 2514.8701171875),
           (270, 'F2-gain', -20, 20, 0),
           (270, 'XYZ gain', -9, 9, 0),
           (271, 'Octave', -4, 4, 0),
           (271, 'Tune', 0, 1, 0),
           (271, 'Exp FM gain', 0, 4, 0),
           (271, 'Lin FM gain', 0, 4, 0),
           (271, 'Waveform', -1, 1, 0),
           (271, 'Form mod', 0, 4, 0),
           (271, 'LP filter', 0, 1, 1),
           (272, 'Octave', -4, 4, 0),
           (272, 'Tune', 0, 1, 0),
           (272, 'Exp FM gain', 0, 4, 0),
           (272, 'Lin FM gain', 0, 4, 0),
           (272, 'LP filter', 0, 1, 1),
           (273, 'Filter', 0, 1, 0),
           (273, 'Gain', -20, 20, 0),
           (273, 'Section 1', 0, 1, 0),
           (273, 'Frequency 1', 20, 2000, 200),
           (273, 'Bandwidth 1', 0.125, 8, 1),
           (273, 'Gain 1', -20, 20, 0),
           (273, 'Section 2', 0, 1, 0),
           (273, 'Frequency 2', 40, 4000, 400),
           (273, 'Bandwidth 2', 0.125, 8, 1),
           (273, 'Gain 2', -20, 20, 0),
           (273, 'Section 3', 0, 1, 0),
           (273, 'Frequency 3', 100, 10000, 1000),
           (273, 'Bandwidth 3', 0.125, 8, 1),
           (273, 'Gain 3', -20, 20, 0),
           (273, 'Section 4', 0, 1, 0),
           (273, 'Frequency 4', 200, 20000, 2000),
           (273, 'Bandwidth 4', 0.125, 8, 1),
           (273, 'Gain 4', -20, 20, 0),
           (274, 'Input gain', -60, 10, 0),
           (274, 'Exp FM gain', 0, 10, 0),
           (274, 'Resonance', 0, 1, 0),
           (274, 'Resonance gain', 0, 1, 0),
           (274, 'Filter poles', 0, 4, 0),
           (274, 'Output gain', -15, 15, 0),
           (275, 'Input gain', -60, 10, 0),
           (275, 'Exp FM gain', 0, 10, 0),
           (275, 'Resonance', 0, 1, 0),
           (275, 'Resonance gain', 0, 1, 0),
           (275, 'Output gain', -15, 15, 0),
           (276, 'Input gain', -60, 10, 0),
           (276, 'Exp FM gain', 0, 10, 0),
           (276, 'Resonance', 0, 1, 0),
           (276, 'Resonance gain', 0, 1, 0),
           (276, 'Output gain', -15, 15, 0),
           (277, 'Input gain', -60, 10, 0),
           (277, 'Exp. FM gain', 0, 10, 0),
           (277, 'Resonance', 0, 1, 0),
           (277, 'Resonance gain', 0, 1, 0),
           (277, 'Output gain', -15, 15, 0),
           (278, 'Input gain', -60, 10, 0),
           (278, 'Exp FM gain', 0, 10, 0),
           (278, 'Output gain', -15, 15, 0),
           (279, 'Input gain', -40, 10, 0),
           (279, 'Sections', 1, 30, 1),
           (279, 'Frequency', -6, 6, 0),
           (279, 'Exp FM gain', 0, 10, 0),
           (279, 'Lin FM gain', 0, 10, 0),
           (279, 'Feedback gain', -1, 1, 0),
           (279, 'Output mix', -1, 1, 0),
           (280, 'Level', 0, 2, 1),
           (280, 'Program', 0, 8, 0),
           (281, 'Level', 0, 2, 1),
           (281, 'Program', 0, 8, 0),
           (282, 'Level', 0, 2, 1),
           (282, 'Program', 0, 8, 0),
           (283, 'Level', 0, 2, 1),
           (283, 'Program', 0, 8, 0),
           (284, 'Level', 0, 2, 1),
           (284, 'Program', 0, 8, 0),
           (285, 'Level', 0, 2, 1),
           (285, 'Program', 0, 8, 0),
           (286, 'Level', 0, 2, 1),
           (286, 'Program', 0, 8, 0),
           (287, 'Level', 0, 2, 1),
           (287, 'Program', 0, 8, 0),
           (288, 'Level', 0, 2, 1),
           (288, 'Program', 0, 8, 0),
           (289, 'Level', 0, 2, 1),
           (289, 'Program', 0, 8, 0),
           (290, 'Level', 0, 2, 1),
           (290, 'Program', 0, 8, 0),
           (291, 'Level', 0, 2, 1),
           (291, 'Program', 0, 8, 0),
           (292, 'Level', 0, 2, 1),
           (292, 'Program', 0, 8, 0),
           (293, 'Level', 0, 2, 1),
           (293, 'Program', 0, 31, 0),
           (294, 'Level', 0, 2, 1),
           (294, 'Program', 0, 8, 0),
           (295, 'Level', 0, 2, 1),
           (295, 'Program', 0, 8, 0),
           (296, 'Level', 0, 2, 1),
           (296, 'Program', 0, 8, 0),
           (297, 'Level', 0, 2, 1),
           (297, 'Program', 0, 325, 0),
           (298, 'Master Volume', 0, 1, 0.5),
           (298, 'Master Pitch', -12, 12, 0),
           (298, 'Record Over Last Played Pad', 0, 1, 0),
           (298, 'Sequencer BPM', 40, 240, 120),
           (299, 'Shape', 0, 1, 0.5),
           (299, 'FBack', 0, 1, 0),
           (299, 'Source', 0, 1, 0),
           (299, 'Foot', 0, 1, 1),
           (300, 'Frequency', 0, 100, 50),
           (300, 'Width', 0, 100, 75),
           (301, 'Waveform', 0, 1, 0),
           (301, 'Tuning', -12, 12, 0),
           (301, 'Cutoff', 0, 100, 25),
           (301, 'VCF Resonance', 0, 95, 25),
           (301, 'Env Mod', 0, 100, 50),
           (301, 'Decay', 0, 100, 75),
           (301, 'Accent', 0, 100, 25),
           (301, 'Volume', 0, 100, 75),
           (302, 'Damping', 0, 100, 50),
           (302, 'Density', 0, 100, 50),
           (302, 'Bandwidth', 0, 100, 50),
           (302, 'Decay', 0, 100, 50),
           (302, 'Predelay', 0, 100, 50),
           (302, 'Size', 5, 100, 75),
           (302, 'Gain', 0, 100, 100),
           (302, 'Mix', 0, 100, 50),
           (302, 'Early/Late Mix', 0, 100, 50),
           (303, 'blur', 0, 0.25, 0),
           (303, 'window', 0.10000000149011612, 1000, 100),
           (303, 'ratio', 0.25, 4, 1),
           (303, 'xfade', 0, 1, 1),
           (304, 'damping', 0, 1, 0.699999988079071),
           (304, 'revtime', 0.10000000149011612, 360, 11),
           (304, 'roomsize', 0.10000000149011612, 300, 75),
           (304, 'spread', 0, 100, 23),
           (304, 'bandwidth', 0, 1, 0.5),
           (304, 'tail', 0, 1, 0.25),
           (304, 'dry', 0, 1, 1),
           (304, 'early', 0, 1, 0.25),
           (305, 'fb2', 0, 1, 0.5),
           (305, 'damp', 0, 1, 0.5),
           (305, 'fb1', 0, 1, 0.8999999761581421),
           (305, 'spread', 0, 400, 0),
           (306, 'resolution', 1, 16, 6),
           (307, 'Sustain', 0, 1, 0),
           (308, 'New Cycle Vol', 0, 1, 1),
           (308, 'Input Vol', 0, 1, 1),
           (309, 'Depth', 0, 1, 1),
           (309, 'Thres', 0, 1, 0.5),
           (310, 'Low', -24, 24, 0),
           (310, 'Mid', -24, 24, 0),
           (310, 'High', -24, 24, 0),
           (310, 'Master', -24, 24, 0),
           (310, 'Low-Mid Freq', 0, 1000, 220),
           (310, 'Mid-High Freq', 1000, 20000, 2000),
           (311, 'Low', -24, 24, 0),
           (311, 'Mid', -24, 24, 0),
           (311, 'High', -24, 24, 0),
           (311, 'Master', -24, 24, 0),
           (311, 'Low-Mid Freq', 0, 1000, 220),
           (311, 'Mid-High Freq', 1000, 20000, 2000),
           (312, 'Pan', -1, 1, 0),
           (312, 'Width', 0, 1, 1),
           (313, 'Volume', 9.999999974752427e-7, 1, 0.75),
           (314, 'Model', 0, 8, 0),
           (314, 'Bass', 0, 1, 0.5),
           (314, 'Mid', 0, 1, 0.5),
           (314, 'Treble', 0, 1, 0.5),
           (315, 'Low Frequency', 50, 400, 225),
           (315, 'Low Compression', 0, 1, 0.5),
           (315, 'Low Gain', 0, 1, 0.25),
           (315, 'High Frequency', 400, 5000, 1350),
           (315, 'High Gain', 0, 1, 0.25),
           (316, 'Low Frequency', 50, 400, 225),
           (316, 'Low Compression', 0, 1, 0.5),
           (316, 'Low Gain', 0, 1, 0.25),
           (316, 'High Frequency', 400, 5000, 1350),
           (316, 'High Gain', 0, 1, 0.25),
           (317, 'Frequency', 0.00009999999747378752, 20000, 440),
           (317, 'Volume', 9.999999974752427e-7, 1, 0.5),
           (318, 'BPM', 30, 164, 100),
           (318, 'Divider', 2, 4, 3),
           (318, 'Feedback', 0, 1, 0.75),
           (318, 'Dry', 0, 1, 0.75),
           (318, 'Blend', 0, 1, 1),
           (318, 'Tune', 415, 467, 440),
           (319, 'Mode', 0, 11, 1),
           (319, 'Gain', -24, 72, 0),
           (319, 'Bias', 0, 1, 0),
           (320, 'Bandwidth', 0, 1, 0.9994999766349792),
           (320, 'Tail', 0, 1, 0.5),
           (320, 'Damping', 0, 1, 0.0005000000237487257),
           (320, 'Blend', 0, 1, 0.25),
           (321, 'Bandwidth', 0, 1, 0.9994999766349792),
           (321, 'Tail', 0, 1, 0.5),
           (321, 'Damping', 0, 1, 0.0005000000237487257),
           (321, 'Blend', 0, 1, 0.25),
           (322, 'Rate', 0, 1, 0.25),
           (322, 'LFO', 0, 1, 0),
           (322, 'Depth', 0, 1, 0.75),
           (322, 'Spread', 0, 1, 0.75),
           (322, 'Resonance', 0, 1, 0.25),
           (323, 'Open', -60, 0, -45),
           (323, 'Attack', 0, 5, 0),
           (323, 'Close', -80, 0, -67.5),
           (323, 'Mains', 0, 100, 50),
           (324, 'Mode', 0, 1, 0),
           (324, 'Strength', 0, 1, 0.25),
           (325, 'Rate', 0, 1, 0.25),
           (325, 'Mode', 0, 1, 0),
           (325, 'X', 0, 1, 1),
           (325, 'Y', 0, 1, 0),
           (325, 'Z', 0, 1, 0.5),
           (325, 'HP', 0, 1, 0.5),
           (325, 'Volume', 9.999999974752427e-7, 1, 0.5),
           (326, 'A: Active', 0, 1, 0),
           (326, 'A: Frequency', 20, 14000, 3500),
           (326, 'A: Bandwidth', 0.125, 8, 1),
           (326, 'A: Gain', -24, 24, 0),
           (326, 'B: Active', 0, 1, 0),
           (326, 'B: Frequency', 20, 14000, 6000),
           (326, 'B: Bandwidth', 0.125, 8, 1),
           (326, 'B: Gain', -24, 24, 0),
           (326, 'C: Active', 0, 1, 0),
           (326, 'C: Frequency', 20, 14000, 8000),
           (326, 'C: Bandwidth', 0.125, 8, 1),
           (326, 'C: Gain', -24, 24, 0),
           (326, 'D: Active', 0, 1, 0),
           (326, 'D: Frequency', 20, 14000, 11000),
           (326, 'D: Bandwidth', 0.125, 8, 1),
           (326, 'D: Gain', -24, 24, 0),
           (326, 'Gain', -24, 24, 0),
           (327, 'A: Mode', -1, 2, 0),
           (327, 'A: Frequency', 20, 14000, 102.87000274658203),
           (327, 'A: Bandwidth', 0, 1, 0.25),
           (327, 'A: Gain', -48, 24, 0),
           (327, 'B: Mode', -1, 2, 1),
           (327, 'B: Frequency', 20, 14000, 529.1500244140625),
           (327, 'B: Bandwidth', 0, 1, 0.25),
           (327, 'B: Gain', -48, 24, 0),
           (327, 'C: Mode', -1, 2, 1),
           (327, 'C: Frequency', 20, 14000, 1080),
           (327, 'C: Bandwidth', 0, 1, 0.25),
           (327, 'C: Gain', -48, 24, 0),
           (327, 'D: Mode', -1, 2, 2),
           (327, 'D: Frequency', 20, 14000, 2721.780029296875),
           (327, 'D: Bandwidth', 0, 1, 0.25),
           (327, 'D: Gain', -48, 24, 0),
           (328, '31 Hz', -48, 24, 0),
           (328, '63 Hz', -48, 24, 0),
           (328, '125 Hz', -48, 24, 0),
           (328, '250 Hz', -48, 24, 0),
           (328, '500 Hz', -48, 24, 0),
           (328, '1 kHz', -48, 24, 0),
           (328, '2 kHz', -48, 24, 0),
           (328, '4 kHz', -48, 24, 0),
           (328, '8 kHz', -48, 24, 0),
           (328, '16 kHz', -48, 24, 0),
           (329, '31 Hz', -48, 24, 0),
           (329, '63 Hz', -48, 24, 0),
           (329, '125 Hz', -48, 24, 0),
           (329, '250 Hz', -48, 24, 0),
           (329, '500 Hz', -48, 24, 0),
           (329, '1 kHz', -48, 24, 0),
           (329, '2 kHz', -48, 24, 0),
           (329, '4 kHz', -48, 24, 0),
           (329, '8 kHz', -48, 24, 0),
           (329, '16 kHz', -48, 24, 0),
           (330, 'Measure', 0, 1, 1),
           (330, 'Mode', 0, 2, 1),
           (330, 'Threshold', 0, 1, 0.5),
           (330, 'Strength', 0, 1, 0.25),
           (330, 'Attack', 0, 1, 0.75),
           (330, 'Release', 0, 1, 0.5),
           (330, 'Gain', -12, 18, 3),
           (331, 'Measure', 0, 1, 0),
           (331, 'Mode', 0, 2, 1),
           (331, 'Threshold', 0, 1, 0.5),
           (331, 'Strength', 0, 1, 0.25),
           (331, 'Attack', 0, 1, 0.75),
           (331, 'Release', 0, 1, 0.5),
           (331, 'Gain', -12, 18, 3),
           (332, 'Model', 0, 3, 1),
           (332, 'BPM', 4, 240, 63),
           (332, 'Volume', 0, 1, 0.75),
           (332, 'Damping', 0, 1, 0.75),
           (333, 'Time', 2.5, 40, 10),
           (333, 'Width', 0.5, 10, 3),
           (333, 'Rate', 0.019999999552965164, 5, 1.25),
           (333, 'Blend', 0, 1, 0.25),
           (333, 'Feedforward', 0, 1, 0.25),
           (333, 'Feedback', 0, 1, 0.25),
           (334, 'Profit per minute', 30, 232, 80),
           (334, 'Volume', 0, 1, 0.75),
           (334, 'Damping', 0, 1, 0),
           (335, 'Model', 0, 24, 12),
           (335, 'Gain', -24, 24, 0),
           (336, 'Model', 0, 16, 1),
           (336, 'Alt', 0, 1, 0),
           (336, 'Gain', -24, 24, 0),
           (337, 'Mode', 0, 1, 1),
           (337, 'Filter', 0, 1, 1),
           (337, 'Frequency', 20, 3400, 2555),
           (337, 'Q', 0, 1, 0.25),
           (337, 'Depth', 0, 1, 1),
           (337, 'LFO/Envelope', 0, 1, 0.25),
           (337, 'Rate', 0, 1, 0.25),
           (337, 'X/Z', 0, 1, 1),
           (338, 'Over', 0, 2, 1),
           (338, 'Gain', 0, 1, 0.25),
           (338, 'Bright', 0, 1, 0.75),
           (338, 'Power', 0, 1, 0.5),
           (338, 'Tonestack', 0, 8, 1),
           (338, 'Bass', 0, 1, 0.25),
           (338, 'Mid', 0, 1, 1),
           (338, 'Treble', 0, 1, 0.75),
           (338, 'Attack', 0, 1, 0.75),
           (338, 'Squash', 0, 1, 0.25),
           (338, 'Low Cut', 0.10000000149011612, 1, 0.5),
           (339, 'Bypass', 0, 1, 0),
           (339, 'Input', 0.015625, 10, 1),
           (339, 'Output', 0.015625, 0.115625, 0.015625),
           (339, 'Mix', 0, 1, 0.8500000238418579),
           (339, 'Resonance', 0.7070000171661377, 32, 2),
           (339, 'Mode', 0, 11, 7),
           (339, 'Attack', 1, 500, 20),
           (339, 'Release', 10, 5000, 200),
           (339, 'Upper', 10, 20000, 3000),
           (339, 'Lower', 10, 20000, 80),
           (339, 'Activation', 0.015625, 64, 1),
           (339, 'Sidechain', 0, 1, 0),
           (339, 'Response', -1, 1, 0),
           (340, 'Gain', 0.015625, 64, 1),
           (340, 'Filter Mode', 0, 2, 1),
           (340, 'Transition 1', 10, 20000, 50),
           (340, 'Transition 2', 10, 20000, 500),
           (340, 'Transition 3', 10, 20000, 5000),
           (340, 'Gain 1', 0.015625, 64, 1),
           (340, 'Active 1', 0, 1, 1),
           (340, 'Phase 1', 0, 1, 0),
           (340, 'Delay 1', 0, 20, 0),
           (340, 'Gain 2', 0.015625, 64, 1),
           (340, 'Active 2', 0, 1, 1),
           (340, 'Phase 2', 0, 1, 0),
           (340, 'Delay 2', 0, 20, 0),
           (340, 'Gain 3', 0.015625, 64, 1),
           (340, 'Active 3', 0, 1, 1),
           (340, 'Phase 3', 0, 1, 0),
           (340, 'Delay 3', 0, 20, 0),
           (340, 'Gain 4', 0.015625, 64, 1),
           (340, 'Active 4', 0, 1, 1),
           (340, 'Phase 4', 0, 1, 0),
           (340, 'Delay 4', 0, 20, 0),
           (341, 'Gain', 0.015625, 64, 1),
           (341, 'Filter Mode', 0, 2, 1),
           (341, 'Transition 1', 10, 20000, 150),
           (341, 'Transition 2', 10, 20000, 3000),
           (341, 'Gain 1', 0.015625, 64, 1),
           (341, 'Active 1', 0, 1, 1),
           (341, 'Phase 1', 0, 1, 0),
           (341, 'Delay 1', 0, 20, 0),
           (341, 'Gain 2', 0.015625, 64, 1),
           (341, 'Active 2', 0, 1, 1),
           (341, 'Phase 2', 0, 1, 0),
           (341, 'Delay 2', 0, 20, 0),
           (341, 'Gain 3', 0.015625, 64, 1),
           (341, 'Active 3', 0, 1, 1),
           (341, 'Phase 3', 0, 1, 0),
           (341, 'Delay 3', 0, 20, 0),
           (342, 'Gain', 0.015625, 64, 1),
           (342, 'Filter Mode', 0, 2, 1),
           (342, 'Transition 1', 10, 20000, 1000),
           (342, 'Gain 1', 0.015625, 64, 1),
           (342, 'Active 1', 0, 1, 1),
           (342, 'Phase 1', 0, 1, 0),
           (342, 'Delay 1', 0, 20, 0),
           (342, 'Gain 2', 0.015625, 64, 1),
           (342, 'Active 2', 0, 1, 1),
           (342, 'Phase 2', 0, 1, 0),
           (342, 'Delay 2', 0, 20, 0),
           (343, 'Bypass', 0, 1, 0),
           (343, 'Link', 0, 1, 1),
           (343, 'Detectors', 0, 1, 1),
           (343, 'Carrier In', 0.015625, 64, 1),
           (343, 'Modulator In', 0.015625, 64, 1),
           (343, 'Out', 0.015625, 64, 1),
           (343, 'Carrier', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Modulator', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Processed', 0.00001584900019224733, 16, 1),
           (343, 'Isolation', 2, 9, 4),
           (343, 'Bands', 0, 4, 2),
           (343, 'High-Q', 0, 1, 1),
           (343, 'Attack', 0.10000000149011612, 500, 5),
           (343, 'Release', 0.10000000149011612, 5000, 50),
           (343, 'Analyzer', 0, 4, 0),
           (343, 'Vol 1', 0.00001584900019224733, 16, 1),
           (343, 'Pan 1', -1, 1, 0),
           (343, 'Noise 1', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 1', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 1', 0, 1, 0),
           (343, 'Vol 2', 0.00001584900019224733, 16, 1),
           (343, 'Pan 2', -1, 1, 0),
           (343, 'Noise 2', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 2', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 2', 0, 1, 0),
           (343, 'Vol 3', 0.00001584900019224733, 16, 1),
           (343, 'Pan 3', -1, 1, 0),
           (343, 'Noise 3', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 3', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 3', 0, 1, 0),
           (343, 'Vol 4', 0.00001584900019224733, 16, 1),
           (343, 'Pan 4', -1, 1, 0),
           (343, 'Noise 4', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 4', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 4', 0, 1, 0),
           (343, 'Vol 5', 0.00001584900019224733, 16, 1),
           (343, 'Pan 5', -1, 1, 0),
           (343, 'Noise 5', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 5', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 5', 0, 1, 0),
           (343, 'Vol 6', 0.00001584900019224733, 16, 1),
           (343, 'Pan 6', -1, 1, 0),
           (343, 'Noise 6', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 6', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 6', 0, 1, 0),
           (343, 'Vol 7', 0.00001584900019224733, 16, 1),
           (343, 'Pan 7', -1, 1, 0),
           (343, 'Noise 7', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 7', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 7', 0, 1, 0),
           (343, 'Vol 8', 0.00001584900019224733, 16, 1),
           (343, 'Pan 8', -1, 1, 0),
           (343, 'Noise 8', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 8', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 8', 0, 1, 0),
           (343, 'Vol 9', 0.00001584900019224733, 16, 1),
           (343, 'Pan 9', -1, 1, 0),
           (343, 'Noise 9', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 9', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 9', 0, 1, 0),
           (343, 'Vol 10', 0.00001584900019224733, 16, 1),
           (343, 'Pan 10', -1, 1, 0),
           (343, 'Noise 10', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 10', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 10', 0, 1, 0),
           (343, 'Vol 11', 0.00001584900019224733, 16, 1),
           (343, 'Pan 11', -1, 1, 0),
           (343, 'Noise 11', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 11', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 11', 0, 1, 0),
           (343, 'Vol 12', 0.00001584900019224733, 16, 1),
           (343, 'Pan 12', -1, 1, 0),
           (343, 'Noise 12', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 12', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 12', 0, 1, 0),
           (343, 'Vol 13', 0.00001584900019224733, 16, 1),
           (343, 'Pan 13', -1, 1, 0),
           (343, 'Noise 13', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 13', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 13', 0, 1, 0),
           (343, 'Vol 14', 0.00001584900019224733, 16, 1),
           (343, 'Pan 14', -1, 1, 0),
           (343, 'Noise 14', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 14', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 14', 0, 1, 0),
           (343, 'Vol 15', 0.00001584900019224733, 16, 1),
           (343, 'Pan 15', -1, 1, 0),
           (343, 'Noise 15', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 15', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 15', 0, 1, 0),
           (343, 'Vol 16', 0.00001584900019224733, 16, 1),
           (343, 'Pan 16', -1, 1, 0),
           (343, 'Noise 16', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 16', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 16', 0, 1, 0),
           (343, 'Vol 17', 0.00001584900019224733, 16, 1),
           (343, 'Pan 17', -1, 1, 0),
           (343, 'Noise 17', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 17', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 17', 0, 1, 0),
           (343, 'Vol 18', 0.00001584900019224733, 16, 1),
           (343, 'Pan 18', -1, 1, 0),
           (343, 'Noise 18', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 18', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 18', 0, 1, 0),
           (343, 'Vol 19', 0.00001584900019224733, 16, 1),
           (343, 'Pan 19', -1, 1, 0),
           (343, 'Noise 19', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 19', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 19', 0, 1, 0),
           (343, 'Vol 20', 0.00001584900019224733, 16, 1),
           (343, 'Pan 20', -1, 1, 0),
           (343, 'Noise 20', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 20', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 20', 0, 1, 0),
           (343, 'Vol 21', 0.00001584900019224733, 16, 1),
           (343, 'Pan 21', -1, 1, 0),
           (343, 'Noise 21', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 21', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 21', 0, 1, 0),
           (343, 'Vol 22', 0.00001584900019224733, 16, 1),
           (343, 'Pan 22', -1, 1, 0),
           (343, 'Noise 22', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 22', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 22', 0, 1, 0),
           (343, 'Vol 23', 0.00001584900019224733, 16, 1),
           (343, 'Pan 23', -1, 1, 0),
           (343, 'Noise 23', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 23', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 23', 0, 1, 0),
           (343, 'Vol 24', 0.00001584900019224733, 16, 1),
           (343, 'Pan 24', -1, 1, 0),
           (343, 'Noise 24', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 24', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 24', 0, 1, 0),
           (343, 'Vol 25', 0.00001584900019224733, 16, 1),
           (343, 'Pan 25', -1, 1, 0),
           (343, 'Noise 25', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 25', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 25', 0, 1, 0),
           (343, 'Vol 26', 0.00001584900019224733, 16, 1),
           (343, 'Pan 26', -1, 1, 0),
           (343, 'Noise 26', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 26', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 26', 0, 1, 0),
           (343, 'Vol 27', 0.00001584900019224733, 16, 1),
           (343, 'Pan 27', -1, 1, 0),
           (343, 'Noise 27', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 27', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 27', 0, 1, 0),
           (343, 'Vol 28', 0.00001584900019224733, 16, 1),
           (343, 'Pan 28', -1, 1, 0),
           (343, 'Noise 28', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 28', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 28', 0, 1, 0),
           (343, 'Vol 29', 0.00001584900019224733, 16, 1),
           (343, 'Pan 29', -1, 1, 0),
           (343, 'Noise 29', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 29', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 29', 0, 1, 0),
           (343, 'Vol 30', 0.00001584900019224733, 16, 1),
           (343, 'Pan 30', -1, 1, 0),
           (343, 'Noise 30', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 30', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 30', 0, 1, 0),
           (343, 'Vol 31', 0.00001584900019224733, 16, 1),
           (343, 'Pan 31', -1, 1, 0),
           (343, 'Noise 31', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 31', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 31', 0, 1, 0),
           (343, 'Vol 32', 0.00001584900019224733, 16, 1),
           (343, 'Pan 32', -1, 1, 0),
           (343, 'Noise 32', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Dry 32', 0.00001584900019224733, 16, 0.00001584900019224733),
           (343, 'Solo 32', 0, 1, 0),
           (344, 'Tempo', 30, 300, 120),
           (344, 'Host BPM', 1, 300, 120),
           (344, 'Subdivide', 1, 16, 4),
           (344, 'Time L', 1, 16, 3),
           (344, 'Time R', 1, 16, 5),
           (344, 'Feedback', 0, 1, 0.5),
           (344, 'Amount', 0, 4, 0.25),
           (344, 'Mix mode', 0, 3, 1),
           (344, 'Medium', 0, 2, 1),
           (344, 'Dry Amount', 0, 4, 1),
           (344, 'Stereo Width', -1, 1, 1),
           (344, 'Sync BPM', 0, 1, 0),
           (345, 'Bypass', 0, 1, 0),
           (345, 'Input Gain', 0.015625, 64, 1),
           (345, 'Output Gain', 0.015625, 64, 1),
           (345, 'Mix', 0, 1, 1),
           (345, 'Attack Time', 1, 500, 30),
           (345, 'Attack Boost', -1, 1, 0),
           (345, 'Sustain Threshold', 0.0009765619761310518, 1, 1),
           (345, 'Release Time', 1, 5000, 300),
           (345, 'Release Boost', -1, 1, 0),
           (345, 'Display', 50, 5000, 2000),
           (345, 'Threshold', 0.00024414100334979594, 1, 0.00024414100334979594),
           (345, 'Lookahead', 0, 100, 0),
           (345, 'View Mode', 0, 3, 0),
           (345, 'Highpass', 20, 20000, 100),
           (345, 'Lowpass', 20, 20000, 5000),
           (345, 'HP-Mode', 0, 3, 0),
           (345, 'LP-Mode', 0, 3, 0),
           (345, 'Listen', 0, 1, 0),
           (346, 'Bypass', 0, 1, 0),
           (346, 'Input Gain', 0.015625, 64, 0.5),
           (346, 'Output Gain', 0.015625, 64, 1),
           (346, 'Mix', 0, 1, 1),
           (346, 'Filter', 1000, 20000, 12500),
           (346, 'Speed Simulation', 0, 1, 1),
           (346, 'Noise', 0, 1, 0.10000000149011612),
           (346, 'Mechanical', 0, 1, 0.20000000298023224),
           (346, 'Magnetical', 0, 1, 1),
           (346, 'Post-Filter', 0, 1, 0),
           (347, 'Bypass', 0, 1, 0),
           (347, 'Input Gain', 0.015625, 64, 1),
           (347, 'Output Gain', 0.015625, 64, 1),
           (347, 'Balance In', -1, 1, 0),
           (347, 'Balance Out', -1, 1, 0),
           (347, 'Softclip', 0, 1, 0),
           (347, 'Mute L', 0, 1, 0),
           (347, 'Mute R', 0, 1, 0),
           (347, 'Phase L', 0, 1, 0),
           (347, 'Phase R', 0, 1, 0),
           (347, 'Mode', 0, 6, 0),
           (347, 'S Level', -1, 1, 0),
           (347, 'S Balance', -1, 1, 0),
           (347, 'M Level', -1, 1, 0),
           (347, 'M Panorama', -1, 1, 0),
           (347, 'Stereo Base', -1, 1, 0),
           (347, 'Delay', -20, 20, 0),
           (347, 'S/C Level', 1, 100, 1),
           (347, 'Stereo Phase', 0, 360, 0),
           (348, 'Bypass', 0, 1, 0),
           (348, 'Input Gain', 0.015625, 64, 1),
           (348, 'Output Gain', 0.015625, 64, 1),
           (348, 'Split 1/2', 10, 20000, 100),
           (348, 'Split 2/3', 10, 20000, 750),
           (348, 'Split 3/4', 10, 20000, 5000),
           (348, 'Filter Mode', 0, 1, 1),
           (348, 'Limit', 0.0625, 1, 1),
           (348, 'Lookahead', 0.10000000149011612, 10, 4),
           (348, 'Release', 1, 1000, 30),
           (348, 'Min Release', 0, 1, 0),
           (348, 'Weight 1', -1, 1, 0),
           (348, 'Weight 2', -1, 1, 0),
           (348, 'Weight 3', -1, 1, 0),
           (348, 'Weight 4', -1, 1, 0),
           (348, 'Weight S/C', -1, 1, 0),
           (348, 'Release 1', -1, 1, 0.5),
           (348, 'Release 2', -1, 1, 0.20000000298023224),
           (348, 'Release 3', -1, 1, -0.20000000298023224),
           (348, 'Release 4', -1, 1, -0.5),
           (348, 'Release S/C', -1, 1, -0.5),
           (348, 'Solo 1', 0, 1, 0),
           (348, 'Solo 2', 0, 1, 0),
           (348, 'Solo 3', 0, 1, 0),
           (348, 'Solo 4', 0, 1, 0),
           (348, 'Solo S/C', 0, 1, 0),
           (348, 'ASC', 0, 1, 1),
           (348, 'ASC Level', 0, 1, 0.5),
           (348, 'Oversampling', 1, 4, 1),
           (348, 'Level S/C', 0.015625, 64, 1),
           (349, 'Bypass', 0, 1, 0),
           (349, 'Input', 0.015625, 64, 1),
           (349, 'Max Gain Reduction', 0.00001584900019224733, 1, 0.061250001192092896),
           (349, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (349, 'Ratio', 1, 20, 2),
           (349, 'Attack', 0.009999999776482582, 2000, 20),
           (349, 'Release', 0.009999999776482582, 2000, 250),
           (349, 'Makeup Gain', 1, 64, 1),
           (349, 'Knee', 1, 8, 2.828429937362671),
           (349, 'Detection', 0, 1, 0),
           (349, 'Stereo Link', 0, 1, 1),
           (349, 'S/C Mode', 0, 9, 0),
           (349, 'F1 Freq', 10, 18000, 250),
           (349, 'F2 Freq', 10, 18000, 4500),
           (349, 'F1 Level', 0.0625, 16, 1),
           (349, 'F2 Level', 0.0625, 16, 1),
           (349, 'S/C-Listen', 0, 1, 0),
           (349, 'S/C Route', 0, 1, 0),
           (349, 'S/C Level', 0.015625, 64, 1),
           (350, 'Bypass', 0, 1, 0),
           (350, 'Input', 0.015625, 64, 1),
           (350, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (350, 'Ratio', 1, 20, 2),
           (350, 'Attack', 0.009999999776482582, 2000, 20),
           (350, 'Release', 0.009999999776482582, 2000, 250),
           (350, 'Makeup Gain', 1, 64, 2),
           (350, 'Knee', 1, 8, 2.828429937362671),
           (350, 'Detection', 0, 1, 0),
           (350, 'Stereo Link', 0, 1, 1),
           (350, 'S/C Mode', 0, 9, 0),
           (350, 'F1 Freq', 10, 18000, 250),
           (350, 'F2 Freq', 10, 18000, 4500),
           (350, 'F1 Level', 0.0625, 16, 1),
           (350, 'F2 Level', 0.0625, 16, 1),
           (350, 'S/C-Listen', 0, 1, 0),
           (350, 'S/C Route', 0, 1, 0),
           (350, 'S/C Level', 0.015625, 64, 1),
           (350, 'Mix', 0, 1, 1),
           (351, 'Bypass', 0, 1, 0),
           (351, 'Input Gain', 0.015625, 64, 1),
           (351, 'Output Gain', 0.015625, 64, 1),
           (351, 'Mix', 0, 1, 1),
           (351, 'Saturation', 0.10000000149011612, 10, 5),
           (351, 'Blend', -10, 10, 10),
           (351, 'Lowpass', 10, 20000, 20000),
           (351, 'Highpass', 10, 20000, 10),
           (351, 'Lowpass', 10, 20000, 20000),
           (351, 'Highpass', 10, 20000, 10),
           (351, 'Tone', 80, 8000, 2000),
           (351, 'Amount', 0.0625, 16, 1),
           (351, 'Gradient', 0.10000000149011612, 10, 1),
           (352, 'Speed Mode', 0, 5, 5),
           (352, 'Tap Spacing', 0, 1, 0.5),
           (352, 'Tap Offset', 0, 1, 0.5),
           (352, 'FM Depth', 0, 1, 0.44999998807907104),
           (352, 'Treble Motor', 10, 600, 36),
           (352, 'Bass Motor', 10, 600, 30),
           (352, 'Mic Distance', 0, 1, 0.699999988079071),
           (352, 'Reflection', 0, 1, 0.30000001192092896),
           (352, 'AM Depth', 0, 1, 0.44999998807907104),
           (352, 'Test', 0, 1, 0),
           (353, 'Bypass', 0, 1, 0),
           (353, 'Input Gain', 0.015625, 64, 1),
           (353, 'Output Gain', 0.015625, 64, 1),
           (353, 'Modulator', 0, 4, 0),
           (353, 'Mod Freq', 1, 20000, 1000),
           (353, 'Mod Amount', 0, 1, 0.5),
           (353, 'Mod Phase', 0, 1, 0.5),
           (353, 'Mod Detune', -200, 200, 0),
           (353, 'Listen', 0, 1, 0),
           (353, 'LFO 1', 0, 4, 0),
           (353, 'LFO 1 Freq', 0.009999999776482582, 10, 0.10000000149011612),
           (353, 'Reset 1', 0, 1, 0),
           (353, 'Mod Freq LO', 1, 20000, 100),
           (353, 'Mod Freq HI', 1, 20000, 10000),
           (353, 'Mod Freq Active', 0, 1, 0),
           (353, 'Mod Detune LO', -200, 200, -100),
           (353, 'Mod Detune HI', -200, 200, 100),
           (353, 'Mod Detune Active', 0, 1, 0),
           (353, 'LFO 2', 0, 4, 0),
           (353, 'LFO 2 Freq', 0.009999999776482582, 10, 0.20000000298023224),
           (353, 'Reset 2', 0, 1, 0),
           (353, 'LFO Freq LO', 0.009999999776482582, 10, 0.05000000074505806),
           (353, 'LFO Freq HI', 0.009999999776482582, 10, 0.5),
           (353, 'LFO 1 Freq Active', 0, 1, 0),
           (353, 'Mod Amount LO', 0, 1, 0.30000001192092896),
           (353, 'Mod Amount HI', 0, 1, 0.6000000238418579),
           (353, 'Mod Amount Active', 0, 1, 0),
           (354, 'Tempo', 30, 300, 120),
           (354, 'Host BPM', 1, 300, 120),
           (354, 'Subdivide', 1, 16, 4),
           (354, 'Time L', 1, 16, 5),
           (354, 'Time R', 1, 16, 5),
           (354, 'Feedback', 0, 1, 0.5),
           (354, 'Dry/Wet', -1, 1, 0),
           (354, 'Stereo Width', 0, 1, 0),
           (354, 'Sync BPM', 0, 1, 0),
           (354, 'Reset', 0, 1, 0),
           (354, 'Window', 0, 1, 0.5),
           (355, 'Decay time', 0.4000000059604645, 15, 1.5),
           (355, 'High Frq Damp', 2000, 20000, 5000),
           (355, 'Room size', 0, 5, 2),
           (355, 'Diffusion', 0, 1, 0.5),
           (355, 'Wet Amount', 0, 2, 0.25),
           (355, 'Dry Amount', 0, 2, 1),
           (355, 'Pre Delay', 0, 500, 0),
           (355, 'Bass Cut', 20, 20000, 300),
           (355, 'Treble Cut', 20, 20000, 5000),
           (356, 'Bypass', 0, 1, 0),
           (356, 'Input Gain', 0.015625, 64, 1),
           (356, 'Output Gain', 0.015625, 64, 1),
           (356, 'Mode', 0, 4, 0),
           (356, 'Frequency', 0.009999999776482582, 100, 1),
           (356, 'Modulation', 0, 1, 1),
           (356, 'Offset L/R', 0, 1, 0.5),
           (356, 'Mono-in', 0, 1, 0),
           (356, 'Reset', 0, 1, 0),
           (357, 'Center Freq', 20, 20000, 1000),
           (357, 'Mod depth', 0, 10800, 4000),
           (357, 'Mod rate', 0.009999999776482582, 20, 0.25),
           (357, 'Feedback', -0.9900000095367432, 0.9900000095367432, 0.25),
           (357, '# Stages', 1, 12, 6),
           (357, 'Stereo phase', 0, 360, 180),
           (357, 'Reset', 0, 1, 0),
           (357, 'Amount', 0, 4, 1),
           (357, 'Dry Amount', 0, 4, 1),
           (358, '16''', 0, 8, 8),
           (358, '5 1/3''', 0, 8, 8),
           (358, '8''', 0, 8, 8),
           (358, '4''', 0, 8, 0),
           (358, '2 2/3''', 0, 8, 0),
           (358, '2''', 0, 8, 0),
           (358, '1 3/5''', 0, 8, 0),
           (358, '1 1/3''', 0, 8, 0),
           (358, '1''', 0, 8, 8),
           (358, 'Freq 1', 1, 32, 1),
           (358, 'Freq 2', 1, 32, 3),
           (358, 'Freq 3', 1, 32, 2),
           (358, 'Freq 4', 1, 32, 4),
           (358, 'Freq 5', 1, 32, 6),
           (358, 'Freq 6', 1, 32, 8),
           (358, 'Freq 7', 1, 32, 10),
           (358, 'Freq 8', 1, 32, 12),
           (358, 'Freq 9', 1, 32, 16),
           (358, 'Wave 1', 0, 35, 0),
           (358, 'Wave 2', 0, 35, 0),
           (358, 'Wave 3', 0, 35, 0),
           (358, 'Wave 4', 0, 35, 0),
           (358, 'Wave 5', 0, 35, 0),
           (358, 'Wave 6', 0, 35, 0),
           (358, 'Wave 7', 0, 35, 0),
           (358, 'Wave 8', 0, 35, 0),
           (358, 'Wave 9', 0, 35, 0),
           (358, 'Detune 1', -100, 100, 0),
           (358, 'Detune 2', -100, 100, 0),
           (358, 'Detune 3', -100, 100, 0),
           (358, 'Detune 4', -100, 100, 0),
           (358, 'Detune 5', -100, 100, 0),
           (358, 'Detune 6', -100, 100, 0),
           (358, 'Detune 7', -100, 100, 0),
           (358, 'Detune 8', -100, 100, 0),
           (358, 'Detune 9', -100, 100, 0),
           (358, 'Phase 1', 0, 360, 0),
           (358, 'Phase 2', 0, 360, 0),
           (358, 'Phase 3', 0, 360, 0),
           (358, 'Phase 4', 0, 360, 0),
           (358, 'Phase 5', 0, 360, 0),
           (358, 'Phase 6', 0, 360, 0),
           (358, 'Phase 7', 0, 360, 0),
           (358, 'Phase 8', 0, 360, 0),
           (358, 'Phase 9', 0, 360, 0),
           (358, 'Pan 1', -1, 1, 0),
           (358, 'Pan 2', -1, 1, 0),
           (358, 'Pan 3', -1, 1, 0),
           (358, 'Pan 4', -1, 1, 0),
           (358, 'Pan 5', -1, 1, 0),
           (358, 'Pan 6', -1, 1, 0),
           (358, 'Pan 7', -1, 1, 0),
           (358, 'Pan 8', -1, 1, 0),
           (358, 'Pan 9', -1, 1, 0),
           (358, 'Routing 1', 0, 2, 0),
           (358, 'Routing 2', 0, 2, 0),
           (358, 'Routing 3', 0, 2, 0),
           (358, 'Routing 4', 0, 2, 0),
           (358, 'Routing 5', 0, 2, 0),
           (358, 'Routing 6', 0, 2, 0),
           (358, 'Routing 7', 0, 2, 0),
           (358, 'Routing 8', 0, 2, 0),
           (358, 'Routing 9', 0, 2, 0),
           (358, 'Foldover', 0, 127, 108),
           (358, 'P: Carrier Decay', 10, 3000, 200),
           (358, 'P: Level', 0, 1, 0.25),
           (358, 'P: Carrier Wave', 0, 27, 0),
           (358, 'P: Carrier Frq', 1, 32, 6),
           (358, 'P: Vel->Amp', 0, 1, 0),
           (358, 'P: Modulator Decay', 10, 3000, 200),
           (358, 'P: FM Depth', 0, 4, 0),
           (358, 'P: Modulator Wave', 0, 27, 0),
           (358, 'P: Modulator Frq', 1, 32, 6),
           (358, 'P: Vel->FM', 0, 1, 0),
           (358, 'P: Trigger', 0, 3, 0),
           (358, 'P: Stereo Phase', 0, 360, 90),
           (358, 'Filter 1 To', 0, 1, 0),
           (358, 'Filter 1 Type', 0, 1, 0),
           (358, 'Volume', 0, 1, 0.10000000149011612),
           (358, 'F1 Cutoff', 20, 20000, 2000),
           (358, 'F1 Res', 0.699999988079071, 8, 2),
           (358, 'F1 Env1', -10800, 10800, 8000),
           (358, 'F1 Env2', -10800, 10800, 0),
           (358, 'F1 Env3', -10800, 10800, 0),
           (358, 'F1 KeyFollow', 0, 2, 0),
           (358, 'F2 Cutoff', 20, 20000, 2000),
           (358, 'F2 Res', 0.699999988079071, 8, 2),
           (358, 'F2 Env1', -10800, 10800, 0),
           (358, 'F2 Env2', -10800, 10800, 8000),
           (358, 'F2 Env3', -10800, 10800, 0),
           (358, 'F2 KeyFollow', 0, 2, 0),
           (358, 'EG1 Attack', 1, 20000, 1),
           (358, 'EG1 Decay', 10, 20000, 350),
           (358, 'EG1 Sustain', 0, 1, 0.5),
           (358, 'EG1 Release', 10, 20000, 50),
           (358, 'EG1 VelMod', 0, 1, 0),
           (358, 'EG1 To Amp', 0, 4, 0),
           (358, 'EG2 Attack', 1, 20000, 1),
           (358, 'EG2 Decay', 10, 20000, 350),
           (358, 'EG2 Sustain', 0, 1, 0.5),
           (358, 'EG2 Release', 10, 20000, 50),
           (358, 'EG2 VelMod', 0, 1, 0),
           (358, 'EG2 To Amp', 0, 4, 0),
           (358, 'EG3 Attack', 1, 20000, 1),
           (358, 'EG3 Decay', 10, 20000, 350),
           (358, 'EG3 Sustain', 0, 1, 0.5),
           (358, 'EG3 Release', 10, 20000, 50),
           (358, 'EG3 VelMod', 0, 1, 0),
           (358, 'EG3 To Amp', 0, 4, 0),
           (358, 'Vib Rate', 0.009999999776482582, 240, 6.599999904632568),
           (358, 'Vib Mod Amt', 0, 1, 1),
           (358, 'Vib Wet', 0, 1, 0.5),
           (358, 'Vib Stereo', 0, 360, 180),
           (358, 'Vib Mode', 0, 5, 5),
           (358, 'Vib Type', 0, 4, 3),
           (358, 'Transpose', -24, 24, -12),
           (358, 'Detune', -100, 100, 0),
           (358, 'Polyphony', 1, 32, 16),
           (358, 'Quadratic AmpEnv', 0, 1, 1),
           (358, 'PBend Range', 0, 2400, 200),
           (358, 'Bass Freq', 20, 20000, 80),
           (358, 'Bass Gain', 0.10000000149011612, 10, 1),
           (358, 'Treble Freq', 20, 20000, 12000),
           (358, 'Treble Gain', 0.10000000149011612, 10, 1),
           (359, 'Bypass', 0, 1, 0),
           (359, 'Input Gain', 0.015625, 64, 1),
           (359, 'Output Gain', 0.015625, 64, 1),
           (359, 'Split 1/2', 10, 20000, 100),
           (359, 'Split 2/3', 10, 20000, 750),
           (359, 'Split 3/4', 10, 20000, 5000),
           (359, 'Filter Mode', 0, 1, 1),
           (359, 'Limit', 0.0625, 1, 1),
           (359, 'Lookahead', 0.10000000149011612, 10, 4),
           (359, 'Release', 1, 1000, 30),
           (359, 'Min Release', 0, 1, 0),
           (359, 'Weight 1', -1, 1, 0),
           (359, 'Weight 2', -1, 1, 0),
           (359, 'Weight 3', -1, 1, 0),
           (359, 'Weight 4', -1, 1, 0),
           (359, 'Release 1', -1, 1, 0.5),
           (359, 'Release 2', -1, 1, 0.20000000298023224),
           (359, 'Release 3', -1, 1, -0.20000000298023224),
           (359, 'Release 4', -1, 1, -0.5),
           (359, 'Solo 1', 0, 1, 0),
           (359, 'Solo 2', 0, 1, 0),
           (359, 'Solo 3', 0, 1, 0),
           (359, 'Solo 4', 0, 1, 0),
           (359, 'ASC', 0, 1, 1),
           (359, 'ASC Level', 0, 1, 0.5),
           (359, 'Oversampling', 1, 4, 1),
           (360, 'Bypass', 0, 1, 0),
           (360, 'Input Gain', 0.015625, 64, 1),
           (360, 'Output Gain', 0.015625, 64, 1),
           (360, 'Split 1/2', 10, 20000, 120),
           (360, 'Split 2/3', 10, 20000, 1000),
           (360, 'Split 3/4', 10, 20000, 6000),
           (360, 'Filter Mode', 0, 1, 1),
           (360, 'Reduction 1', 0.00001584900019224733, 1, 0.061250001192092896),
           (360, 'Threshold 1', 0.0009765629656612873, 1, 0.25),
           (360, 'Ratio 1', 1, 20, 2),
           (360, 'Attack 1', 0.009999999776482582, 2000, 150),
           (360, 'Release 1', 0.009999999776482582, 2000, 300),
           (360, 'Makeup 1', 1, 64, 2),
           (360, 'Knee 1', 1, 8, 2.828429937362671),
           (360, 'Detection 1', 0, 1, 0),
           (360, 'Bypass 1', 0, 1, 1),
           (360, 'Solo 1', 0, 1, 0),
           (360, 'Reduction 2', 0.00001584900019224733, 1, 0.061250001192092896),
           (360, 'Threshold 2', 0.0009765629656612873, 1, 0.25),
           (360, 'Ratio 2', 1, 20, 2),
           (360, 'Attack 2', 0.009999999776482582, 2000, 150),
           (360, 'Release 2', 0.009999999776482582, 2000, 300),
           (360, 'Makeup 2', 1, 64, 2),
           (360, 'Knee 2', 1, 8, 2.828429937362671),
           (360, 'Detection 2', 0, 1, 0),
           (360, 'Bypass 2', 0, 1, 1),
           (360, 'Solo 2', 0, 1, 0),
           (360, 'Reduction 3', 0.00001584900019224733, 1, 0.061250001192092896),
           (360, 'Threshold 3', 0.0009765629656612873, 1, 0.25),
           (360, 'Ratio 3', 1, 20, 2),
           (360, 'Attack 3', 0.009999999776482582, 2000, 150),
           (360, 'Release 3', 0.009999999776482582, 2000, 300),
           (360, 'Makeup 3', 1, 64, 2),
           (360, 'Knee 3', 1, 8, 2.828429937362671),
           (360, 'Detection 3', 0, 1, 0),
           (360, 'Bypass 3', 0, 1, 1),
           (360, 'Solo 3', 0, 1, 0),
           (360, 'Reduction 4', 0.00001584900019224733, 1, 0.061250001192092896),
           (360, 'Threshold 4', 0.0009765629656612873, 1, 0.25),
           (360, 'Ratio 4', 1, 20, 2),
           (360, 'Attack 4', 0.009999999776482582, 2000, 150),
           (360, 'Release 4', 0.009999999776482582, 2000, 300),
           (360, 'Makeup 4', 1, 64, 2),
           (360, 'Knee 4', 1, 8, 2.828429937362671),
           (360, 'Detection 4', 0, 1, 0),
           (360, 'Bypass 4', 0, 1, 1),
           (360, 'Solo 4', 0, 1, 0),
           (360, 'Notebook', 0, 3, 0),
           (361, 'Bypass', 0, 1, 0),
           (361, 'Input Gain', 0.015625, 64, 1),
           (361, 'Output Gain', 0.015625, 64, 1),
           (361, 'Split 1/2', 10, 20000, 120),
           (361, 'Split 2/3', 10, 20000, 1000),
           (361, 'Split 3/4', 10, 20000, 6000),
           (361, 'Filter Mode', 0, 1, 1),
           (361, 'Threshold 1', 0.0009765629656612873, 1, 0.25),
           (361, 'Ratio 1', 1, 20, 2),
           (361, 'Attack 1', 0.009999999776482582, 2000, 150),
           (361, 'Release 1', 0.009999999776482582, 2000, 300),
           (361, 'Makeup 1', 1, 64, 2),
           (361, 'Knee 1', 1, 8, 2.828429937362671),
           (361, 'Detection 1', 0, 1, 0),
           (361, 'Bypass 1', 0, 1, 1),
           (361, 'Solo 1', 0, 1, 0),
           (361, 'Threshold 2', 0.0009765629656612873, 1, 0.25),
           (361, 'Ratio 2', 1, 20, 2),
           (361, 'Attack 2', 0.009999999776482582, 2000, 150),
           (361, 'Release 2', 0.009999999776482582, 2000, 300),
           (361, 'Makeup 2', 1, 64, 2),
           (361, 'Knee 2', 1, 8, 2.828429937362671),
           (361, 'Detection 2', 0, 1, 0),
           (361, 'Bypass 2', 0, 1, 1),
           (361, 'Solo 2', 0, 1, 0),
           (361, 'Threshold 3', 0.0009765629656612873, 1, 0.25),
           (361, 'Ratio 3', 1, 20, 2),
           (361, 'Attack 3', 0.009999999776482582, 2000, 150),
           (361, 'Release 3', 0.009999999776482582, 2000, 300),
           (361, 'Makeup 3', 1, 64, 2),
           (361, 'Knee 3', 1, 8, 2.828429937362671),
           (361, 'Detection 3', 0, 1, 0),
           (361, 'Bypass 3', 0, 1, 1),
           (361, 'Solo 3', 0, 1, 0),
           (361, 'Threshold 4', 0.0009765629656612873, 1, 0.25),
           (361, 'Ratio 4', 1, 20, 2),
           (361, 'Attack 4', 0.009999999776482582, 2000, 150),
           (361, 'Release 4', 0.009999999776482582, 2000, 300),
           (361, 'Makeup 4', 1, 64, 2),
           (361, 'Knee 4', 1, 8, 2.828429937362671),
           (361, 'Detection 4', 0, 1, 0),
           (361, 'Bypass 4', 0, 1, 1),
           (361, 'Solo 4', 0, 1, 0),
           (361, 'Notebook', 0, 3, 0),
           (362, 'Min delay', 0.10000000149011612, 10, 5),
           (362, 'Mod depth', 0.10000000149011612, 10, 6),
           (362, 'Modulation rate', 0.009999999776482582, 20, 0.5),
           (362, 'Stereo phase', 0, 360, 180),
           (362, 'Voices', 1, 8, 4),
           (362, 'Inter-voice phase', 0, 360, 64),
           (362, 'Amount', 0, 4, 1),
           (362, 'Dry Amount', 0, 4, 0.5),
           (362, 'Center Frq 1', 10, 20000, 100),
           (362, 'Center Frq 2', 10, 20000, 5000),
           (362, 'Q', 0.125, 8, 0.125),
           (362, 'Overlap', 0, 1, 0.75),
           (363, 'Osc1 Wave', 0, 15, 0),
           (363, 'Osc2 Wave', 0, 15, 1),
           (363, 'Osc1 PW', -1, 1, 0),
           (363, 'Osc2 PW', -1, 1, 0),
           (363, 'O1<>2 Detune', 0, 100, 10),
           (363, 'Osc2 Transpose', -24, 24, 12),
           (363, 'Phase mode', 0, 5, 0),
           (363, 'O1<>2 Mix', 0, 1, 0.5),
           (363, 'Filter', 0, 7, 1),
           (363, 'Cutoff', 10, 16000, 33),
           (363, 'Resonance', 0.699999988079071, 8, 3),
           (363, 'Separation', -2400, 2400, 0),
           (363, 'Env->Cutoff', -10800, 10800, 8000),
           (363, 'Env->Res', 0, 1, 1),
           (363, 'Env->Amp', 0, 1, 0),
           (363, 'EG1 Attack', 1, 20000, 1),
           (363, 'EG1 Decay', 10, 20000, 350),
           (363, 'EG1 Sustain', 0, 1, 0.5),
           (363, 'EG1 Fade', -10000, 10000, 0),
           (363, 'EG1 Release', 10, 20000, 100),
           (363, 'Key Follow', 0, 2, 0),
           (363, 'Legato Mode', 0, 3, 0),
           (363, 'Portamento', 1, 2000, 1),
           (363, 'Vel->Filter', 0, 1, 0.5),
           (363, 'Vel->Amp', 0, 1, 0),
           (363, 'Volume', 0, 1, 0.5),
           (363, 'PBend Range', 0, 2400, 200),
           (363, 'LFO1 Rate', 0.009999999776482582, 20, 5),
           (363, 'LFO1 Delay', 0, 5, 0.5),
           (363, 'LFO1->Filter', -4800, 4800, 0),
           (363, 'LFO1->Pitch', 0, 1200, 100),
           (363, 'LFO1->PW', 0, 1, 0),
           (363, 'ModWheel->LFO1', 0, 1, 1),
           (363, 'Scale Detune', 0, 1, 1),
           (363, 'EG2->Cutoff', -10800, 10800, 0),
           (363, 'EG2->Res', 0, 1, 0.30000001192092896),
           (363, 'EG2->Amp', 0, 1, 1),
           (363, 'EG2 Attack', 1, 20000, 1),
           (363, 'EG2 Decay', 10, 20000, 100),
           (363, 'EG2 Sustain', 0, 1, 0.5),
           (363, 'EG2 Fade', -10000, 10000, 0),
           (363, 'Release', 10, 20000, 50),
           (363, 'Osc1 Stretch', 1, 16, 1),
           (363, 'Osc1 Window', 0, 1, 0),
           (363, 'LFO1 Trigger Mode', 0, 1, 0),
           (363, 'LFO2 Trigger Mode', 0, 1, 0),
           (363, 'LFO1 Rate', 0.009999999776482582, 20, 5),
           (363, 'LFO1 Delay', 0.10000000149011612, 5, 0.5),
           (363, 'Osc2 Unison', 0, 1, 0),
           (363, 'Osc2 Unison Detune', 0.009999999776482582, 20, 2),
           (363, 'Osc1 Transpose', -24, 24, 0),
           (364, 'Bypass', 0, 1, 0),
           (364, 'Input', 0.015625, 64, 1),
           (364, 'Output', 0.015625, 64, 1),
           (364, 'Balance', -1, 1, 0),
           (364, 'Softclip', 0, 1, 0),
           (364, 'Mute L', 0, 1, 0),
           (364, 'Mute R', 0, 1, 0),
           (364, 'Phase L', 0, 1, 0),
           (364, 'Phase R', 0, 1, 0),
           (364, 'Delay', -20, 20, 0),
           (364, 'Stereo Base', -1, 1, 0),
           (364, 'Stereo Phase', 0, 360, 0),
           (364, 'S/C Level', 1, 100, 1),
           (365, 'Bypass', 0, 1, 0),
           (365, 'Input', 0.015625, 64, 1),
           (365, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (365, 'Ratio', 1, 20, 2),
           (365, 'Attack', 0.009999999776482582, 2000, 20),
           (365, 'Release', 0.009999999776482582, 2000, 250),
           (365, 'Makeup Gain', 1, 64, 2),
           (365, 'Knee', 1, 8, 2.828429937362671),
           (365, 'Mix', 0, 1, 1),
           (366, 'Bypass', 0, 1, 0),
           (366, 'Input Gain', 0.015625, 64, 1),
           (366, 'Output Gain', 0.015625, 64, 1),
           (366, 'Limit', 0.0625, 1, 1),
           (366, 'Lookahead', 0.10000000149011612, 10, 5),
           (366, 'Release', 1, 1000, 50),
           (366, 'ASC', 0, 1, 1),
           (366, 'ASC Level', 0, 1, 0.5),
           (366, 'Oversampling', 1, 4, 1),
           (367, 'Bypass', 0, 1, 0),
           (367, 'Input Gain', 0.015625, 64, 1),
           (367, 'Output Gain', 0.015625, 64, 1),
           (367, 'Side Gain', 0.015625, 64, 1),
           (367, 'Middle source', 0, 4, 2),
           (367, 'Middle phase', 0, 1, 0),
           (367, 'Left Delay', 0, 10, 2.049999952316284),
           (367, 'Left Balance', -1, 1, 0),
           (367, 'Left Gain', 0.015625, 64, 1),
           (367, 'Left Phase', 0, 1, 0),
           (367, 'Right Delay', 0, 10, 2.119999885559082),
           (367, 'Right Balance', -1, 1, 0),
           (367, 'Right Gain', 0.015625, 64, 1),
           (367, 'Right Phase', 0, 1, 1),
           (368, 'Bypass', 0, 1, 0),
           (368, 'Input', 0.015625, 64, 1),
           (368, 'Max Gain Reduction', 0.00001584900019224733, 1, 0.061250001192092896),
           (368, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (368, 'Ratio', 1, 20, 2),
           (368, 'Attack', 0.009999999776482582, 2000, 20),
           (368, 'Release', 0.009999999776482582, 2000, 250),
           (368, 'Makeup Gain', 1, 64, 1),
           (368, 'Knee', 1, 8, 2.828429937362671),
           (368, 'Detection', 0, 1, 0),
           (368, 'Stereo Link', 0, 1, 0),
           (369, 'Min delay', 0.10000000149011612, 10, 0.10000000149011612),
           (369, 'Mod depth', 0.10000000149011612, 10, 1),
           (369, 'Mod rate', 0.009999999776482582, 20, 0.20000000298023224),
           (369, 'Feedback', -0.9900000095367432, 0.9900000095367432, 0.8999999761581421),
           (369, 'Stereo phase', 0, 360, 90),
           (369, 'Reset', 0, 1, 0),
           (369, 'Amount', 0, 4, 1),
           (369, 'Dry Amount', 0, 4, 1),
           (370, 'Transpose', -48, 48, 0),
           (370, 'Detune', -100, 100, 0),
           (370, 'Max. Resonance', 0.7070000171661377, 32, 32),
           (370, 'Mode', 0, 11, 6),
           (370, 'Portamento time', 1, 2000, 20),
           (371, 'Frequency', 10, 20000, 2000),
           (371, 'Resonance', 0.7070000171661377, 32, 0.7070000171661377),
           (371, 'Mode', 0, 11, 0),
           (371, 'Inertia', 5, 100, 20),
           (372, 'Bypass', 0, 1, 0),
           (372, 'Input', 0.015625, 64, 1),
           (372, 'Output', 0.015625, 64, 1),
           (372, 'Amount', 0, 64, 1),
           (372, 'Harmonics', 0.10000000149011612, 10, 8.5),
           (372, 'Blend harmonics', -10, 10, 0),
           (372, 'Scope', 2000, 12000, 7500),
           (372, 'Listen', 0, 1, 0),
           (372, 'Ceiling active', 0, 1, 0),
           (372, 'Ceiling', 10000, 20000, 16000),
           (373, 'Bypass', 0, 1, 0),
           (373, 'Input Gain', 0.015625, 64, 1),
           (373, 'Output Gain', 0.015625, 64, 1),
           (373, 'HP Active', 0, 5, 0),
           (373, 'HP Freq', 10, 20000, 30),
           (373, 'HP Mode', 0, 2, 1),
           (373, 'LP Active', 0, 5, 0),
           (373, 'LP Freq', 10, 20000, 18000),
           (373, 'LP Mode', 0, 2, 1),
           (373, 'LS Active', 0, 5, 0),
           (373, 'Level L', 0.015625, 64, 1),
           (373, 'Freq L', 10, 20000, 100),
           (373, 'HS Active', 0, 5, 0),
           (373, 'Level H', 0.015625, 64, 1),
           (373, 'Freq H', 10, 20000, 5000),
           (373, 'F1 Active', 0, 5, 0),
           (373, 'Level 1', 0.015625, 64, 1),
           (373, 'Freq 1', 10, 20000, 100),
           (373, 'Q 1', 0.10000000149011612, 100, 1),
           (373, 'F2 Active', 0, 5, 0),
           (373, 'Level 2', 0.015625, 64, 1),
           (373, 'Freq 2', 10, 20000, 500),
           (373, 'Q 2', 0.10000000149011612, 100, 1),
           (373, 'F3 Active', 0, 5, 0),
           (373, 'Level 3', 0.015625, 64, 1),
           (373, 'Freq 3', 10, 20000, 2000),
           (373, 'Q 3', 0.10000000149011612, 100, 1),
           (373, 'F4 Active', 0, 5, 0),
           (373, 'Level 4', 0.015625, 64, 1),
           (373, 'Freq 4', 10, 20000, 5000),
           (373, 'Q 4', 0.10000000149011612, 100, 1),
           (373, 'Individual Filters', 0, 1, 1),
           (373, 'Zoom', 0.0625, 1, 0.25),
           (373, 'Analyzer Active', 0, 1, 0),
           (373, 'Analyzer Mode', 0, 2, 1),
           (374, 'Bypass', 0, 1, 0),
           (374, 'Input Gain', 0.015625, 64, 1),
           (374, 'Output Gain', 0.015625, 64, 1),
           (374, 'LS Active', 0, 5, 0),
           (374, 'Level L', 0.015625, 64, 1),
           (374, 'Freq L', 10, 20000, 100),
           (374, 'HS Active', 0, 5, 0),
           (374, 'Level H', 0.015625, 64, 1),
           (374, 'Freq H', 10, 20000, 5000),
           (374, 'F1 Active', 0, 5, 0),
           (374, 'Level 1', 0.015625, 64, 1),
           (374, 'Freq 1', 10, 20000, 250),
           (374, 'Q 1', 0.10000000149011612, 100, 1),
           (374, 'F2 Active', 0, 5, 0),
           (374, 'Level 2', 0.015625, 64, 1),
           (374, 'Freq 2', 10, 20000, 1000),
           (374, 'Q 2', 0.10000000149011612, 100, 1),
           (374, 'F3 Active', 0, 5, 0),
           (374, 'Level 3', 0.015625, 64, 1),
           (374, 'Freq 3', 10, 20000, 4000),
           (374, 'Q 3', 0.10000000149011612, 100, 1),
           (374, 'Individual Filters', 0, 1, 1),
           (374, 'Zoom', 0.0625, 1, 0.25),
           (374, 'Analyzer Active', 0, 1, 0),
           (374, 'Analyzer Mode', 0, 2, 1),
           (375, 'In Level', 0.015625, 64, 1),
           (375, 'Bypass', 0, 1, 0),
           (375, 'Filters Type', 0, 2, 0),
           (375, 'Gain scale 1', 6, 30, 18),
           (375, 'Gain scale 2', 6, 30, 18),
           (375, 'Out Level', 0.015625, 64, 1),
           (376, 'Bypass', 0, 1, 0),
           (376, 'Input Gain', 0.015625, 64, 1),
           (376, 'Output Gain', 0.015625, 64, 1),
           (376, 'HP Active', 0, 5, 0),
           (376, 'HP Freq', 10, 20000, 30),
           (376, 'HP Mode', 0, 2, 1),
           (376, 'LP Active', 0, 5, 0),
           (376, 'LP Freq', 10, 20000, 18000),
           (376, 'LP Mode', 0, 2, 1),
           (376, 'LS Active', 0, 5, 0),
           (376, 'Level L', 0.015625, 64, 1),
           (376, 'Freq L', 10, 20000, 100),
           (376, 'HS Active', 0, 5, 0),
           (376, 'Level H', 0.015625, 64, 1),
           (376, 'Freq H', 10, 20000, 5000),
           (376, 'F1 Active', 0, 5, 0),
           (376, 'Level 1', 0.015625, 64, 1),
           (376, 'Freq 1', 10, 20000, 60),
           (376, 'Q 1', 0.10000000149011612, 100, 1),
           (376, 'F2 Active', 0, 5, 0),
           (376, 'Level 2', 0.015625, 64, 1),
           (376, 'Freq 2', 10, 20000, 120),
           (376, 'Q 2', 0.10000000149011612, 100, 1),
           (376, 'F3 Active', 0, 5, 0),
           (376, 'Level 3', 0.015625, 64, 1),
           (376, 'Freq 3', 10, 20000, 250),
           (376, 'Q 3', 0.10000000149011612, 100, 1),
           (376, 'F4 Active', 0, 5, 0),
           (376, 'Level 4', 0.015625, 64, 1),
           (376, 'Freq 4', 10, 20000, 500),
           (376, 'Q 4', 0.10000000149011612, 100, 1),
           (376, 'F5 Active', 0, 5, 0),
           (376, 'Level 5', 0.015625, 64, 1),
           (376, 'Freq 5', 10, 20000, 1000),
           (376, 'Q 5', 0.10000000149011612, 100, 1),
           (376, 'F6 Active', 0, 5, 0),
           (376, 'Level 6', 0.015625, 64, 1),
           (376, 'Freq 6', 10, 20000, 2000),
           (376, 'Q 6', 0.10000000149011612, 100, 1),
           (376, 'F7 Active', 0, 5, 0),
           (376, 'Level 7', 0.015625, 64, 1),
           (376, 'Freq 7', 10, 20000, 4000),
           (376, 'Q 7', 0.10000000149011612, 100, 1),
           (376, 'F8 Active', 0, 5, 0),
           (376, 'Level 8', 0.015625, 64, 1),
           (376, 'Freq 8', 10, 20000, 8000),
           (376, 'Q 8', 0.10000000149011612, 100, 1),
           (376, 'Individual Filters', 0, 1, 1),
           (376, 'Zoom', 0.0625, 1, 0.25),
           (376, 'Analyzer Active', 0, 1, 0),
           (376, 'Analyzer Mode', 0, 2, 1),
           (377, 'Bypass', 0, 1, 0),
           (377, 'Input Gain', 0.015625, 64, 1),
           (377, 'Output Gain', 0.015625, 64, 1),
           (377, 'Filter Mode', 0, 1, 0),
           (377, 'Filter Type', 0, 4, 4),
           (378, 'Bypass', 0, 1, 0),
           (378, 'Detection', 0, 1, 0),
           (378, 'Mode', 0, 1, 0),
           (378, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (378, 'Ratio', 1, 20, 3),
           (378, 'Laxity', 1, 100, 15),
           (378, 'Makeup', 1, 64, 1),
           (378, 'Split', 10, 18000, 6000),
           (378, 'Peak', 10, 18000, 4500),
           (378, 'Gain', 0.0625, 16, 1),
           (378, 'Level', 0.0625, 16, 4),
           (378, 'Peak Q', 0.10000000149011612, 100, 1),
           (378, 'S/C-Listen', 0, 1, 0),
           (379, 'Bypass', 0, 1, 0),
           (379, 'Input Gain', 0.015625, 64, 1),
           (379, 'Output Gain', 0.015625, 64, 1),
           (379, 'Bit Reduction', 1, 16, 4),
           (379, 'Morph', 0, 1, 0.5),
           (379, 'Mode', 0, 1, 0),
           (379, 'DC', 0.25, 4, 1),
           (379, 'Anti-Aliasing', 0, 1, 0.5),
           (379, 'Sample Reduction', 1, 250, 1),
           (379, 'LFO Active', 0, 1, 0),
           (379, 'LFO Depth', 1, 250, 20),
           (379, 'LFO Rate', 0.009999999776482582, 200, 0.30000001192092896),
           (380, 'Bypass', 0, 1, 0),
           (380, 'Input', 0.015625, 64, 1),
           (380, 'Threshold', 0.0009765629656612873, 1, 0.125),
           (380, 'Ratio', 1, 20, 2),
           (380, 'Attack', 0.009999999776482582, 2000, 20),
           (380, 'Release', 0.009999999776482582, 2000, 250),
           (380, 'Makeup Gain', 1, 64, 2),
           (380, 'Knee', 1, 8, 2.828429937362671),
           (380, 'Detection', 0, 1, 0),
           (380, 'Stereo Link', 0, 1, 0),
           (380, 'Mix', 0, 1, 1),
           (381, 'Distance (mm)', 0, 10, 0),
           (381, 'Distance (cm)', 0, 100, 0),
           (381, 'Distance (m)', 0, 100, 0),
           (381, 'Dry Amount', 0.00024414100334979594, 1, 0.00024414100334979594),
           (381, 'Wet Amount', 0.00024414100334979594, 1, 1),
           (381, 'Temperature °C', -50, 50, 20),
           (381, 'Bypass', 0, 1, 0),
           (382, 'Bypass', 0, 1, 0),
           (382, 'Input', 0.015625, 64, 1),
           (382, 'Output', 0.015625, 64, 1),
           (382, 'Amount', 0, 64, 1),
           (382, 'Harmonics', 0.10000000149011612, 10, 8.5),
           (382, 'Blend harmonics', -10, 10, 0),
           (382, 'Scope', 10, 250, 100),
           (382, 'Listen', 0, 1, 0),
           (382, 'Floor active', 0, 1, 0),
           (382, 'Floor', 10, 120, 20),
           (383, 'Slope', 0, 1, 0.5),
           (387, 'Frequency', 0, 64, 16),
           (388, 'Frequency', 0, 64, 16),
           (388, 'Pulse Width', 0, 1, 0.5),
           (389, 'Loop Steps', 1, 32, 32),
           (389, 'Reset on Gate Close', 0, 1, 0),
           (389, 'Closed Gate Value', 0, 1, 0),
           (389, 'Value 0', 0, 1, 0),
           (389, 'Value 1', 0, 1, 0),
           (389, 'Value 2', 0, 1, 0),
           (389, 'Value 3', 0, 1, 0),
           (389, 'Value 4', 0, 1, 0),
           (389, 'Value 5', 0, 1, 0),
           (389, 'Value 6', 0, 1, 0),
           (389, 'Value 7', 0, 1, 0),
           (389, 'Value 8', 0, 1, 0),
           (389, 'Value 9', 0, 1, 0),
           (389, 'Value 10', 0, 1, 0),
           (389, 'Value 11', 0, 1, 0),
           (389, 'Value 12', 0, 1, 0),
           (389, 'Value 13', 0, 1, 0),
           (389, 'Value 14', 0, 1, 0),
           (389, 'Value 15', 0, 1, 0),
           (389, 'Value 16', 0, 1, 0),
           (389, 'Value 17', 0, 1, 0),
           (389, 'Value 18', 0, 1, 0),
           (389, 'Value 19', 0, 1, 0),
           (389, 'Value 20', 0, 1, 0),
           (389, 'Value 21', 0, 1, 0),
           (389, 'Value 22', 0, 1, 0),
           (389, 'Value 23', 0, 1, 0),
           (389, 'Value 24', 0, 1, 0),
           (389, 'Value 25', 0, 1, 0),
           (389, 'Value 26', 0, 1, 0),
           (389, 'Value 27', 0, 1, 0),
           (389, 'Value 28', 0, 1, 0),
           (389, 'Value 29', 0, 1, 0),
           (389, 'Value 30', 0, 1, 0),
           (389, 'Value 31', 0, 1, 0),
           (389, 'Value 32', 0, 1, 0),
           (389, 'Value 33', 0, 1, 0),
           (389, 'Value 34', 0, 1, 0),
           (389, 'Value 35', 0, 1, 0),
           (389, 'Value 36', 0, 1, 0),
           (389, 'Value 37', 0, 1, 0),
           (389, 'Value 38', 0, 1, 0),
           (389, 'Value 39', 0, 1, 0),
           (389, 'Value 40', 0, 1, 0),
           (389, 'Value 41', 0, 1, 0),
           (389, 'Value 42', 0, 1, 0),
           (389, 'Value 43', 0, 1, 0),
           (389, 'Value 44', 0, 1, 0),
           (389, 'Value 45', 0, 1, 0),
           (389, 'Value 46', 0, 1, 0),
           (389, 'Value 47', 0, 1, 0),
           (389, 'Value 48', 0, 1, 0),
           (389, 'Value 49', 0, 1, 0),
           (389, 'Value 50', 0, 1, 0),
           (389, 'Value 51', 0, 1, 0),
           (389, 'Value 52', 0, 1, 0),
           (389, 'Value 53', 0, 1, 0),
           (389, 'Value 54', 0, 1, 0),
           (389, 'Value 55', 0, 1, 0),
           (389, 'Value 56', 0, 1, 0),
           (389, 'Value 57', 0, 1, 0),
           (389, 'Value 58', 0, 1, 0),
           (389, 'Value 59', 0, 1, 0),
           (389, 'Value 60', 0, 1, 0),
           (389, 'Value 61', 0, 1, 0),
           (389, 'Value 62', 0, 1, 0),
           (389, 'Value 63', 0, 1, 0),
           (390, 'Loop Steps', 1, 32, 32),
           (390, 'Reset on Gate Close', 0, 1, 0),
           (390, 'Closed Gate Value', 0, 1, 0),
           (390, 'Value 0', 0, 1, 0),
           (390, 'Value 1', 0, 1, 0),
           (390, 'Value 2', 0, 1, 0),
           (390, 'Value 3', 0, 1, 0),
           (390, 'Value 4', 0, 1, 0),
           (390, 'Value 5', 0, 1, 0),
           (390, 'Value 6', 0, 1, 0),
           (390, 'Value 7', 0, 1, 0),
           (390, 'Value 8', 0, 1, 0),
           (390, 'Value 9', 0, 1, 0),
           (390, 'Value 10', 0, 1, 0),
           (390, 'Value 11', 0, 1, 0),
           (390, 'Value 12', 0, 1, 0),
           (390, 'Value 13', 0, 1, 0),
           (390, 'Value 14', 0, 1, 0),
           (390, 'Value 15', 0, 1, 0),
           (390, 'Value 16', 0, 1, 0),
           (390, 'Value 17', 0, 1, 0),
           (390, 'Value 18', 0, 1, 0),
           (390, 'Value 19', 0, 1, 0),
           (390, 'Value 20', 0, 1, 0),
           (390, 'Value 21', 0, 1, 0),
           (390, 'Value 22', 0, 1, 0),
           (390, 'Value 23', 0, 1, 0),
           (390, 'Value 24', 0, 1, 0),
           (390, 'Value 25', 0, 1, 0),
           (390, 'Value 26', 0, 1, 0),
           (390, 'Value 27', 0, 1, 0),
           (390, 'Value 28', 0, 1, 0),
           (390, 'Value 29', 0, 1, 0),
           (390, 'Value 30', 0, 1, 0),
           (390, 'Value 31', 0, 1, 0),
           (391, 'Loop Steps', 1, 16, 16),
           (391, 'Reset on Gate Close', 0, 1, 0),
           (391, 'Closed Gate Value', 0, 1, 0),
           (391, 'Value 0', 0, 1, 0),
           (391, 'Value 1', 0, 1, 0),
           (391, 'Value 2', 0, 1, 0),
           (391, 'Value 3', 0, 1, 0),
           (391, 'Value 4', 0, 1, 0),
           (391, 'Value 5', 0, 1, 0),
           (391, 'Value 6', 0, 1, 0),
           (391, 'Value 7', 0, 1, 0),
           (391, 'Value 8', 0, 1, 0),
           (391, 'Value 9', 0, 1, 0),
           (391, 'Value 10', 0, 1, 0),
           (391, 'Value 11', 0, 1, 0),
           (391, 'Value 12', 0, 1, 0),
           (391, 'Value 13', 0, 1, 0),
           (391, 'Value 14', 0, 1, 0),
           (391, 'Value 15', 0, 1, 0),
           (392, 'Smoothness', 0, 1, 1),
           (393, 'Minimum', 0, 1, 0),
           (393, 'Maximum', 0, 1, 0),
           (393, 'Match Range', 0, 1, 0),
           (393, 'Mode', 0, 2, 0),
           (393, 'Steps', 1, 20, 20),
           (393, 'Value 0', 0, 1, 0),
           (393, 'Value 1', 0, 1, 0),
           (393, 'Value 2', 0, 1, 0),
           (393, 'Value 3', 0, 1, 0),
           (393, 'Value 4', 0, 1, 0),
           (393, 'Value 5', 0, 1, 0),
           (393, 'Value 6', 0, 1, 0),
           (393, 'Value 7', 0, 1, 0),
           (393, 'Value 8', 0, 1, 0),
           (393, 'Value 9', 0, 1, 0),
           (393, 'Value 10', 0, 1, 0),
           (393, 'Value 11', 0, 1, 0),
           (393, 'Value 12', 0, 1, 0),
           (393, 'Value 13', 0, 1, 0),
           (393, 'Value 14', 0, 1, 0),
           (393, 'Value 15', 0, 1, 0),
           (393, 'Value 16', 0, 1, 0),
           (393, 'Value 17', 0, 1, 0),
           (393, 'Value 18', 0, 1, 0),
           (393, 'Value 19', 0, 1, 0),
           (393, 'Value 20', 0, 1, 0),
           (393, 'Value 21', 0, 1, 0),
           (393, 'Value 22', 0, 1, 0),
           (393, 'Value 23', 0, 1, 0),
           (393, 'Value 24', 0, 1, 0),
           (393, 'Value 25', 0, 1, 0),
           (393, 'Value 26', 0, 1, 0),
           (393, 'Value 27', 0, 1, 0),
           (393, 'Value 28', 0, 1, 0),
           (393, 'Value 29', 0, 1, 0),
           (393, 'Value 30', 0, 1, 0),
           (393, 'Value 31', 0, 1, 0),
           (393, 'Value 32', 0, 1, 0),
           (393, 'Value 33', 0, 1, 0),
           (393, 'Value 34', 0, 1, 0),
           (393, 'Value 35', 0, 1, 0),
           (393, 'Value 36', 0, 1, 0),
           (393, 'Value 37', 0, 1, 0),
           (393, 'Value 38', 0, 1, 0),
           (393, 'Value 39', 0, 1, 0),
           (393, 'Value 40', 0, 1, 0),
           (393, 'Value 41', 0, 1, 0),
           (393, 'Value 42', 0, 1, 0),
           (393, 'Value 43', 0, 1, 0),
           (393, 'Value 44', 0, 1, 0),
           (393, 'Value 45', 0, 1, 0),
           (393, 'Value 46', 0, 1, 0),
           (393, 'Value 47', 0, 1, 0),
           (393, 'Value 48', 0, 1, 0),
           (393, 'Value 49', 0, 1, 0),
           (394, 'Minimum', 0, 1, 0),
           (394, 'Maximum', 0, 1, 0),
           (394, 'Match Range', 0, 1, 0),
           (394, 'Mode', 0, 2, 0),
           (394, 'Steps', 1, 20, 20),
           (394, 'Value 0', 0, 1, 0),
           (394, 'Value 1', 0, 1, 0),
           (394, 'Value 2', 0, 1, 0),
           (394, 'Value 3', 0, 1, 0),
           (394, 'Value 4', 0, 1, 0),
           (394, 'Value 5', 0, 1, 0),
           (394, 'Value 6', 0, 1, 0),
           (394, 'Value 7', 0, 1, 0),
           (394, 'Value 8', 0, 1, 0),
           (394, 'Value 9', 0, 1, 0),
           (394, 'Value 10', 0, 1, 0),
           (394, 'Value 11', 0, 1, 0),
           (394, 'Value 12', 0, 1, 0),
           (394, 'Value 13', 0, 1, 0),
           (394, 'Value 14', 0, 1, 0),
           (394, 'Value 15', 0, 1, 0),
           (394, 'Value 16', 0, 1, 0),
           (394, 'Value 17', 0, 1, 0),
           (394, 'Value 18', 0, 1, 0),
           (394, 'Value 19', 0, 1, 0),
           (395, 'Minimum', 0, 1, 0),
           (395, 'Maximum', 0, 1, 0),
           (395, 'Match Range', 0, 1, 0),
           (395, 'Mode', 0, 2, 0),
           (395, 'Steps', 1, 20, 20),
           (395, 'Value 0', 0, 1, 0),
           (395, 'Value 1', 0, 1, 0),
           (395, 'Value 2', 0, 1, 0),
           (395, 'Value 3', 0, 1, 0),
           (395, 'Value 4', 0, 1, 0),
           (395, 'Value 5', 0, 1, 0),
           (395, 'Value 6', 0, 1, 0),
           (395, 'Value 7', 0, 1, 0),
           (395, 'Value 8', 0, 1, 0),
           (395, 'Value 9', 0, 1, 0),
           (395, 'Value 10', 0, 1, 0),
           (395, 'Value 11', 0, 1, 0),
           (395, 'Value 12', 0, 1, 0),
           (395, 'Value 13', 0, 1, 0),
           (395, 'Value 14', 0, 1, 0),
           (395, 'Value 15', 0, 1, 0),
           (395, 'Value 16', 0, 1, 0),
           (395, 'Value 17', 0, 1, 0),
           (395, 'Value 18', 0, 1, 0),
           (395, 'Value 19', 0, 1, 0),
           (395, 'Value 20', 0, 1, 0),
           (395, 'Value 21', 0, 1, 0),
           (395, 'Value 22', 0, 1, 0),
           (395, 'Value 23', 0, 1, 0),
           (395, 'Value 24', 0, 1, 0),
           (395, 'Value 25', 0, 1, 0),
           (395, 'Value 26', 0, 1, 0),
           (395, 'Value 27', 0, 1, 0),
           (395, 'Value 28', 0, 1, 0),
           (395, 'Value 29', 0, 1, 0),
           (395, 'Value 30', 0, 1, 0),
           (395, 'Value 31', 0, 1, 0),
           (395, 'Value 32', 0, 1, 0),
           (395, 'Value 33', 0, 1, 0),
           (395, 'Value 34', 0, 1, 0),
           (395, 'Value 35', 0, 1, 0),
           (395, 'Value 36', 0, 1, 0),
           (395, 'Value 37', 0, 1, 0),
           (395, 'Value 38', 0, 1, 0),
           (395, 'Value 39', 0, 1, 0),
           (395, 'Value 40', 0, 1, 0),
           (395, 'Value 41', 0, 1, 0),
           (395, 'Value 42', 0, 1, 0),
           (395, 'Value 43', 0, 1, 0),
           (395, 'Value 44', 0, 1, 0),
           (395, 'Value 45', 0, 1, 0),
           (395, 'Value 46', 0, 1, 0),
           (395, 'Value 47', 0, 1, 0),
           (395, 'Value 48', 0, 1, 0),
           (395, 'Value 49', 0, 1, 0),
           (395, 'Value 50', 0, 1, 0),
           (395, 'Value 51', 0, 1, 0),
           (395, 'Value 52', 0, 1, 0),
           (395, 'Value 53', 0, 1, 0),
           (395, 'Value 54', 0, 1, 0),
           (395, 'Value 55', 0, 1, 0),
           (395, 'Value 56', 0, 1, 0),
           (395, 'Value 57', 0, 1, 0),
           (395, 'Value 58', 0, 1, 0),
           (395, 'Value 59', 0, 1, 0),
           (395, 'Value 60', 0, 1, 0),
           (395, 'Value 61', 0, 1, 0),
           (395, 'Value 62', 0, 1, 0),
           (395, 'Value 63', 0, 1, 0),
           (395, 'Value 64', 0, 1, 0),
           (395, 'Value 65', 0, 1, 0),
           (395, 'Value 66', 0, 1, 0),
           (395, 'Value 67', 0, 1, 0),
           (395, 'Value 68', 0, 1, 0),
           (395, 'Value 69', 0, 1, 0),
           (395, 'Value 70', 0, 1, 0),
           (395, 'Value 71', 0, 1, 0),
           (395, 'Value 72', 0, 1, 0),
           (395, 'Value 73', 0, 1, 0),
           (395, 'Value 74', 0, 1, 0),
           (395, 'Value 75', 0, 1, 0),
           (395, 'Value 76', 0, 1, 0),
           (395, 'Value 77', 0, 1, 0),
           (395, 'Value 78', 0, 1, 0),
           (395, 'Value 79', 0, 1, 0),
           (395, 'Value 80', 0, 1, 0),
           (395, 'Value 81', 0, 1, 0),
           (395, 'Value 82', 0, 1, 0),
           (395, 'Value 83', 0, 1, 0),
           (395, 'Value 84', 0, 1, 0),
           (395, 'Value 85', 0, 1, 0),
           (395, 'Value 86', 0, 1, 0),
           (395, 'Value 87', 0, 1, 0),
           (395, 'Value 88', 0, 1, 0),
           (395, 'Value 89', 0, 1, 0),
           (395, 'Value 90', 0, 1, 0),
           (395, 'Value 91', 0, 1, 0),
           (395, 'Value 92', 0, 1, 0),
           (395, 'Value 93', 0, 1, 0),
           (395, 'Value 94', 0, 1, 0),
           (395, 'Value 95', 0, 1, 0),
           (395, 'Value 96', 0, 1, 0),
           (395, 'Value 97', 0, 1, 0),
           (395, 'Value 98', 0, 1, 0),
           (395, 'Value 99', 0, 1, 0),
           (396, 'Pulse Width', 0, 1, 0.5),
           (397, 'Cutoff Frequency', 0.000009999999747378752, 0.5, 0.5),
           (397, 'Resonance', 0, 4, 0),
           (398, 'Control Input', 0, 1, 0),
           (399, 'Delay Time', 0, 1, 0),
           (399, 'Attack Time', 0, 1, 0),
           (399, 'Hold Time', 0, 1, 0),
           (399, 'Decay Time', 0, 1, 0),
           (399, 'Sustain Level', 0, 1, 1),
           (399, 'Release Time', 0, 1, 0),
           (400, 'Gain', -96, 96, -96),
           (401, 'Attack Time', 0, 1, 0),
           (401, 'Decay Time', 0, 1, 0),
           (401, 'Sustain Level', 0, 1, 1),
           (401, 'Release Time', 0, 1, 0),
           (402, 'Trigger Threshold', 0, 1, 0),
           (402, 'Attack Time', 0, 1, 0),
           (402, 'Decay Time', 0, 1, 0),
           (402, 'Sustain Level', 0, 1, 1),
           (402, 'Release Time', 0, 1, 0),
           (403, 'Time', 0, 1, 0.5),
           (403, 'Damping', 0, 1, 0.5),
           (403, 'Dry Wet Mix', 0, 1, 0.5),
           (404, 'Gain', 0, 1, 0.5),
           (404, 'Low Gain', 0, 1, 0.5),
           (404, 'LoMid Gain', 0, 1, 0.5),
           (404, 'HiMid Gain', 0, 1, 0.5),
           (404, 'High Gain', 0, 1, 0.5),
           (404, 'Active', 0, 1, 1),
           (405, 'Frequency Control', 0, 1, 0.5),
           (405, 'Active', 0, 1, 1),
           (406, 'Freq', 0, 1, 0.5),
           (406, 'Mix', 0, 1, 0.5),
           (407, 'Width', 0, 1, 0.5),
           (407, 'Invert', 0, 1, 0),
           (407, 'Active', 0, 1, 1),
           (408, 'Distort', 0, 1, 0),
           (408, 'Tone', 0, 1, 0),
           (408, 'Active', 0, 1, 1),
           (409, 'Factor', 0, 1, 0),
           (409, 'Threshold', 0, 1, 0.5),
           (409, 'Attack', 0, 1, 0.5),
           (409, 'Release', 0, 1, 0.25),
           (409, 'Active', 0, 1, 1),
           (410, 'Time', 0, 1, 0.5),
           (410, 'Amplitude', 0, 1, 1),
           (410, 'Dry Wet Mix', 0, 1, 1),
           (410, 'Active', 0, 1, 1),
           (411, 'Threshold', 0, 1, 0.25),
           (411, 'Reduction', 0, 1, 1),
           (411, 'Release Time', 0, 1, 0.5),
           (412, 'Tone', 0, 6, 0),
           (412, 'Distortion', 0, 1, 0),
           (413, 'Time', 0, 1, 0.5),
           (413, 'Volume', 0, 1, 0.5),
           (413, 'Feedback', 0, 1, 0.25),
           (413, 'Active', 0, 1, 1),
           (414, 'Crush', 0, 1, 0.25),
           (414, 'Dry/Wet', 0, 1, 1),
           (414, 'Active', 0, 1, 1),
           (415, 'Amp Attack', 0, 2.5, 0),
           (415, 'Amp Decay', 0, 2.5, 0),
           (415, 'Amp Sustain', 0, 1, 0.4099999964237213),
           (415, 'Amp Release', 0, 2.5, 0),
           (415, 'Osc1 Waveform', 0, 4, 2),
           (415, 'Filter Attack', 0, 2.5, 0),
           (415, 'Filter Decay', 0, 2.5, 0),
           (415, 'Filter Sustain', 0, 1, 1),
           (415, 'Filter Release', 0, 2.5, 0),
           (415, 'Filter Resonance', 0, 0.9700000286102295, 0),
           (415, 'Filter Env Amount', -16, 16, 0),
           (415, 'Filter Cutoff', -0.5, 1.5, 1.5),
           (415, 'Osc2 Detune', -1, 1, 0),
           (415, 'Osc2 Waveform', 0, 4, 2),
           (415, 'Master Vol', 0, 1, 0.6700000166893005),
           (415, 'LFO Freq', 0, 7.5, 0),
           (415, 'LFO Waveform', 0, 6, 0),
           (415, 'Osc2 Range', -1, 2, 0),
           (415, 'Osc Mix', -1, 1, 0),
           (415, 'Freq Mod Amount', 0, 1.2599209547042847, 0),
           (415, 'Filter Mod Amount', -1, 1, -1),
           (415, 'Amp Mod Amount', -1, 1, -1),
           (415, 'Ring Mod', 0, 1, 0),
           (415, 'Osc1 Pulsewidth', 0, 1, 1),
           (415, 'Osc2 Pulsewidth', 0, 1, 1),
           (415, 'Reverb Roomsize', 0, 1, 0),
           (415, 'Reverb Damp', 0, 1, 0),
           (415, 'Reverb Wet', 0, 1, 0),
           (415, 'Reverb Width', 0, 1, 1),
           (415, 'Distortion Crunch', 0, 0.8999999761581421, 0),
           (415, 'Osc2 Sync', 0, 1, 0),
           (415, 'Portamento Time', 0, 1, 0),
           (415, 'Keyboard Mode', 0, 2, 0),
           (415, 'Osc2 Pitch', -12, 12, 0),
           (415, 'Filter Type', 0, 2, 0),
           (415, 'Filter Slope', 0, 1, 1),
           (415, 'Freq Mod to Oscillator', 0, 2, 0),
           (415, 'Filter Key Track', 0, 1, 1),
           (415, 'Filter Velocity Track', 0, 1, 1),
           (415, 'Amp Velocity Amount', 0, 1, 1),
           (415, 'Portamento Mode', 0, 1, 0),
           (416, 'Switch', 0, 1, 0),
           (416, 'Threshold', -70, 12, -70),
           (416, 'Attack', 0.10000000149011612, 500, 30),
           (416, 'Hold', 5, 3000, 500),
           (416, 'Decay', 5, 4000, 1000),
           (416, 'Range', -90, -20, -90),
           (417, 'Time', 0, 127, 63),
           (417, 'Delay', 0, 127, 24),
           (417, 'Feedback', 0, 127, 0),
           (417, 'bw (unused)', 0, 127, 0),
           (417, 'E/R (unused)', 0, 127, 0),
           (417, 'Low-Pass Filter', 0, 127, 85),
           (417, 'High-Pass Filter', 0, 127, 5),
           (417, 'Damp', 64, 127, 83),
           (417, 'Type', 0, 2, 1),
           (417, 'Room size', 1, 127, 64),
           (417, 'Bandwidth', 0, 127, 20),
           (418, 'LFO Frequency', 0, 127, 36),
           (418, 'LFO Randomness', 0, 127, 0),
           (418, 'LFO Type', 0, 1, 0),
           (418, 'LFO Stereo', 0, 127, 64),
           (418, 'Depth', 0, 127, 110),
           (418, 'Feedback', 0, 127, 64),
           (418, 'Stages', 1, 12, 1),
           (418, 'L/R Cross|Offset', 0, 127, 0),
           (418, 'Subtract Output', 0, 1, 0),
           (418, 'Phase|Width', 0, 127, 20),
           (418, 'Hyper', 0, 1, 0),
           (418, 'Distortion', 0, 127, 0),
           (418, 'Analog', 0, 1, 0),
           (419, 'Delay', 0, 127, 35),
           (419, 'L/R Delay', 0, 127, 64),
           (419, 'L/R Cross', 0, 127, 30),
           (419, 'Feedback', 0, 127, 59),
           (419, 'High Damp', 0, 127, 0),
           (420, 'LFO Frequency', 0, 127, 80),
           (420, 'LFO Randomness', 0, 127, 0),
           (420, 'LFO Type', 0, 1, 0),
           (420, 'LFO Stereo', 0, 127, 64),
           (420, 'LFO Depth', 0, 127, 0),
           (420, 'Amp sns', 0, 127, 90),
           (420, 'Amp sns inv', 0, 1, 0),
           (420, 'Amp Smooth', 0, 127, 60),
           (421, 'L/R Cross', 0, 127, 35),
           (421, 'Drive', 0, 127, 56),
           (421, 'Level', 0, 127, 70),
           (421, 'Type', 0, 13, 0),
           (421, 'Negate', 0, 1, 0),
           (421, 'Low-Pass Filter', 0, 127, 96),
           (421, 'High-Pass Filter', 0, 127, 0),
           (421, 'Stereo', 0, 1, 0),
           (421, 'Pre-Filtering', 0, 1, 0),
           (422, 'LFO Frequency', 0, 127, 50),
           (422, 'LFO Randomness', 0, 127, 0),
           (422, 'LFO Type', 0, 1, 0),
           (422, 'LFO Stereo', 0, 127, 90),
           (422, 'Depth', 0, 127, 40),
           (422, 'Delay', 0, 127, 85),
           (422, 'Feedback', 0, 127, 64),
           (422, 'L/R Cross', 0, 127, 119),
           (422, 'Flange Mode', 0, 1, 0),
           (422, 'Subtract Output', 0, 1, 0),
           (423, 'LFO Frequency', 0, 127, 70),
           (423, 'LFO Randomness', 0, 127, 0),
           (423, 'LFO Type', 0, 1, 0),
           (423, 'LFO Stereo', 0, 127, 62),
           (423, 'Depth', 0, 127, 60),
           (423, 'Feedback', 0, 127, 105),
           (423, 'Delay', 1, 100, 25),
           (423, 'L/R Cross', 0, 127, 0),
           (423, 'Phase', 0, 127, 64);

 INSERT INTO efeito.plug_entrada (id_efeito, nome) 
      VALUES 
           (3, 'Audio Input 1'),
           (3, 'Audio Input 2'),
           (4, 'Audio Input 1'),
           (5, 'Audio Input 1'),
           (6, 'Audio Input 1'),
           (6, 'Audio Input 2'),
           (7, 'Audio Input 1'),
           (8, 'Audio Input 1'),
           (8, 'Audio Input 2'),
           (9, 'Audio Input 1'),
           (10, 'Audio Input 1'),
           (11, 'Audio Input 1'),
           (12, 'Audio Input 1'),
           (12, 'Audio Input 2'),
           (13, 'Audio Input 1'),
           (14, 'Audio Input 1'),
           (14, 'Audio Input 2'),
           (15, 'Audio Input 1'),
           (16, 'In A Left'),
           (16, 'In A Right'),
           (16, 'In B Left'),
           (16, 'In B Right'),
           (17, 'In'),
           (45, 'InL'),
           (45, 'InR'),
           (46, 'In'),
           (47, 'In'),
           (48, 'In Left'),
           (48, 'In Right'),
           (50, 'Input'),
           (51, 'Input'),
           (52, 'Input_0'),
           (53, 'Input'),
           (54, 'Input L'),
           (54, 'Input R'),
           (55, 'Input Left'),
           (55, 'Input Right'),
           (56, 'Input'),
           (57, 'Input'),
           (58, 'Input'),
           (59, 'Input'),
           (60, 'Input'),
           (61, 'Input'),
           (62, 'Input Left'),
           (62, 'Input Right'),
           (63, 'Input Left'),
           (63, 'Input Right'),
           (64, 'Input'),
           (65, 'Input_L'),
           (65, 'Input_R'),
           (66, 'Input'),
           (67, 'Input L'),
           (67, 'Input R'),
           (68, 'Input L'),
           (68, 'Input R'),
           (69, 'Input'),
           (70, 'Audio Input 1'),
           (71, 'Audio Input 1'),
           (72, 'Audio Input 1'),
           (73, 'Audio Input 1'),
           (74, 'Input'),
           (75, 'Input'),
           (77, 'In'),
           (78, 'In'),
           (79, 'Audio In L'),
           (79, 'Audio In R'),
           (80, 'Audio In L'),
           (80, 'Audio In R'),
           (81, 'Audio In L'),
           (81, 'Audio In R'),
           (82, 'Audio In L'),
           (82, 'Audio In R'),
           (83, 'Audio In L'),
           (83, 'Audio In R'),
           (84, 'Audio In L'),
           (84, 'Audio In R'),
           (85, 'Audio In L'),
           (85, 'Audio In R'),
           (86, 'Audio In L'),
           (86, 'Audio In R'),
           (87, 'Audio In L'),
           (87, 'Audio In R'),
           (88, 'Audio In L'),
           (88, 'Audio In R'),
           (89, 'Audio In L'),
           (89, 'Audio In R'),
           (90, 'Audio In L'),
           (90, 'Audio In R'),
           (91, 'Audio In L'),
           (91, 'Audio In R'),
           (92, 'Audio In L'),
           (92, 'Audio In R'),
           (93, 'Audio In L'),
           (93, 'Audio In R'),
           (94, 'Audio In L'),
           (94, 'Audio In R'),
           (95, 'Audio In L'),
           (95, 'Audio In R'),
           (95, 'Auxiliary Input'),
           (96, 'Audio In L'),
           (96, 'Audio In R'),
           (97, 'Audio In L'),
           (97, 'Audio In R'),
           (98, 'Audio In L'),
           (98, 'Audio In R'),
           (99, 'Audio In L'),
           (99, 'Audio In R'),
           (100, 'Audio In L'),
           (100, 'Audio In R'),
           (101, 'Audio In L'),
           (101, 'Audio In R'),
           (102, 'Audio In L'),
           (102, 'Audio In R'),
           (103, 'Audio In L'),
           (103, 'Audio In R'),
           (104, 'Audio In L'),
           (104, 'Audio In R'),
           (105, 'Audio In L'),
           (105, 'Audio In R'),
           (106, 'Audio In L'),
           (106, 'Audio In R'),
           (107, 'Audio In L'),
           (107, 'Audio In R'),
           (108, 'Audio In L'),
           (108, 'Audio In R'),
           (109, 'Audio In L'),
           (109, 'Audio In R'),
           (110, 'Audio In L'),
           (110, 'Audio In R'),
           (111, 'Audio In L'),
           (111, 'Audio In R'),
           (112, 'Audio In L'),
           (112, 'Audio In R'),
           (113, 'Audio In L'),
           (113, 'Audio In R'),
           (114, 'Audio In L'),
           (114, 'Audio In R'),
           (115, 'Audio In L'),
           (115, 'Audio In R'),
           (116, 'Audio In L'),
           (116, 'Audio In R'),
           (117, 'Audio In L'),
           (117, 'Audio In R'),
           (118, 'Audio In L'),
           (118, 'Audio In R'),
           (119, 'Audio In L'),
           (119, 'Audio In R'),
           (120, 'Audio In L'),
           (120, 'Audio In R'),
           (121, 'In'),
           (122, 'In'),
           (123, 'In'),
           (124, 'In'),
           (125, 'In'),
           (126, 'In 1'),
           (126, 'In 2'),
           (127, 'In'),
           (128, 'In'),
           (129, 'In'),
           (130, 'In'),
           (131, 'In'),
           (132, 'In'),
           (133, 'In'),
           (134, 'In'),
           (135, 'In'),
           (136, 'In'),
           (137, 'In'),
           (138, 'In'),
           (139, 'Left In'),
           (139, 'Right In'),
           (140, 'Left In'),
           (140, 'Right In'),
           (141, 'Left In'),
           (141, 'Right In'),
           (142, 'Left In'),
           (142, 'Right In'),
           (143, 'Left In'),
           (143, 'Right In'),
           (144, 'Left In'),
           (144, 'Right In'),
           (145, 'Left In'),
           (145, 'Right In'),
           (146, 'Left In'),
           (146, 'Right In'),
           (147, 'Left In'),
           (147, 'Right In'),
           (148, 'Left In'),
           (148, 'Right In'),
           (149, 'Left In'),
           (149, 'Right In'),
           (150, 'Left In'),
           (150, 'Right In'),
           (151, 'Left In'),
           (151, 'Right In'),
           (152, 'Left In'),
           (152, 'Right In'),
           (153, 'Left In'),
           (153, 'Right In'),
           (155, 'Left In'),
           (155, 'Right In'),
           (156, 'Left In'),
           (156, 'Right In'),
           (157, 'Left In'),
           (157, 'Right In'),
           (158, 'Left In'),
           (158, 'Right In'),
           (159, 'Left In'),
           (159, 'Right In'),
           (161, 'Left In'),
           (161, 'Right In'),
           (163, 'Left In'),
           (163, 'Right In'),
           (165, 'Left In'),
           (165, 'Right In'),
           (166, 'Left In'),
           (166, 'Right In'),
           (167, 'Left In'),
           (167, 'Right In'),
           (168, 'Left In'),
           (168, 'Right In'),
           (169, 'Left In'),
           (169, 'Right In'),
           (170, 'Left In'),
           (170, 'Right In'),
           (171, 'Left In'),
           (171, 'Right In'),
           (172, 'Left In'),
           (172, 'Right In'),
           (173, 'Left In'),
           (173, 'Right In'),
           (174, 'Left In'),
           (174, 'Right In'),
           (175, 'In'),
           (176, 'In'),
           (177, 'In L'),
           (177, 'In R'),
           (178, 'InL'),
           (178, 'In R'),
           (179, 'In'),
           (180, 'In L'),
           (180, 'In R'),
           (181, 'In'),
           (182, 'L In'),
           (182, 'R In'),
           (183, 'In'),
           (185, 'L In'),
           (185, 'R In'),
           (186, 'L In'),
           (186, 'R In'),
           (187, 'In'),
           (188, 'L In'),
           (188, 'R In'),
           (189, 'In'),
           (190, 'L In'),
           (190, 'R In'),
           (191, 'In'),
           (192, 'In L'),
           (192, 'In R'),
           (193, 'In'),
           (194, 'In'),
           (195, 'in'),
           (196, 'In'),
           (197, 'In'),
           (198, 'In'),
           (199, 'in'),
           (200, 'in'),
           (201, 'In'),
           (202, 'In'),
           (203, 'In'),
           (204, 'In'),
           (205, 'in'),
           (206, 'in'),
           (207, 'In'),
           (207, 'In1'),
           (208, 'In'),
           (209, 'In'),
           (210, 'In'),
           (211, 'In'),
           (211, 'In1'),
           (212, 'In'),
           (213, 'In'),
           (213, 'In1'),
           (214, 'In'),
           (215, 'In'),
           (216, 'In'),
           (216, 'In1'),
           (217, 'in'),
           (218, 'in'),
           (219, 'in'),
           (220, 'In'),
           (221, 'In'),
           (222, 'In'),
           (223, 'In'),
           (224, 'In'),
           (225, 'In'),
           (226, 'In'),
           (227, 'In'),
           (228, 'In'),
           (229, 'In'),
           (230, 'In'),
           (231, 'In'),
           (231, 'In1'),
           (232, 'In'),
           (233, 'In'),
           (234, 'In'),
           (235, 'In'),
           (236, 'In'),
           (237, 'In'),
           (238, 'In'),
           (239, 'In'),
           (240, 'In'),
           (241, 'In'),
           (242, 'In'),
           (243, 'In'),
           (244, 'In'),
           (244, 'In1'),
           (245, 'In'),
           (245, 'In1'),
           (246, 'In'),
           (247, 'In'),
           (247, 'In1'),
           (248, 'In'),
           (249, 'In'),
           (250, 'In'),
           (250, 'In1'),
           (251, 'In'),
           (252, 'In'),
           (253, 'In'),
           (254, 'In'),
           (254, 'In1'),
           (255, 'in'),
           (256, 'In'),
           (257, 'In'),
           (257, 'In1'),
           (258, 'in'),
           (259, 'in0'),
           (259, 'in1'),
           (260, 'in0'),
           (260, 'in1'),
           (261, 'in0'),
           (261, 'in1'),
           (262, 'in0'),
           (263, 'Input'),
           (264, 'In L'),
           (264, 'In R'),
           (265, 'Input'),
           (266, 'Input'),
           (267, 'Input'),
           (268, 'Input'),
           (270, 'In L'),
           (270, 'In R'),
           (273, 'Input'),
           (274, 'Input'),
           (275, 'Input'),
           (276, 'Input'),
           (277, 'Input'),
           (278, 'Input'),
           (279, 'Input'),
           (298, 'Input Left'),
           (298, 'Input Right'),
           (299, 'Audio Input 1'),
           (299, 'Audio Input 2'),
           (300, 'Audio Input 1'),
           (300, 'Audio Input 2'),
           (302, 'Audio Input 1'),
           (302, 'Audio Input 2'),
           (303, 'Audio Input 1'),
           (304, 'Audio Input 1'),
           (304, 'Audio Input 2'),
           (305, 'Audio Input 1'),
           (306, 'Audio Input 1'),
           (308, 'Audio Input 1'),
           (309, 'Input Left (Amp Env)'),
           (309, 'Input Right (Amp Env)'),
           (309, 'Input Left (Audio)'),
           (309, 'Input Right (Audio)'),
           (310, 'Audio Input 1'),
           (310, 'Audio Input 2'),
           (311, 'Audio Input 1'),
           (311, 'Audio Input 2'),
           (312, 'In'),
           (314, 'In'),
           (315, 'In Left'),
           (315, 'In Right'),
           (316, 'In'),
           (318, 'In'),
           (319, 'In'),
           (320, 'In Left'),
           (320, 'In Right'),
           (321, 'In'),
           (322, 'In'),
           (323, 'In'),
           (324, 'In Left'),
           (324, 'In Right'),
           (326, 'In'),
           (327, 'In'),
           (328, 'In Left'),
           (328, 'In Right'),
           (329, 'In'),
           (330, 'In Left'),
           (330, 'In Right'),
           (331, 'In'),
           (333, 'In'),
           (335, 'In'),
           (336, 'In'),
           (337, 'In'),
           (338, 'In'),
           (339, 'In L'),
           (339, 'In R'),
           (339, 'Sidechain'),
           (339, 'Sidechain 2'),
           (340, 'In L'),
           (340, 'In R'),
           (341, 'In L'),
           (341, 'In R'),
           (342, 'In L'),
           (342, 'In R'),
           (343, 'In L'),
           (343, 'In R'),
           (343, 'Sidechain'),
           (343, 'Sidechain 2'),
           (344, 'In L'),
           (344, 'In R'),
           (345, 'In L'),
           (345, 'In R'),
           (346, 'In L'),
           (346, 'In R'),
           (347, 'In L'),
           (347, 'In R'),
           (348, 'In L'),
           (348, 'In R'),
           (348, 'Sidechain'),
           (348, 'Sidechain 2'),
           (349, 'In L'),
           (349, 'In R'),
           (349, 'Sidechain'),
           (349, 'Sidechain 2'),
           (350, 'In L'),
           (350, 'In R'),
           (350, 'Sidechain'),
           (350, 'Sidechain 2'),
           (351, 'In L'),
           (351, 'In R'),
           (352, 'In L'),
           (352, 'In R'),
           (353, 'In L'),
           (353, 'In R'),
           (354, 'In L'),
           (354, 'In R'),
           (355, 'In L'),
           (355, 'In R'),
           (356, 'In L'),
           (356, 'In R'),
           (357, 'In L'),
           (357, 'In R'),
           (359, 'In L'),
           (359, 'In R'),
           (360, 'In L'),
           (360, 'In R'),
           (361, 'In L'),
           (361, 'In R'),
           (362, 'In L'),
           (362, 'In R'),
           (364, 'In L'),
           (365, 'In L'),
           (366, 'In L'),
           (366, 'In R'),
           (367, 'In L'),
           (367, 'In R'),
           (368, 'In L'),
           (368, 'In R'),
           (369, 'In L'),
           (369, 'In R'),
           (370, 'In L'),
           (370, 'In R'),
           (371, 'In L'),
           (371, 'In R'),
           (372, 'In L'),
           (372, 'In R'),
           (373, 'In L'),
           (373, 'In R'),
           (374, 'In L'),
           (374, 'In R'),
           (375, 'In L'),
           (375, 'In R'),
           (376, 'In L'),
           (376, 'In R'),
           (377, 'In L'),
           (377, 'In R'),
           (378, 'In L'),
           (378, 'In R'),
           (379, 'In L'),
           (379, 'In R'),
           (380, 'In L'),
           (380, 'In R'),
           (381, 'In L'),
           (381, 'In R'),
           (382, 'In L'),
           (382, 'In R'),
           (386, 'Input'),
           (397, 'Input'),
           (400, 'Input'),
           (403, 'In Left'),
           (403, 'In Right'),
           (404, 'Audio Input'),
           (405, 'In Left'),
           (405, 'In Right'),
           (406, 'Audio Input L'),
           (407, 'Audio Input L'),
           (407, 'Audio Input R'),
           (408, 'Audio Input'),
           (409, 'Audio Input'),
           (410, 'In Left'),
           (410, 'In Right'),
           (411, 'In Left'),
           (411, 'In Right'),
           (411, 'Sidechain Input'),
           (412, 'Audio Input'),
           (413, 'Audio Input'),
           (414, 'Audio Input'),
           (416, 'Input'),
           (417, 'Audio Input 1'),
           (417, 'Audio Input 2'),
           (418, 'Audio Input 1'),
           (418, 'Audio Input 2'),
           (419, 'Audio Input 1'),
           (419, 'Audio Input 2'),
           (420, 'Audio Input 1'),
           (420, 'Audio Input 2'),
           (421, 'Audio Input 1'),
           (421, 'Audio Input 2'),
           (422, 'Audio Input 1'),
           (422, 'Audio Input 2'),
           (423, 'Audio Input 1'),
           (423, 'Audio Input 2');

 INSERT INTO efeito.plug_saida (id_efeito, nome) 
      VALUES 
           (3, 'Audio Output 1'),
           (3, 'Audio Output 2'),
           (4, 'Audio Output 1'),
           (5, 'Audio Output 1'),
           (6, 'Audio Output 1'),
           (6, 'Audio Output 2'),
           (7, 'Audio Output 1'),
           (8, 'Audio Output 1'),
           (8, 'Audio Output 2'),
           (9, 'Audio Output 1'),
           (10, 'Audio Output 1'),
           (11, 'Audio Output 1'),
           (12, 'Audio Output 1'),
           (12, 'Audio Output 2'),
           (13, 'Audio Output 1'),
           (14, 'Audio Output 1'),
           (14, 'Audio Output 2'),
           (15, 'Audio Output 1'),
           (16, 'Out Left'),
           (16, 'Out Right'),
           (17, 'Out'),
           (45, 'OutL'),
           (45, 'OutR'),
           (46, 'OutL'),
           (46, 'OutR'),
           (47, 'Out'),
           (48, 'Out Left'),
           (48, 'Out Right'),
           (49, 'Master Out left'),
           (49, 'Master Out right'),
           (50, 'Output'),
           (51, 'Output'),
           (52, 'Output_0'),
           (53, 'Output'),
           (54, 'Output L'),
           (54, 'Output R'),
           (55, 'Output Left'),
           (55, 'Output Right'),
           (56, 'Output'),
           (57, 'Output'),
           (58, 'Output'),
           (59, 'Output'),
           (60, 'Output'),
           (61, 'Output'),
           (62, 'Output Left'),
           (62, 'Output Right'),
           (63, 'Output Left'),
           (63, 'Output Right'),
           (64, 'Output'),
           (65, 'Output_L'),
           (65, 'Output_R'),
           (66, 'Output'),
           (67, 'Output L'),
           (67, 'Output R'),
           (68, 'Output L'),
           (68, 'Output R'),
           (69, 'Output'),
           (70, 'Audio Output 1'),
           (70, 'Audio Output 2'),
           (71, 'Audio Output 1'),
           (72, 'Audio Output 1'),
           (73, 'Audio Output 1'),
           (74, 'Left Output'),
           (74, 'Right Output'),
           (75, 'Left Output'),
           (75, 'Right Output'),
           (76, 'Left Output'),
           (76, 'Right Output'),
           (77, 'Out'),
           (78, 'Out'),
           (79, 'Audio Out L'),
           (79, 'Audio Out R'),
           (80, 'Audio Out L'),
           (80, 'Audio Out R'),
           (81, 'Audio Out L'),
           (81, 'Audio Out R'),
           (82, 'Audio Out L'),
           (82, 'Audio Out R'),
           (83, 'Audio Out L'),
           (83, 'Audio Out R'),
           (84, 'Audio Out L'),
           (84, 'Audio Out R'),
           (85, 'Audio Out L'),
           (85, 'Audio Out R'),
           (86, 'Audio Out L'),
           (86, 'Audio Out R'),
           (87, 'Audio Out L'),
           (87, 'Audio Out R'),
           (88, 'Audio Out L'),
           (88, 'Audio Out R'),
           (89, 'Audio Out L'),
           (89, 'Audio Out R'),
           (90, 'Audio Out L'),
           (90, 'Audio Out R'),
           (91, 'Audio Out L'),
           (91, 'Audio Out R'),
           (92, 'Audio Out L'),
           (92, 'Audio Out R'),
           (93, 'Audio Out L'),
           (93, 'Audio Out R'),
           (94, 'Audio Out L'),
           (94, 'Audio Out R'),
           (95, 'Audio Out L'),
           (95, 'Audio Out R'),
           (96, 'Audio Out L'),
           (96, 'Audio Out R'),
           (97, 'Audio Out L'),
           (97, 'Audio Out R'),
           (98, 'Audio Out L'),
           (98, 'Audio Out R'),
           (99, 'Audio Out L'),
           (99, 'Audio Out R'),
           (100, 'Audio Out L'),
           (100, 'Audio Out R'),
           (101, 'Audio Out L'),
           (101, 'Audio Out R'),
           (102, 'Audio Out L'),
           (102, 'Audio Out R'),
           (103, 'Audio Out L'),
           (103, 'Audio Out R'),
           (104, 'Audio Out L'),
           (104, 'Audio Out R'),
           (105, 'Audio Out L'),
           (105, 'Audio Out R'),
           (106, 'Audio Out L'),
           (106, 'Audio Out R'),
           (107, 'Audio Out L'),
           (107, 'Audio Out R'),
           (108, 'Audio Out L'),
           (108, 'Audio Out R'),
           (109, 'Audio Out L'),
           (109, 'Audio Out R'),
           (110, 'Audio Out L'),
           (110, 'Audio Out R'),
           (111, 'Audio Out L'),
           (111, 'Audio Out R'),
           (112, 'Audio Out L'),
           (112, 'Audio Out R'),
           (113, 'Audio Out L'),
           (113, 'Audio Out R'),
           (114, 'Audio Out L'),
           (114, 'Audio Out R'),
           (115, 'Audio Out L'),
           (115, 'Audio Out R'),
           (116, 'Audio Out L'),
           (116, 'Audio Out R'),
           (117, 'Audio Out L'),
           (117, 'Audio Out R'),
           (118, 'Audio Out L'),
           (118, 'Audio Out R'),
           (119, 'Audio Out L'),
           (119, 'Audio Out R'),
           (120, 'Audio Out L'),
           (120, 'Audio Out R'),
           (121, 'Out 1'),
           (121, 'Out 2'),
           (121, 'Out 3'),
           (121, 'Out 4'),
           (122, 'Out 1'),
           (122, 'Out 2'),
           (122, 'Out 3'),
           (122, 'Out 4'),
           (123, 'Out 1'),
           (123, 'Out 2'),
           (124, 'Out 1'),
           (125, 'Out 1'),
           (126, 'Out 1'),
           (126, 'Out 2'),
           (127, 'Out'),
           (128, 'Out 1'),
           (128, 'Out 2'),
           (128, 'Out 3'),
           (129, 'Out 1'),
           (129, 'Out 2'),
           (130, 'Out'),
           (131, 'Out'),
           (132, 'Out'),
           (133, 'Out 1'),
           (133, 'Out 2'),
           (134, 'Clean Output'),
           (134, 'Out 1'),
           (134, 'Out 2'),
           (135, 'Out 1'),
           (135, 'Out 2'),
           (136, 'Out'),
           (137, 'Out'),
           (138, 'Out 1'),
           (138, 'Out 2'),
           (139, 'Left Out'),
           (139, 'Right Out'),
           (140, 'Left Out'),
           (140, 'Right Out'),
           (141, 'Left Out'),
           (141, 'Right Out'),
           (142, 'Left Out'),
           (142, 'Right Out'),
           (143, 'Left Out'),
           (143, 'Right Out'),
           (144, 'Left Out'),
           (144, 'Right Out'),
           (145, 'Left Out'),
           (145, 'Right Out'),
           (146, 'Left Out'),
           (146, 'Right Out'),
           (147, 'Left Out'),
           (147, 'Right Out'),
           (148, 'Left Out'),
           (148, 'Right Out'),
           (149, 'Left Out'),
           (149, 'Right Out'),
           (150, 'Left Out'),
           (150, 'Right Out'),
           (151, 'Left Out'),
           (151, 'Right Out'),
           (152, 'Left Out'),
           (152, 'Right Out'),
           (153, 'Left Out'),
           (153, 'Right Out'),
           (154, 'Left Out'),
           (154, 'Right Out'),
           (155, 'Left Out'),
           (155, 'Right Out'),
           (156, 'Left Out'),
           (156, 'Right Out'),
           (157, 'Left Out'),
           (157, 'Right Out'),
           (158, 'Left Out'),
           (158, 'Right Out'),
           (159, 'Left Out'),
           (159, 'Right Out'),
           (160, 'Left Out'),
           (160, 'Right Out'),
           (161, 'Left Out'),
           (161, 'Right Out'),
           (162, 'Left Out'),
           (162, 'Right Out'),
           (163, 'Left Out'),
           (163, 'Right Out'),
           (164, 'Left Out'),
           (164, 'Right Out'),
           (165, 'Left Out'),
           (165, 'Right Out'),
           (166, 'Left Out'),
           (166, 'Right Out'),
           (167, 'Left Out'),
           (167, 'Right Out'),
           (168, 'Left Out'),
           (168, 'Right Out'),
           (169, 'Left Out'),
           (169, 'Right Out'),
           (170, 'Left Out'),
           (170, 'Right Out'),
           (171, 'Left Out'),
           (171, 'Right Out'),
           (172, 'Left Out'),
           (172, 'Right Out'),
           (173, 'Left Out'),
           (173, 'Right Out'),
           (174, 'Left Out'),
           (174, 'Right Out'),
           (175, 'Out 1'),
           (176, 'Out 1'),
           (177, 'L Out'),
           (177, 'R Out'),
           (178, 'L Out'),
           (178, 'R Out'),
           (179, 'L Out'),
           (179, 'R Out'),
           (180, 'L Out'),
           (180, 'R Out'),
           (181, 'L Out'),
           (181, 'R Out'),
           (182, 'L Out'),
           (182, 'R Out'),
           (183, 'Out'),
           (184, 'Out'),
           (185, 'L Out'),
           (185, 'R Out'),
           (186, 'L Out'),
           (186, 'R Out'),
           (187, 'Out'),
           (188, 'L Out'),
           (188, 'R Out'),
           (189, 'Out'),
           (190, 'L Out'),
           (190, 'R Out'),
           (191, 'L Out'),
           (191, 'R Out'),
           (192, 'Out L'),
           (192, 'Out R'),
           (193, 'Out'),
           (194, 'Out'),
           (195, 'Out'),
           (196, 'Out'),
           (197, 'Out'),
           (198, 'Out'),
           (199, 'Out'),
           (200, 'Out'),
           (201, 'Out'),
           (202, 'Out'),
           (203, 'Out'),
           (204, 'Out'),
           (205, 'Out'),
           (206, 'Out'),
           (207, 'Out'),
           (207, 'Out1'),
           (208, 'Out'),
           (209, 'Out'),
           (210, 'Out'),
           (211, 'Out'),
           (211, 'Out1'),
           (212, 'Out'),
           (213, 'Out'),
           (213, 'Out1'),
           (214, 'Out'),
           (215, 'Out'),
           (216, 'Out'),
           (216, 'Out1'),
           (217, 'Out'),
           (218, 'Out'),
           (219, 'Out'),
           (220, 'Out'),
           (221, 'Out'),
           (222, 'Out'),
           (223, 'Out'),
           (224, 'Out'),
           (225, 'Out'),
           (226, 'Out'),
           (227, 'Out'),
           (228, 'Out'),
           (229, 'Out'),
           (230, 'Out'),
           (231, 'Out'),
           (231, 'Out1'),
           (232, 'Out'),
           (233, 'Out'),
           (234, 'Out'),
           (235, 'Out'),
           (236, 'Out'),
           (237, 'Out'),
           (238, 'Out'),
           (239, 'Out'),
           (240, 'Out'),
           (241, 'Out'),
           (242, 'Out'),
           (243, 'Out'),
           (244, 'Out'),
           (244, 'Out1'),
           (245, 'Out'),
           (245, 'Out1'),
           (246, 'Out'),
           (247, 'Out'),
           (247, 'Out1'),
           (248, 'Out'),
           (249, 'Out'),
           (250, 'Out'),
           (250, 'Out1'),
           (251, 'Out'),
           (252, 'Out'),
           (253, 'Out'),
           (254, 'Out'),
           (254, 'Out1'),
           (255, 'Out'),
           (256, 'Out'),
           (257, 'Out'),
           (257, 'Out1'),
           (258, 'Out'),
           (259, 'out0'),
           (259, 'out1'),
           (260, 'out0'),
           (260, 'out1'),
           (261, 'out0'),
           (261, 'out1'),
           (262, 'out0'),
           (263, 'Output1'),
           (263, 'Output2'),
           (263, 'Output3'),
           (264, 'Out L'),
           (264, 'Out R'),
           (265, 'Output'),
           (266, 'Output'),
           (267, 'Output'),
           (268, 'Output'),
           (269, 'Output'),
           (270, 'Out W'),
           (270, 'Out X'),
           (270, 'Out Y'),
           (270, 'Out Z'),
           (271, 'Output'),
           (272, 'Output'),
           (273, 'Output'),
           (274, 'Output'),
           (275, 'Output'),
           (276, 'Output'),
           (277, 'Output'),
           (278, 'Output'),
           (279, 'Output'),
           (280, 'Audio Output Left'),
           (280, 'Audio Output Right'),
           (281, 'Audio Output Left'),
           (281, 'Audio Output Right'),
           (282, 'Audio Output Left'),
           (282, 'Audio Output Right'),
           (283, 'Audio Output Left'),
           (283, 'Audio Output Right'),
           (284, 'Audio Output Left'),
           (284, 'Audio Output Right'),
           (285, 'Audio Output Left'),
           (285, 'Audio Output Right'),
           (286, 'Audio Output Left'),
           (286, 'Audio Output Right'),
           (287, 'Audio Output Left'),
           (287, 'Audio Output Right'),
           (288, 'Audio Output Left'),
           (288, 'Audio Output Right'),
           (289, 'Audio Output Left'),
           (289, 'Audio Output Right'),
           (290, 'Audio Output Left'),
           (290, 'Audio Output Right'),
           (291, 'Audio Output Left'),
           (291, 'Audio Output Right'),
           (292, 'Audio Output Left'),
           (292, 'Audio Output Right'),
           (293, 'Audio Output Left'),
           (293, 'Audio Output Right'),
           (294, 'Audio Output Left'),
           (294, 'Audio Output Right'),
           (295, 'Audio Output Left'),
           (295, 'Audio Output Right'),
           (296, 'Audio Output Left'),
           (296, 'Audio Output Right'),
           (297, 'Audio Output Left'),
           (297, 'Audio Output Right'),
           (298, 'Master Left'),
           (298, 'Master Right'),
           (298, 'AuxBus1 Left'),
           (298, 'AuxBus1 Right'),
           (298, 'AuxBus2 Left'),
           (298, 'AuxBus2 Right'),
           (298, 'AuxBus3 Left'),
           (298, 'AuxBus3 Right'),
           (298, 'AuxBus4 Left'),
           (298, 'AuxBus4 Right'),
           (299, 'Audio Output 1'),
           (299, 'Audio Output 2'),
           (300, 'Audio Output 1'),
           (300, 'Audio Output 2'),
           (301, 'Audio Output 1'),
           (302, 'Audio Output 1'),
           (302, 'Audio Output 2'),
           (303, 'Audio Output 1'),
           (303, 'Audio Output 2'),
           (304, 'Audio Output 1'),
           (304, 'Audio Output 2'),
           (305, 'Audio Output 1'),
           (306, 'Audio Output 1'),
           (306, 'Audio Output 2'),
           (307, 'Audio Output 1'),
           (308, 'Audio Output 1'),
           (309, 'Output Left'),
           (309, 'Output Right'),
           (310, 'Audio Output 1'),
           (310, 'Audio Output 2'),
           (310, 'Audio Output 3'),
           (310, 'Audio Output 4'),
           (310, 'Audio Output 5'),
           (310, 'Audio Output 6'),
           (311, 'Audio Output 1'),
           (311, 'Audio Output 2'),
           (312, 'Out Left'),
           (312, 'Out Right'),
           (313, 'Out'),
           (314, 'Out'),
           (315, 'Out Left'),
           (315, 'Out Right'),
           (316, 'Out'),
           (317, 'Out'),
           (318, 'Out Left'),
           (318, 'Out Right'),
           (319, 'Out'),
           (320, 'Out Left'),
           (320, 'Out Right'),
           (321, 'Out Left'),
           (321, 'Out Right'),
           (322, 'Out'),
           (323, 'Out'),
           (324, 'Out Left'),
           (324, 'Out Right'),
           (325, 'Out'),
           (326, 'Out'),
           (327, 'Out'),
           (328, 'Out Left'),
           (328, 'Out Right'),
           (329, 'Out'),
           (330, 'Out Left'),
           (330, 'Out Right'),
           (331, 'Out'),
           (332, 'Out'),
           (333, 'Out'),
           (334, 'Out'),
           (335, 'Out'),
           (336, 'Out'),
           (337, 'Out'),
           (338, 'Out'),
           (339, 'Out L'),
           (339, 'Out R'),
           (340, 'Out L'),
           (340, 'Out R'),
           (340, 'Out L 2'),
           (340, 'Out R 2'),
           (340, 'Out L 3'),
           (340, 'Out R 3'),
           (340, 'Out L 4'),
           (340, 'Out R 4'),
           (341, 'Out L'),
           (341, 'Out R'),
           (341, 'Out L 2'),
           (341, 'Out R 2'),
           (341, 'Out L 3'),
           (341, 'Out R 3'),
           (342, 'Out L'),
           (342, 'Out R'),
           (342, 'Out L 2'),
           (342, 'Out R 2'),
           (343, 'Out L'),
           (343, 'Out R'),
           (344, 'Out L'),
           (344, 'Out R'),
           (345, 'Out L'),
           (345, 'Out R'),
           (346, 'Out L'),
           (346, 'Out R'),
           (347, 'Out L'),
           (347, 'Out R'),
           (348, 'Out L'),
           (348, 'Out R'),
           (349, 'Out L'),
           (349, 'Out R'),
           (350, 'Out L'),
           (350, 'Out R'),
           (351, 'Out L'),
           (351, 'Out R'),
           (352, 'Out L'),
           (352, 'Out R'),
           (353, 'Out L'),
           (353, 'Out R'),
           (354, 'Out L'),
           (354, 'Out R'),
           (355, 'Out L'),
           (355, 'Out R'),
           (356, 'Out L'),
           (356, 'Out R'),
           (357, 'Out L'),
           (357, 'Out R'),
           (358, 'Out L'),
           (358, 'Out R'),
           (359, 'Out L'),
           (359, 'Out R'),
           (360, 'Out L'),
           (360, 'Out R'),
           (361, 'Out L'),
           (361, 'Out R'),
           (362, 'Out L'),
           (362, 'Out R'),
           (363, 'Out L'),
           (363, 'Out R'),
           (364, 'Out L'),
           (364, 'Out R'),
           (365, 'Out L'),
           (366, 'Out L'),
           (366, 'Out R'),
           (367, 'Out L'),
           (367, 'Out R'),
           (368, 'Out L'),
           (368, 'Out R'),
           (369, 'Out L'),
           (369, 'Out R'),
           (370, 'Out L'),
           (370, 'Out R'),
           (371, 'Out L'),
           (371, 'Out R'),
           (372, 'Out L'),
           (372, 'Out R'),
           (373, 'Out L'),
           (373, 'Out R'),
           (374, 'Out L'),
           (374, 'Out R'),
           (375, 'Out L'),
           (375, 'Out R'),
           (376, 'Out L'),
           (376, 'Out R'),
           (377, 'Out L'),
           (377, 'Out R'),
           (378, 'Out L'),
           (378, 'Out R'),
           (379, 'Out L'),
           (379, 'Out R'),
           (380, 'Out L'),
           (380, 'Out R'),
           (381, 'Out L'),
           (381, 'Out R'),
           (382, 'Out L'),
           (382, 'Out R'),
           (383, 'Output'),
           (384, 'Output'),
           (385, 'Output'),
           (386, 'Output'),
           (387, 'Output'),
           (388, 'Output'),
           (392, 'Output'),
           (396, 'Output'),
           (397, 'Output'),
           (400, 'Output'),
           (403, 'Output Left'),
           (403, 'Output Right'),
           (404, 'Audio Output'),
           (405, 'Output Left'),
           (405, 'Output Right'),
           (406, 'Audio Output Left'),
           (407, 'Audio Output Left'),
           (407, 'Audio Output Right'),
           (408, 'Audio Output'),
           (409, 'Audio Output'),
           (410, 'Output Left'),
           (410, 'Output Right'),
           (411, 'Output Left'),
           (411, 'Output Right'),
           (412, 'Audio Output'),
           (413, 'Audio Output'),
           (414, 'Audio Output'),
           (415, 'Left'),
           (415, 'Right'),
           (416, 'Output'),
           (417, 'Audio Output 1'),
           (417, 'Audio Output 2'),
           (418, 'Audio Output 1'),
           (418, 'Audio Output 2'),
           (419, 'Audio Output 1'),
           (419, 'Audio Output 2'),
           (420, 'Audio Output 1'),
           (420, 'Audio Output 2'),
           (421, 'Audio Output 1'),
           (421, 'Audio Output 2'),
           (422, 'Audio Output 1'),
           (422, 'Audio Output 2'),
           (423, 'Audio Output 1'),
           (423, 'Audio Output 2'),
           (424, 'Audio Output 1'),
           (424, 'Audio Output 2');


INSERT INTO instancia.banco (nome)
     VALUES ('Shows'),
            ('Experience');

INSERT INTO instancia.patch (id_banco, nome)
     VALUES (1, 'Ciranda cirandinha'),
            (1, 'Overdrive'),
            (1, 'Reverberado'),
            (2, 'Sem efeitos'),
            (2, 'Fá com baixo e Fá');

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (1,    2,  1), -- Placa de áudio - SAIDA dos instrumentos
            (2,    5,  1), -- Zamtube
            (3,   50,  1), -- Tap Vibrato
            (4,  192,  1), -- Invada Compressor (stereo)
            (5,    1,  1), -- Placa de áudio - ENTRADA dos amplificadores

            (6,    2,  2), -- Placa de áudio - SAIDA dos instrumentos
            (7,  379,  2), -- "Calf Crusher"
            (8,  248,  2), -- "Invada Tube Distortion (mono)"
            (9,    1,  2), -- Placa de áudio - ENTRADA dos amplificadores

	    (10,   2,  3), -- Placa de áudio - SAIDA dos instrumentos
            (11, 145,  3), -- "MDA TalkBox"
            (12, 170,  3), -- "MDA De-ess"
            (13, 328,  3), -- "C* Eq10X2 - 10-band equalizer"
            (14,   1,  3), -- Placa de áudio - ENTRADA dos amplificadores

            (15,   2,  4), -- Placa de áudio - SAIDA dos instrumentos
            (16,   1,  4), -- Placa de áudio - ENTRADA dos amplificadores

            (17,   2,  5), -- Placa de áudio - SAIDA dos instrumentos
            (18, 175,  5), -- "DS1"
            (19,   1,  5); -- Placa de áudio - ENTRADA dos amplificadores

     
--DELETE FROM instancia.conexao;
INSERT INTO instancia.conexao (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (1,  1,  2,   7), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "ZamTube - Audio Input 1"
            (2,  6,  3,  33), -- "ZamTube - Audio Output 1" -> "TAP Vibrato - Input"
	    (3, 33,  4, 260), -- "TAP Vibrato - Output" -> "Invada Compressor (stereo) - In L"
	    (4, 291, 5,   2), -- "Invada Compressor (stereo) - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (6, 2, 7, 495), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> "Calf Crusher - In L"
	    (6, 2, 8, 325), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> 

	    (7, 598, 9, 1), -- "Calf Crusher - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"
	    (8, 356, 9, 2), -- "Gxdigital_delay - Out" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (10,   2, 11, 184), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "MDA TalkBox - Left In"
	    (11, 204, 12, 226), -- "MDA TalkBox - Right Out" -> "MDA De-ess - Left In"
	    (11, 204, 13, 400), -- "MDA TalkBox - Right Out" -> "C* Eq10X2 - 10-band equalizer - In Left"
	    (12, 253, 13, 401), -- "MDA De-ess - Left Out" -> "C* Eq10X2 - 10-band equalizer - In Right"
	    (12, 254, 14,   2), -- "MDA De-ess - Right Out" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"
	    (13, 494, 14,   1), -- "C* Eq10X2 - 10-band equalizer - Out Left" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"

	    (15,   1, 16, 1), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"
	    (15,   2, 16, 2), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (17,   1, 18, 236); -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "DS1 - In"
	    

-- Plugs de um patch - Saida
SELECT id_patch, id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_saida, id_plug_saida
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_saida USING (id_efeito)
 WHERE id_patch = 4
  ORDER BY id_patch, id_efeito, id_instancia_efeito, efeito_nome, plug_saida.nome;

-- Plugs de um patch - Entrada
SELECT id_patch, id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_entrada, id_plug_entrada
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_entrada USING (id_efeito)
 WHERE id_patch = 4
  ORDER BY id_patch, id_efeito, id_instancia_efeito, efeito_nome, plug_entrada.nome;



-- Para selecionar um efeito com poucos parâmetros
SELECT id_efeito, id_plug_entrada, 'ENTRADA' as tipo, efeito.nome || ' - ' || plug_entrada.nome as nome
  FROM efeito.efeito
  JOIN efeito.plug_entrada USING (id_efeito)
 WHERE 
id_efeito IN (
	SELECT id_efeito 
	  FROM (
		SELECT COUNT(*) as total, id_efeito FROM efeito.plug_entrada
		GROUP BY id_efeito
		UNION ALL
		SELECT COUNT(*), id_efeito FROM efeito.plug_saida
		GROUP BY id_efeito
		) plugs
	GROUP BY id_efeito
	HAVING SUM(total) < 5
	ORDER BY id_efeito
)
UNION ALL
SELECT id_efeito, id_plug_saida, 'SAIDA' as tipo, efeito.nome || ' - ' || plug_saida.nome as nome
  FROM efeito.efeito
  JOIN efeito.plug_saida USING (id_efeito)
 WHERE 
id_efeito IN (
	SELECT id_efeito 
	  FROM (
		SELECT COUNT(*) as total, id_efeito FROM efeito.plug_entrada
		GROUP BY id_efeito
		UNION ALL
		SELECT COUNT(*), id_efeito FROM efeito.plug_saida
		GROUP BY id_efeito
		) plugs
	GROUP BY id_efeito
	HAVING SUM(total) < 5
	ORDER BY id_efeito
)
ORDER BY id_efeito, tipo;

-- Detalhes do patch
SELECT * FROM instancia.view_patch_detalhes;

-- Arestas do grafo portas
SELECT efeito_saida.id_patch,
       conexao.id_conexao,
       conexao.id_instancia_efeito_saida,
       efeito_saida.efeito_nome || ': ' || plug_saida.nome AS origem,
       conexao.id_instancia_efeito_entrada,
       efeito_entrada.efeito_nome || ': ' || plug_entrada.nome AS destino,
       conexao.id_instancia_efeito_saida || '.' || plug_saida.id_plug_saida || ' -> ' || conexao.id_instancia_efeito_entrada || '.' || plug_entrada.id_plug_entrada AS resumo

  FROM instancia.conexao,
       instancia.view_patch_detalhes AS efeito_saida,
       instancia.view_patch_detalhes AS efeito_entrada,
       efeito.plug_saida,
       efeito.plug_entrada

 WHERE id_instancia_efeito_saida   = efeito_saida.id_instancia_efeito
   AND id_instancia_efeito_entrada = efeito_entrada.id_instancia_efeito
   AND conexao.id_plug_saida   = plug_saida.id_plug_saida
   AND conexao.id_plug_entrada = plug_entrada.id_plug_entrada

 ORDER BY id_conexao;