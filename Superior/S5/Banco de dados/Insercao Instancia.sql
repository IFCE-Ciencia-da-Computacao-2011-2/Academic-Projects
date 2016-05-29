INSERT INTO instancia.banco (nome)
     VALUES ('Shows'),
            ('Experience');

INSERT INTO instancia.patch (id_banco, nome)
     VALUES (1, 'Clean'),
            (1, 'Overdrive'),
            (1, 'Reverberado'),
            (2, 'Sol com Ab'),
            (2, 'Fá com baixo e Fá');

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (1,    2,  1), -- Placa de áudio - SAIDA dos instrumentos
            (2,    5,  1), -- Zamtube
            (3,   50,  1), -- Tap Vibrato
            (4,  192,  1), -- Invada Compressor (stereo)
            (5,    1,  1); -- Placa de áudio - ENTRADA dos amplificadores
            --(4,   50,  1),
            --(5,  234,  1);

--DELETE FROM instancia.conexao;
INSERT INTO instancia.conexao (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (1,  1,  2,   7), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "ZamTube - Audio Input 1"
            (2,  6,  3,  33), -- "ZamTube - Audio Output 1" -> "TAP Vibrato - Input"
	    (3, 33,  4, 260), -- "TAP Vibrato - Output" -> "Invada Compressor (stereo) - In L"
	    (4, 291, 5,   2), -- "Invada Compressor (stereo) - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"
	    (4, 291, 5,   3); -- "Invada Compressor (stereo) - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

-- Plugs de um patch - Saida
SELECT id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_saida, id_plug_saida
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_saida USING (id_efeito)
  ORDER BY id_efeito, id_instancia_efeito, efeito_nome, plug_saida.nome;

-- Plugs de um patch - Entrada
SELECT id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_entrada, id_plug_entrada
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_entrada USING (id_efeito)
  ORDER BY id_efeito, id_instancia_efeito, efeito_nome, plug_entrada.nome;



-- Para selecionar um efeito com poucos parâmetros
/*
SELECT id_efeito, efeito.nome || ' - ' || plug.nome as plug, id_plug, id_tipo_plug
  FROM efeito.efeito
  JOIN efeito.plug USING (id_efeito)
 WHERE 
id_efeito IN (
	SELECT id_efeito FROM efeito.plug
	 GROUP BY id_efeito
	 HAVING COUNT(*) < 5
	ORDER BY id_efeito
);
*/

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