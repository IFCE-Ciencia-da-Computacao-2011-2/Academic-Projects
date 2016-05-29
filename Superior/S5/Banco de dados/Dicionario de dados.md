# Dicionário de dados

## Schema: **dicionario_dados**

Schema responsável por abstrair o catálogo do banco, expondo em views simplificadas dados relevantes para a geração de um dicionário de dados

 * **Usuário:** postgres
 * **Privilégios:** None

### Relações



### Views

 Nome | Descrição
 ---- | ---------
 dicionario_dados.atributo | Dispõe metadados importante de atributos
 dicionario_dados.database | Bancos de dados persistidos neste postgres
 dicionario_dados.relacao | Dispõe metadados importante de relações, sejam estas tabelas ou views
 dicionario_dados.schema | Dispõe metadados importante de schemas
 dicionario_dados.trigger | Dispõe metadados importante de triggers


### Triggers



## Schema: **efeito**

Schema responsável por agrupar elementos referentes a efeito: Definições de efeitos, tecnologias de efeitos, empresas que fizeram efeitos, parâmetros de efeitos, tipos (categorias) de efeitos...

 * **Usuário:** postgres
 * **Privilégios:** None

### Relações

#### **efeito.categoria**

Categoria no qual um efeito pode se enquadrar.
Como um efeito pode estar em mais de uma categoria, efeito.categoria_efeito relaciona as categorias para com os efeitos

##### Atributos

###### **efeito.categoria.id_categoria**

Chave primária de categoria

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.categoria.nome**

Nome da categoria no qual o efeito pode se enquadrar

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.categoria_efeito**

Responsável por relacionar categorias e efeitos, de forma a permitir uma relação muitos-para-muitos

##### Atributos

###### **efeito.categoria_efeito.id_categoria**

Referência para chave primária de categoria

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | Ref: efeito.categoria | -

###### **efeito.categoria_efeito.id_efeito**

Referência para chave primária de efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | Ref: efeito.efeito | -

#### **efeito.efeito**

Efeitos são plugins que simulam "pedais" (de guitarra, de baixo...), "amplificadores", "sintetizadores" - dentre outros equipamentos - cujo intuito é melhorar (corrigir), modificar e (ou) incrementar o áudio obtido externamente (por uma interface de áudio) ou internamente (por um efeito anterior).
O produto (áudio processado) poderá ser utilizado externamente (sendo disposto em uma interface de áudio) ou internamente (por um efeito posterior ou gravação de áudio)

 * Para conexões entre efeitos, visite instancia.conexao;
 * Para representação de interface de áudio, visite efeito.

##### Atributos

###### **efeito.efeito.id_efeito**

Chave primária de efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.efeito.nome**

Nome do efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(100) | 100 | Sim | - | - | -

###### **efeito.efeito.descricao**

Descrição do efeito provindas da empresa que o desenvolveu

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 text | None | - | - | - | -

###### **efeito.efeito.identificador**

Identificador único em forma de URI - Identificador Uniforme de Recurso

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 efeito.site | None | Sim | - | - | Sim

###### **efeito.efeito.id_empresa**

Referência para chave primária da empresa que desenvolveu o efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.empresa | -

###### **efeito.efeito.id_tecnologia**

Referência para chave primária da tecnologia utilizada do efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.tecnologia | -

#### **efeito.empresa**

Empresa que produz efeitos. Pode ser interpretada também como Fornecedor ou Desenvolvedor

##### Atributos

###### **efeito.empresa.id_empresa**

Chave primária de empresa

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.empresa.nome**

Nome da empresa

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.empresa.site**

Site - dado pela própria empresa - no qual o usuário poderá encontrar informações dos produtos da desta

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 efeito.site | None | Sim | - | - | -

#### **efeito.parametro**

Parametro refere-se às parametrizações para um determinado efeito.
Esta tabela enumera os possíveis parâmetros de um efeito, bem como o estado possível deste, determinando seu domínio através de parametro.minimo, parametro.máximo e parametro.valor_padrao.

Note entretanto que uma tupla não contém o valor (estado atual) de um parâmetro para um efeito, pois este trabalho fora direcionado para instancia.configuracao_efeito_parametro.

 * Para detalhes sobre como definir um valor a um parâmetro, visite instancia.configuracao_efeito_parametro;
 * Para detalhes sobre o que é uma instância de um efeito, visite instancia.instancia_efeito.

##### Atributos

###### **efeito.parametro.id_parametro**

Chave primária de parametro

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.parametro.id_efeito**

Referência para chave primária de efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.parametro.nome**

Nome do parâmetro

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.parametro.minimo**

Menor valor possível no qual este parâmetro pode assumir

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

###### **efeito.parametro.maximo**

Maior valor possível no qual este parâmetro pode assumir

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

###### **efeito.parametro.valor_padrao**

Valor padrão do parâmetro. Obviamente, deve estar dentro do intervalo [minimo, maximo]

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

#### **efeito.plug_entrada**

Um plug é a porta de entrada ou de saída do áudio. Seu uso possibilita o processamento em série de vários efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de entrada permite que um sinal que chega seja processado pelo efeito. Um simples exemplo é: Saída da guitarra **entra** na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos através dos plugs), visite instancia.conexao

##### Atributos

###### **efeito.plug_entrada.id_plug_entrada**

Chave primária de plug_entrada

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.plug_entrada.id_efeito**

Referência para chave primária de efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.plug_entrada.nome**

Nome do plug

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.plug_saida**

Um plug é a porta de entrada ou de saída do áudio. Seu uso possibilita o processamento em série de vários efeitos - assim como uma cadeia de pedais de guitarra. 
Um plug de saída permite o uso por outro efeito de um sinal processado do efeito com o plug de saída utilizado. Um simples exemplo é: **Saída** da guitarra entra na caixa de som.

 * Para saber como conectar efeitos (ou seja, vincular o processamento realizado pelos efeitos através dos plugs), visite instancia.conexao

##### Atributos

###### **efeito.plug_saida.id_plug_saida**

Chave primária de plug_saida

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.plug_saida.id_efeito**

Referência para chave primária de efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: efeito.efeito | -

###### **efeito.plug_saida.nome**

Nome do plug

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

#### **efeito.tecnologia**

Tecnologia/padrão de plugins de áudio no qual um efeito é desenvolvido

##### Atributos

###### **efeito.tecnologia.id_tecnologia**

Chave primária de tecnologia

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **efeito.tecnologia.nome**

Nome da tecnologia

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(50) | 50 | Sim | - | - | -

###### **efeito.tecnologia.descricao**

Descrição da tecnologia, conforme disponível na Internet

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 text | None | Sim | - | - | -



### Views

 Nome | Descrição
 ---- | ---------
 efeito.view_efeito_descricao | None


### Triggers



## Schema: **instancia**

Schema responsável por agrupar elementos referentes a instância: Instância de efeito, valores atuais dos parâmetros de determinada instância, agrupamento de instâncias em um patch, agrupamento de patchs em um banco, conexões entre instâncias de um patch...

 * **Usuário:** postgres
 * **Privilégios:** None

### Relações

#### **instancia.banco**

Um banco serve como agrupador de patchs.

Usuários costumam utilizar bancos como forma de agrupar um conjunto de patchs para determinada situação. Ex:

 * Banco "Rock" contendo patchs para músicas clássicas do rock;
 * Banco "Show dia dd/mm/yyyy" contendo patchs que serão utilizados em determinado show
 * Banco "Artista Tal" contendo patchs criados pelo próprio artista como forma que querer agradar seu nicho de fãs

##### Atributos

###### **instancia.banco.id_banco**

Chave primária de banco

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.banco.nome**

Nome representativo do banco. Deve ser curto, pois este poderá ser exibido em um display pequeno

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(20) | 20 | Sim | - | - | -

#### **instancia.conexao**

Representa uma conexão entre duas instancia_efeito. De forma análoga a conexão real de pedais, representa um cabo de áudio ligando dois pedais, onde uma ponta conecta-se em um plug específico de saída de um pedal A para um plug específico de entrada de outro pedal B, de modo a transportar o áudio que sai de A para B.

Pode-se também interpretar instancia.patch como um grafo, onde as portas (instancia.porta) dos efeitos das instâncias são os nós e as conexões (instancia.conexao) representa os vértices

##### Atributos

###### **instancia.conexao.id_conexao**

Chave primária de conexao

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.conexao.id_instancia_efeito_saida**

Referência para chave primária de instancia_efeito. Instância de efeito cuja seu efeito possua o plug de saída (id_plug_saida)

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.conexao.id_plug_saida**

Referência para chave primária de plug_saida. Representa o plug de origem, onde o qual a conexão entre as instancia_efeitos parte. Pode ser entendido como Vértice de origem de uma Aresta do grafo "Conexões de um Patch"

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.plug_saida | Sim

###### **instancia.conexao.id_instancia_efeito_entrada**

Menor valor possível no qual este parâmetro pode assumir. Instância de efeito cuja seu efeito possua o plug de entrada (id_plug_entrada)

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.conexao.id_plug_entrada**

Referência para chave primária de plug_entrada. Representa o plug de destino, onde o qual a conexão entre as instancia_efeitos destina-se. Pode ser entendido como Vértice de destino de uma Aresta do grafo "Conexões de um Patch"

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.plug_entrada | Sim

#### **instancia.configuracao_efeito_parametro**

Sabendo que um efeito pode ser utilizado em mais de um patch, como também pode ser utilizado mais de uma vez em um mesmo patch, os valores atuais dos parâmetros devem ser persistidos vinculando efeito.instancia_efeito.

Uma tupla de instancia.configuracao_efeito_parametro representa: Um valor de um determinado parâmetro de uma instância de um efeito

##### Atributos

###### **instancia.configuracao_efeito_parametro.id_configuracao_efeito_parametro**

Chave primária de configuracao_efeito_parametro

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.configuracao_efeito_parametro.id_instancia_efeito**

Referência para instancia_efeito. Representa a instância do efeito no qual o parâmetro pertence

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.instancia_efeito | Sim

###### **instancia.configuracao_efeito_parametro.id_parametro**

Referência para parametro. Representa o parametro no qual será atribuído um valor

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.parametro | Sim

###### **instancia.configuracao_efeito_parametro.valor**

Valor do parametro para a instancia_efeito. Este deve estar contido no intervalo [efeito.parametro.minimo, efeito.parametro.maximo]

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 double precision | None | Sim | - | - | -

#### **instancia.instancia_efeito**

efeito.efeito está para "obra" como instancia.instancia_efeito está para "mídia física".

Como um efeito pode ser utilizado múltiplas vezes em uma instancia.patch e cada um tem sua devida configuração (conjunto de instancia.configuracao_efeito_parametro para cada instancia.instancia_efeito), instancia_efeito se faz necessária.

##### Atributos

###### **instancia.instancia_efeito.id_instancia_efeito**

Chave primária de instancia_efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.instancia_efeito.id_efeito**

Referência para chave primária de efeito. Instância efeito "é do tipo" efeito

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.efeito | -

###### **instancia.instancia_efeito.id_patch**

Referência para chave primária de patch. Patch no qual instância está contida

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.patch | -

###### **instancia.instancia_efeito.ativo**

Instância efeito está ativo? Ou seja, a instância deve processar o sinal que recebe nas entradas (ativo == true) ou deve simplesmente encaminhar o sinal que recebe das entradas para as saídas? (ativo == false)

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 boolean | None | Sim | - | - | -

#### **instancia.patch**

Um patch representa uma configuração de uso dos efeitos que relaciona instâncias de efeitos, as conexões entre instâncias, o estado das instâncias e os valores atuais dos parâmetros de cada instância.

##### Atributos

###### **instancia.patch.id_patch**

Chave primária de patch

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | Sim | - | -

###### **instancia.patch.id_banco**

Referência para chave primária de banco. Banco no qual o Patch pertence

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 integer | None | Sim | - | Ref: instancia.banco | -

###### **instancia.patch.nome**

Nome representativo do patch. Deve ser curto, pois este poderá ser exibido em um display pequeno

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 character varying(20) | 20 | Sim | - | - | -



### Views

 Nome | Descrição
 ---- | ---------
 instancia.view_patch_detalhes | None


### Triggers


#### **instancia.configuracao_efeito_parametro.trigger_atualizar_valor_instancia_efeito_parametro**

Trigger que verifica as seguintes restrições para UPDATE em instancia.configuracao_efeito_parametro:

Valor de um parâmetro (instancia.configuracao_efeito_parametro.valor) deve estar entre o mínimo e o máximo do parâmetro correspondente ([efeito.parametro.minimo, efeito.parametro.maximo])

 * **Função:** funcao_atualizar_valor_instancia_efeito_parametro

#### **instancia.instancia_efeito.trigger_gerar_configuracao_efeito_parametro**

Trigger que verifica as seguintes restrições para INSERT, UPDATE ou DELETE em instancia.instancia_efeito:

 * Para uma instancia_efeito criada, serão inseridos automaticamente instancia.configuracao_efeito_parametro para cada parâmetro do efeito da instância.
   O valor será o efeito.parametro.valor_padrao;
 * Para uma instancia_efeito alterada ou excluída, serão alterados ou excluidos automaticamente instancia.configuracao_efeito_parametro para cada parâmetro do efeito da instância.
   O valor será o efeito.parametro.valor_padrao.


 * **Função:** funcao_gerar_configuracao_efeito_parametro

#### **instancia.conexao.trigger_gerenciar_conexao**

Trigger que verifica as seguintes restrições para INSERT OR UPDATE em instancia.conexao:

 * Plug de SAÍDA deve pertencer ao efeito no qual a instancia refere-se;
 * Plug de ENTRADA deve pertencer ao efeito no qual a instancia refere-se.

 * **Função:** funcao_gerenciar_conexao

#### **instancia.conexao.trigger_gerenciar_conexao_ciclos**

Trigger que verifica as seguintes restrições para INSERT OR UPDATE em instancia.conexao:

 * Não deve haver ciclos no nível de instancia_efeito.

Seguem exemplos. A, B, C e D são exemplos de instancia.instancia_efeito:

 * Não há ciclo: START -> A -> B -> C -> END
 * Há ciclo: START -> A -> B -> D -> A -- CICLO!

 * **Função:** funcao_gerenciar_conexao_ciclos


## Schema: **public**

Schema não utilizado em PedalPi

 * **Usuário:** postgres
 * **Privilégios:** None

### Relações



### Views

 Nome | Descrição
 ---- | ---------


### Triggers

