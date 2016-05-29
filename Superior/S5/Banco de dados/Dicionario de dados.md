# Dicion�rio de dados

## Schema: **dicionario_dados**

Schema respons�vel por abstrair o cat�logo do banco, expondo em views simplificadas dados relevantes para a gera��o de um dicion�rio de dados

 * **Usu�rio:** postgres
 * **Privil�gios:** None

### Rela��es



### Views

 Nome | Descri��o
 ---- | ---------
 dicionario_dados.atributo | Disp�e metadados importante de atributos
 dicionario_dados.database | Bancos de dados persistidos neste postgres
 dicionario_dados.relacao | Disp�e metadados importante de rela��es, sejam estas tabelas ou views
 dicionario_dados.schema | Disp�e metadados importante de schemas
 dicionario_dados.trigger | Disp�e metadados importante de triggers


### Triggers



## Schema: **efeito**

Schema respons�vel por agrupar elementos referentes a efeito: Defini��es de efeitos, tecnologias de efeitos, empresas que fizeram efeitos, par�metros de efeitos, tipos (categorias) de efeitos...

 * **Usu�rio:** postgres
 * **Privil�gios:** None

### Rela��es

#### **efeito.categoria**

Categoria no qual um efeito pode se enquadrar.
Como um efeito pode estar em mais de uma categoria, efeito.categoria_efeito relaciona as categorias para com os efeitos

##### Atributos

###### **efeito.categoria.id_categoria**

Chave prim�ria de categoria

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.categoria.nome**

Nome da categoria no qual o efeito pode se enquadrar

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.categoria_efeito**

Respons�vel por relacionar categorias e efeitos, de forma a permitir uma rela��o muitos-para-muitos

##### Atributos

###### **efeito.categoria_efeito.id_categoria**

Refer�ncia para chave prim�ria de categoria

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | Ref: efeito.categoria | -

###### **efeito.categoria_efeito.id_efeito**

Refer�ncia para chave prim�ria de efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | Ref: efeito.efeito | -

#### **efeito.efeito**

Efeitos s�o plugins que simulam "pedais" (de guitarra, de baixo...), "amplificadores", "sintetizadores" - dentre outros equipamentos - cujo intuito � melhorar (corrigir), modificar e (ou) incrementar o �udio obtido externamente (por uma interface de �udio) ou internamente (por um efeito anterior).
O produto (�udio processado) poder� ser utilizado externamente (sendo disposto em uma interface de �udio) ou internamente (por um efeito posterior ou grava��o de �udio)

 * Para conex�es entre efeitos, visite instancia.conexao;
 * Para representa��o de interface de �udio, visite efeito.

##### Atributos

###### **efeito.efeito.id_efeito**

Chave prim�ria de efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.efeito.nome**

Nome do efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(100) | 100 | Sim | - | - | -

###### **efeito.efeito.descricao**

Descri��o do efeito provindas da empresa que o desenvolveu

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 text | None | - | - | - | -

###### **efeito.efeito.identificador**

Identificador �nico em forma de URI - Identificador Uniforme de Recurso

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 efeito.site | None | Sim | - | - | Sim

###### **efeito.efeito.id_empresa**

Refer�ncia para chave prim�ria da empresa que desenvolveu o efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.empresa | -

###### **efeito.efeito.id_tecnologia**

Refer�ncia para chave prim�ria da tecnologia utilizada do efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.tecnologia | -

#### **efeito.empresa**

Empresa que produz efeitos. Pode ser interpretada tamb�m como Fornecedor ou Desenvolvedor

##### Atributos

###### **efeito.empresa.id_empresa**

Chave prim�ria de empresa

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.empresa.nome**

Nome da empresa

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.empresa.site**

Site - dado pela pr�pria empresa - no qual o usu�rio poder� encontrar informa��es dos produtos da desta

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 efeito.site | None | Sim | - | - | -

#### **efeito.parametro**

Parametro refere-se �s parametriza��es para um determinado efeito.
Esta tabela enumera os poss�veis par�metros de um efeito, bem como o estado poss�vel deste, determinando seu dom�nio atrav�s de parametro.minimo, parametro.m�ximo e parametro.valor_padrao.

Note entretanto que uma tupla n�o cont�m o valor (estado atual) de um par�metro para um efeito, pois este trabalho fora direcionado para instancia.configuracao_efeito_parametro.

 * Para detalhes sobre como definir um valor a um par�metro, visite instancia.configuracao_efeito_parametro;
 * Para detalhes sobre o que � uma inst�ncia de um efeito, visite instancia.instancia_efeito.

##### Atributos

###### **efeito.parametro.id_parametro**

Chave prim�ria de parametro

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.parametro.id_efeito**

Refer�ncia para chave prim�ria de efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.parametro.nome**

Nome do par�metro

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.parametro.minimo**

Menor valor poss�vel no qual este par�metro pode assumir

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

###### **efeito.parametro.maximo**

Maior valor poss�vel no qual este par�metro pode assumir

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

###### **efeito.parametro.valor_padrao**

Valor padr�o do par�metro. Obviamente, deve estar dentro do intervalo [minimo, maximo]

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

#### **efeito.plug_entrada**

Um plug � a porta de entrada ou de sa�da do �udio. Seu uso possibilita o processamento em s�rie de v�rios efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de entrada permite que um sinal que chega seja processado pelo efeito. Um simples exemplo �: Sa�da da guitarra **entra** na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos atrav�s dos plugs), visite instancia.conexao

##### Atributos

###### **efeito.plug_entrada.id_plug_entrada**

Chave prim�ria de plug_entrada

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.plug_entrada.id_efeito**

Refer�ncia para chave prim�ria de efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.plug_entrada.nome**

Nome do plug

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.plug_saida**

Um plug � a porta de entrada ou de sa�da do �udio. Seu uso possibilita o processamento em s�rie de v�rios efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de sa�da permite o uso por outro efeito de um sinal processado do efeito com o plug de sa�da utilizado. Um simples exemplo �: **Sa�da** da guitarra entra na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos atrav�s dos plugs), visite instancia.conexao

##### Atributos

###### **efeito.plug_saida.id_plug_saida**

Chave prim�ria de plug_saida

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.plug_saida.id_efeito**

Refer�ncia para chave prim�ria de efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.plug_saida.nome**

Nome do plug

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.tecnologia**

Tecnologia/padr�o de plugins de �udio no qual um efeito � desenvolvido

##### Atributos

###### **efeito.tecnologia.id_tecnologia**

Chave prim�ria de tecnologia

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.tecnologia.nome**

Nome da tecnologia

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.tecnologia.descricao**

Descri��o da tecnologia, conforme dispon�vel na Internet

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 text | None | Sim | - | - | -



### Views

 Nome | Descri��o
 ---- | ---------
 efeito.view_efeito_descricao | None


### Triggers



## Schema: **instancia**

Schema respons�vel por agrupar elementos referentes a inst�ncia: Inst�ncia de efeito, valores atuais dos par�metros de determinada inst�ncia, agrupamento de inst�ncias em um patch, agrupamento de patchs em um banco, conex�es entre inst�ncias de um patch...

 * **Usu�rio:** postgres
 * **Privil�gios:** None

### Rela��es

#### **instancia.banco**

Um banco serve como agrupador de patchs.

Usu�rios costumam utilizar bancos como forma de agrupar um conjunto de patchs para determinada situa��o. Ex:

 * Banco "Rock" contendo patchs para m�sicas cl�ssicas do rock;
 * Banco "Show dia dd/mm/yyyy" contendo patchs que ser�o utilizados em determinado show
 * Banco "Artista Tal" contendo patchs criados pelo pr�prio artista como forma que querer agradar seu nicho de f�s

##### Atributos

###### **instancia.banco.id_banco**

Chave prim�ria de banco

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.banco.nome**

Nome representativo do banco. Deve ser curto, pois este poder� ser exibido em um display pequeno

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(20) | 20 | Sim | - | - | -

#### **instancia.conexao**

Representa uma conex�o entre duas instancia_efeito. De forma an�loga a conex�o real de pedais, representa um cabo de �udio ligando dois pedais, onde uma ponta conecta-se em um plug espec�fico de sa�da de um pedal A para um plug espec�fico de entrada de outro pedal B, de modo a transportar o �udio que sai de A para B.

Pode-se tamb�m interpretar instancia.patch como um grafo, onde as portas (instancia.porta) dos efeitos das inst�ncias s�o os n�s e as conex�es (instancia.conexao) representa os v�rtices

##### Atributos

###### **instancia.conexao.id_conexao**

Chave prim�ria de conexao

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.conexao.id_instancia_efeito_saida**

Refer�ncia para chave prim�ria de instancia_efeito. Inst�ncia de efeito cuja seu efeito possua o plug de sa�da (id_plug_saida)

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.conexao.id_plug_saida**

Refer�ncia para chave prim�ria de plug_saida. Representa o plug de origem, onde o qual a conex�o entre as instancia_efeitos parte. Pode ser entendido como V�rtice de origem de uma Aresta do grafo "Conex�es de um Patch"

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.plug_saida | Sim

###### **instancia.conexao.id_instancia_efeito_entrada**

Menor valor poss�vel no qual este par�metro pode assumir. Inst�ncia de efeito cuja seu efeito possua o plug de entrada (id_plug_entrada)

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.conexao.id_plug_entrada**

Refer�ncia para chave prim�ria de plug_entrada. Representa o plug de destino, onde o qual a conex�o entre as instancia_efeitos destina-se. Pode ser entendido como V�rtice de destino de uma Aresta do grafo "Conex�es de um Patch"

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.plug_entrada | Sim

#### **instancia.configuracao_efeito_parametro**

Sabendo que um efeito pode ser utilizado em mais de um patch, como tamb�m pode ser utilizado mais de uma vez em um mesmo patch, os valores atuais dos par�metros devem ser persistidos vinculando efeito.instancia_efeito.

Uma tupla de instancia.configuracao_efeito_parametro representa: Um valor de um determinado par�metro de uma inst�ncia de um efeito

##### Atributos

###### **instancia.configuracao_efeito_parametro.id_configuracao_efeito_parametro**

Chave prim�ria de configuracao_efeito_parametro

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.configuracao_efeito_parametro.id_instancia_efeito**

Refer�ncia para instancia_efeito. Representa a inst�ncia do efeito no qual o par�metro pertence

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.configuracao_efeito_parametro.id_parametro**

Refer�ncia para parametro. Representa o parametro no qual ser� atribu�do um valor

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.parametro | Sim

###### **instancia.configuracao_efeito_parametro.valor**

Valor do parametro para a instancia_efeito. Este deve estar contido no intervalo [efeito.parametro.minimo, efeito.parametro.maximo]

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

#### **instancia.instancia_efeito**

efeito.efeito est� para "obra" como instancia.instancia_efeito est� para "m�dia f�sica".

Como um efeito pode ser utilizado m�ltiplas vezes em uma instancia.patch e cada um tem sua devida configura��o (conjunto de instancia.configuracao_efeito_parametro para cada instancia.instancia_efeito), instancia_efeito se faz necess�ria.

##### Atributos

###### **instancia.instancia_efeito.id_instancia_efeito**

Chave prim�ria de instancia_efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.instancia_efeito.id_efeito**

Refer�ncia para chave prim�ria de efeito. Inst�ncia efeito "� do tipo" efeito

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.efeito | -

###### **instancia.instancia_efeito.id_patch**

Refer�ncia para chave prim�ria de patch. Patch no qual inst�ncia est� contida

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.patch | -

###### **instancia.instancia_efeito.ativo**

Inst�ncia efeito est� ativo? Ou seja, a inst�ncia deve processar o sinal que recebe nas entradas (ativo == true) ou deve simplesmente encaminhar o sinal que recebe das entradas para as sa�das? (ativo == false)

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 boolean | None | Sim | - | - | -

#### **instancia.patch**

Um patch representa uma configura��o de uso dos efeitos que relaciona inst�ncias de efeitos, as conex�es entre inst�ncias, o estado das inst�ncias e os valores atuais dos par�metros de cada inst�ncia.

##### Atributos

###### **instancia.patch.id_patch**

Chave prim�ria de patch

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.patch.id_banco**

Refer�ncia para chave prim�ria de banco. Banco no qual o Patch pertence

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.banco | -

###### **instancia.patch.nome**

Nome representativo do patch. Deve ser curto, pois este poder� ser exibido em um display pequeno

 Tipo | Tamanho | Obrigat�rio | Chave prim�ria | Chave estrangeira | �nico
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(20) | 20 | Sim | - | - | -



### Views

 Nome | Descri��o
 ---- | ---------
 instancia.view_patch_detalhes | None


### Triggers


#### **instancia.configuracao_efeito_parametro.trigger_atualizar_valor_instancia_efeito_parametro**

Trigger que verifica as seguintes restri��es para UPDATE em instancia.configuracao_efeito_parametro:

Valor de um par�metro (instancia.configuracao_efeito_parametro.valor) deve estar entre o m�nimo e o m�ximo do par�metro correspondente ([efeito.parametro.minimo, efeito.parametro.maximo])

 * **Fun��o:** funcao_atualizar_valor_instancia_efeito_parametro

#### **instancia.instancia_efeito.trigger_gerar_configuracao_efeito_parametro**

Trigger que verifica as seguintes restri��es para INSERT, UPDATE ou DELETE em instancia.instancia_efeito:

 * Para uma instancia_efeito criada, ser�o inseridos automaticamente instancia.configuracao_efeito_parametro para cada par�metro do efeito da inst�ncia.
   O valor ser� o efeito.parametro.valor_padrao;
 * Para uma instancia_efeito alterada ou exclu�da, ser�o alterados ou excluidos automaticamente instancia.configuracao_efeito_parametro para cada par�metro do efeito da inst�ncia.
   O valor ser� o efeito.parametro.valor_padrao.


 * **Fun��o:** funcao_gerar_configuracao_efeito_parametro

#### **instancia.conexao.trigger_gerenciar_conexao**

Trigger que verifica as seguintes restri��es para INSERT OR UPDATE em instancia.conexao:

 * Plug de SA�DA deve pertencer ao efeito no qual a instancia refere-se;
 * Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se.

 * **Fun��o:** funcao_gerenciar_conexao

#### **instancia.conexao.trigger_gerenciar_conexao_ciclos**

Trigger que verifica as seguintes restri��es para INSERT OR UPDATE em instancia.conexao:

 * N�o deve haver ciclos no n�vel de instancia_efeito.

Seguem exemplos. A, B, C e D s�o exemplos de instancia.instancia_efeito:

 * N�o h� ciclo: START -> A -> B -> C -> END
 * H� ciclo: START -> A -> B -> D -> A -- CICLO!

 * **Fun��o:** funcao_gerenciar_conexao_ciclos


## Schema: **public**

Schema n�o utilizado em PedalPi

 * **Usu�rio:** postgres
 * **Privil�gios:** None

### Rela��es



### Views

 Nome | Descri��o
 ---- | ---------


### Triggers

