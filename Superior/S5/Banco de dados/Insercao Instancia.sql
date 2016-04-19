
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

-- Portas de um patch
SELECT * FROM instancia.view_patch_detalhes
  JOIN efeito.plug USING (id_efeito)
  ORDER BY id_efeito, id_instancia_efeito, efeito_nome, plug.nome;