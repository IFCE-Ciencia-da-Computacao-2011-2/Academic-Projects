DROP SCHEMA IF EXISTS efeito CASCADE;
CREATE SCHEMA efeito;

DROP SCHEMA IF EXISTS instancia CASCADE;
CREATE SCHEMA instancia;

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

------------------------------------------
-- Tecnologia e empresa do dispositivo
------------------------------------------
CREATE TABLE efeito.empresa (
	id_empresa int PRIMARY KEY, -- Empresas podem ser de qualquer lugar do mundo
	nome varchar(50) NOT NULL,
	site efeito.Site NOT NULL
);

CREATE TABLE efeito.tecnologia (
	id_tecnologia int PRIMARY KEY,
	nome varchar(50) NOT NULL,
	descricao text NOT NULL
);


------------------------------------------
-- Categorias de efeitos
------------------------------------------

CREATE TABLE efeito.categoria (
	id_categoria int PRIMARY KEY,
	nome varchar(50) NOT NULL
);

CREATE TABLE efeito.categoria_efeito (
	id_categoria int,
	id_efeito int,

	PRIMARY KEY(id_categoria, id_efeito)
);


------------------------------------------
-- Plug
------------------------------------------
CREATE TABLE efeito.plug (
	id_plug int PRIMARY KEY,
	id_efeito int,
	id_tipo_plug int,
	nome varchar(50)
);

CREATE TABLE efeito.tipo_plug (
	id_tipo_plug int PRIMARY KEY,
	nome varchar(50) UNIQUE
);

------------------------------------------
-- Parametro
------------------------------------------
CREATE TABLE efeito.parametro (
	id_parametro int PRIMARY KEY,
	id_efeito int,	
	nome varchar(50),

	minimo float,
	maximo float,
	valor_padrao int
);

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

	id_instancia_efeito_saida int,
	id_plug_saida int,

	id_instancia_efeito_entrada int,
	id_plug_entrada int,
	
	UNIQUE (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
);

------------------------------------------
-- Instância, Patchs e Bancos
------------------------------------------
CREATE TABLE instancia.instancia_efeito (
	id_instancia_efeito int PRIMARY KEY,
	id_efeito int,
	id_patch int
);

CREATE TABLE instancia.patch (
	id_patch int PRIMARY KEY,
	id_banco int,
	nome VARCHAR(20),
	posicao int CHECK (posicao >= 0),

	UNIQUE (id_banco, posicao)
);

CREATE TABLE instancia.banco (
	id_banco int PRIMARY KEY,
	nome VARCHAR(20),
	posicao int CHECK (posicao >= 0),

	UNIQUE (posicao)
);

------------------------------------------
-- Configuração e parâmetros
------------------------------------------
CREATE TABLE instancia.configuracao_efeito_parametro (
	id_configuracao_efeito_parametro int PRIMARY KEY,
	id_instancia_efeito int,
	id_parametro int,
	valor float,

	UNIQUE (id_instancia_efeito, id_parametro)
);

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
-- Popular dados BASE
------------------------------------------

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