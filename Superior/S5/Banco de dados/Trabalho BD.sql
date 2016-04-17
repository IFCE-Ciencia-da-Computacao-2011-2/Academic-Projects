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
/*
INSERT INTO efeito.empresa (id_empresa, nome, site)
VALUES (1, 'Guitarix', 'http://guitarix.org/'),
       (2, 'Calf Studio Gear', 'http://calf-studio-gear.org/'),
       (3, 'Mod Devices', 'http://moddevices.com/'),
       (4, 'TAP', 'http://tap-plugins.sourceforge.net/'),
       (5, 'CAPS', 'http://quitte.de/dsp/caps.html');
*/

INSERT INTO efeito.tecnologia (id_tecnologia, nome, descricao)
VALUES (1, 'LV²', 'LV2 is an open standard for audio plugins, used by hundreds of plugins and other projects. At its core, LV2 is a simple stable interface, accompanied by extensions which add functionality to support the needs of increasingly powerful audio software'),
       (2, 'LADSPA', 'LADSPA is an acronym for Linux Audio Developer"s Simple Plugin Aefeito. It is an application programming interface (Aefeito) standard for handling audio filters and audio signal processing effects, licensed under the GNU Lesser General Public License (LGPL)'),
       (3, 'VST', 'Virtual Studio Technology (VST) is a software interface that integrates software audio synthesizer and effect plugins with audio editors and recording systems. VST and similar technologies use digital signal processing to simulate traditional recording studio hardware in software. Thousands of plugins exist, both commercial and freeware, and a large number of audio applications support VST under license from its creator, Steinberg.');

-- Categorias de efeitos
/*
INSERT INTO efeito.categoria (id_categoria, nome)
VALUES (1, 'DELAY'),
       (2, 'DISTORTION'),
       (3, 'DYNAMICS'),
       (4, 'FILTER'),
       (5, 'GENERATOR'),
       (6, 'MODULATOR'),
       (7, 'REVERB'),
       (8, 'SIMULATOR'),
       (9, 'SPECTRAL');
*/

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
	
	id_instancia_efeito_entrada int,
	id_plug_entrada int,
	id_instancia_efeito_saida int,
	id_plug_saida int,

	UNIQUE (id_instancia_efeito_entrada, id_plug_entrada, id_instancia_efeito_saida, id_plug_saida)
);

------------------------------------------
-- Instância, Patchs e bancos
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

	UNIQUE (id_banco, posicao)
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
CREATE VIEW efeito.descricao_efeito AS
SELECT id_efeito, efeito.nome, efeito.identificador, empresa.nome AS empresa, tecnologia.nome AS tecnologia
  FROM efeito.efeito
  JOIN efeito.empresa USING (id_empresa)
  JOIN efeito.tecnologia USING (id_tecnologia);

CREATE VIEW instancia.detalhes_patch AS

SELECT id_patch, id_banco,
       instancia.banco.posicao || ' - ' || instancia.banco.nome || ': ' || instancia.patch.posicao || ' - ' || instancia.patch.nome AS patch_nome, 
       instancia.instancia_efeito.id_instancia_efeito,
       efeito.descricao_efeito.id_efeito, efeito.descricao_efeito.identificador AS efeito_identificador, 
       efeito.descricao_efeito.nome AS efeito_nome, 
       efeito.descricao_efeito.empresa, 
       efeito.descricao_efeito.tecnologia

  FROM instancia.patch
  JOIN instancia.instancia_efeito USING (id_patch)
  JOIN instancia.banco USING (id_banco)
  JOIN efeito.descricao_efeito USING (id_efeito)

ORDER BY banco.posicao, patch.posicao, id_instancia_efeito;

------------------------------------------
-- Dados de exemplo
------------------------------------------
/*
INSERT INTO efeito.efeito (id_efeito, nome, identificador, id_empresa, id_tecnologia)
VALUES (1, 'TAP Reflector', 'http://tap-plugins.sourceforge.net/ladspa/reflector.html', 4, 2),
       (2, 'Auto Filter', 'http://quitte.de/dsp/caps.html#AutoFilter', 5, 2);
*/

SELECT * FROM efeito.descricao_efeito;

SELECT * FROM instancia.detalhes_patch;