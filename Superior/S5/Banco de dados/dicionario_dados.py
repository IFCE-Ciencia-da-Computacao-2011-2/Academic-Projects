#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
1 - python3 doc.py >> markdown.md
2 - Copiar conteúdo de markdown.md para https://stackedit.io
'''

import psycopg2
import psycopg2.extras

class Dicionario:
    SELECT = "SELECT nome FROM dicionario_dados.schema ORDER BY schema"

    TEXTO = '''# Dicionário de dados

{schema}
'''

    def __init__(self, conexao):
        self.conexao = conexao


    def format(self):
        resultado = ""
        
        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT)

        for record in cursor:
            resultado += Schema(self.conexao, record['nome']).format()

        cursor.close()

        dados = {'schema': resultado}
        return self.TEXTO.format(**dados)


class Schema:
    SELECT = "SELECT * FROM dicionario_dados.schema WHERE nome = '{schema}'"

    TEXTO = '''## Schema: **{schema}**

{descricao}

 * **Usuário:** {usuario}
 * **Privilégios:** {privilegios}

### Relações

{relacoes}

### Views
{views}

### Triggers
{triggers}

'''
    def __init__(self, conexao, schema):
        self.conexao = conexao
        self.schema = schema

    def format(self):
        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT.format(schema=self.schema))
        dadosSchema = cursor.fetchone();
        cursor.close()

        dados = {
            'schema': self.schema,
            'descricao': dadosSchema['comentario'],
            'usuario': dadosSchema['usuario'],
            'privilegios': dadosSchema['privilegios'],
            'relacoes': Relacoes(self.conexao, self.schema).format(),
            'views': Views(self.conexao, self.schema).format(),
            'triggers': Triggers(self.conexao, self.schema).format()
        }

        return self.TEXTO.format(**dados)


class Relacoes:
    SELECT = "SELECT * FROM dicionario_dados.relacao WHERE schema = '{schema}' AND tipo = 'TABLE'"

    def __init__(self, cursor, schema):
        self.conexao = cursor
        self.schema = schema

    def format(self):
        relacoes = ""

        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT.format(schema=self.schema))

        for record in cursor:
            relacoes += Relacao(self.conexao, record).format()

        cursor.close()

        return relacoes


class Relacao:
    TEXTO = '''#### **{schema}.{relacao}**

{descricao}

##### Atributos
{atributos}
'''

    def __init__(self, cursor, dados):
        self.conexao = cursor
        self.dados = dados

    def format(self):
        dados = {
            'schema': self.dados['schema'],
            'relacao': self.dados['relacao'],
            'descricao': self.dados['comentario'],
            'atributos': Atributos(cursor, self.dados['schema'], self.dados['relacao']).format()
        }

        return self.TEXTO.format(**dados)

class Atributos:
    TEXTO = '''
###### **{schema}.{relacao}.{atributo}**

{comentario}

 Tipo | Tamanho | Obrigatório | Chave primária | Chave estrangeira | Único
 ---- | ------- | ----------- | -------------- | ----------------- | -----
 {tipo} | {tamanho} | {obrigatorio} | {chave_primaria} | {chave_estrangeira} | {valor_unico}
'''
    
    ANTERIOR = '''
 * **Tipo:** {tipo}
 * **Tamanho:** {tamanho}
 * **Obrigatório:** {obrigatorio}
 * **Chave primária:** {chave_primaria}
 * **Chave estrangeira:** {chave_estrangeira}
 * **Único:** {valor_unico}
'''

    SELECT = "SELECT * FROM dicionario_dados.atributo WHERE schema = '{schema}' AND relacao = '{relacao}'"

    def __init__(self, cursor, schema, relacao):
        self.conexao = cursor
        self.schema = schema
        self.relacao = relacao

    def format(self):
        retorno = ""

        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT.format(schema=self.schema, relacao=self.relacao))

        for record in cursor:
            retorno += self.TEXTO.format(**dict(record))

        cursor.close()

        return retorno

class Views:
    SELECT = "SELECT * FROM dicionario_dados.relacao WHERE schema = '{schema}' AND tipo = 'VIEW'"
    TEXTO = '''
 Nome | Descrição
 ---- | ---------'''

    TEXTO_LINHA = ''' {schema}.{relacao} | {comentario}
'''

    def __init__(self, cursor, schema):
        self.conexao = cursor
        self.schema = schema

    def format(self):
        resultado = self.TEXTO + '\n'

        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT.format(schema=self.schema))

        for record in cursor:
            resultado += self.TEXTO_LINHA.format(**dict(record))

        cursor.close()

        return resultado

class Triggers:
    SELECT = "SELECT * FROM dicionario_dados.trigger WHERE schema = '{schema}'"
    TEXTO = ''''''

    TEXTO_LINHA = '''
#### **{schema}.{relacao}.{nome}**

{comentario}

 * **Função:** {nome_funcao}
'''

    def __init__(self, cursor, schema):
        self.conexao = cursor
        self.schema = schema

    def format(self):
        resultado = self.TEXTO + '\n'

        cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(self.SELECT.format(schema=self.schema))

        for record in cursor:
            resultado += self.TEXTO_LINHA.format(**dict(record))

        cursor.close()

        return resultado

conexao = psycopg2.connect("host=localhost dbname=PedalPi port=5432 user=postgres password=")
cursor = conexao.cursor(cursor_factory=psycopg2.extras.DictCursor)

print(Dicionario(cursor).format())

cursor.close()
conexao.close()
