
SELECT * FROM instancia.view_patch_detalhes;

INSERT INTO instancia.banco (id_banco, nome, posicao)
     VALUES (1, 'Shows', 0),
            (2, 'Experience', 1);

INSERT INTO instancia.patch (id_patch, id_banco, nome, posicao)
     VALUES (1, 1, 'Clean', 0),
            (2, 1, 'Overdrive', 1),
            (3, 1, 'Reverberado', 2),
            (4, 2, 'Sol com Ab', 0),
            (5, 2, 'Fá com baixo e Fá', 1);

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (1,    1,  1),
            (2,    1,  1),
            (3,    2,  1),
            (4,   50,  1),
            (5,  234,  1);

INSERT INTO instancia.conexao (id_conexao, id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (1, 1, 3, 2,  1),
            (3, 2, 3, 3,  5),
            (4, 3, 6, 4, 64); -- Efeito equalizador não utilizado

-- Portas de um patch
SELECT id_instancia_efeito, efeito_nome, id_plug, id_tipo_plug, nome AS plug_nome
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug USING (id_efeito)
  ORDER BY id_efeito, id_instancia_efeito, efeito_nome, plug.nome;

-- Arestas do grafo portas
SELECT * --efeito_nome || ': ' || plug.nome AS origem, efeito_nome || ': ' || plug.nome AS destino
  FROM instancia.conexao
  JOIN instancia.view_patch_detalhes ON (
	   id_instancia_efeito_saida = id_instancia_efeito
	OR id_instancia_efeito_entrada = id_instancia_efeito
  )
  JOIN efeito.plug ON (
	   id_plug_saida = id_plug
	OR id_plug_entrada = id_plug
  )