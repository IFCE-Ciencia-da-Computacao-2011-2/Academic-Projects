# Trabalho de banco de dados

## Arquivos

### SQLs

 * **Trabalho BD.sql**: Criação de tabelas, schemas, etc...
 * **Insercao Efeito.sql**: População das tabelas de Efeito. Gerado por _ExtractEffects.js_
 * **Insercao Instancia.sql**: População das tabelas de Instancia

### Scripts

 * **download.js**: Baixa os plugins de ModDevices e coloca em plugins.json
 * **ExtractEffects.js**: Pega os dados de .json (plugins.json) e converte para SQL (```node ExtractEffects.js >> Insercao Efeito.sql```)
 * **dicionario_dados.py**: Consulta o banco para obter as informações e gera um .md (```python dicionario_dados.py >> "Dicionario de dados.md"```)

### Outros

 * **Dicionario de dados.md**: Arquivo gerado a partir de _dicionario_dados.py_
 * **Dicionário de dados.pdf**: Arquivo gerado a partir de _dicionario_dados.py_ + https://stackedit.io/editor