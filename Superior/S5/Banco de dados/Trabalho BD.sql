COMMENT ON DATABASE "PedalPi" IS 'Banco de persistência do multi-efeitos PedalPi';

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
DROP DOMAIN IF EXISTS efeito.Site CASCADE;
CREATE DOMAIN efeito.Site varchar(200);

COMMENT ON DOMAIN efeito.Site IS 'Endereço eletrônico';

------------------------------------------
-- Efeito
------------------------------------------
CREATE TABLE efeito.efeito (
	id_efeito serial PRIMARY KEY,
	nome varchar(100) NOT NULL,
	descricao text,
	identificador efeito.Site UNIQUE NOT NULL,
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
COMMENT ON COLUMN efeito.efeito.identificador IS 'Identificador único em forma de URI - Identificador Uniforme de Recurso';
COMMENT ON COLUMN efeito.efeito.id_empresa IS 'Referência para chave primária da empresa que desenvolveu o efeito';
COMMENT ON COLUMN efeito.efeito.id_tecnologia IS 'Referência para chave primária da tecnologia utilizada do efeito';

------------------------------------------
-- Tecnologia e empresa do dispositivo
------------------------------------------
CREATE TABLE efeito.empresa (
	id_empresa serial PRIMARY KEY,
	nome varchar(50) NOT NULL,
	site efeito.Site NOT NULL
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
	nome_do_efeito varchar(200);
	id_do_efeito int;

    BEGIN
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

 * Plug de SAÍDA deve pertencer ao efeito no qual a instancia refere-se;
 * Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se.';

/*
-- Testes
--  1. Plug saída não pertencente ao efeito de saída
INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (10000, 1, 50, 2, 1);

UPDATE instancia.conexao 
   set id_instancia_efeito_saida=1, id_plug_saida=50, id_instancia_efeito_entrada=2, id_plug_entrada=1
 where id_conexao = 1;

--  2. Plug entrada não pertencente ao efeito de entrada
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
--INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
--     VALUES (10000, 1, 3, 2,  1),
--            (10001, 2, 3, 3,  5),
--            (10002, 3, 6, 4, 64),
--            (10003, 3, 6, 1,  1); -- Loop


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

Valor de um parâmetro (instancia.configuracao_efeito_parametro.valor) deve estar entre o mínimo e o máximo do parâmetro correspondente ([efeito.parametro.minimo, efeito.parametro.maximo])';

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


------------------------------------------
-- Dados de exemplo
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
