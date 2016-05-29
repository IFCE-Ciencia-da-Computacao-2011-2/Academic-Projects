INSERT INTO instancia.banco (nome)
     VALUES ('Shows'),
            ('Experience');

INSERT INTO instancia.patch (id_banco, nome)
     VALUES (1, 'Ciranda cirandinha'),
            (1, 'Overdrive'),
            (1, 'Reverberado'),
            (2, 'Sem efeitos'),
            (2, 'Fá com baixo e Fá');

INSERT INTO instancia.instancia_efeito (id_instancia_efeito, id_efeito, id_patch)
     VALUES (1,    2,  1), -- Placa de áudio - SAIDA dos instrumentos
            (2,    5,  1), -- Zamtube
            (3,   50,  1), -- Tap Vibrato
            (4,  192,  1), -- Invada Compressor (stereo)
            (5,    1,  1), -- Placa de áudio - ENTRADA dos amplificadores

            (6,    2,  2), -- Placa de áudio - SAIDA dos instrumentos
            (7,  379,  2), -- "Calf Crusher"
            (8,  248,  2), -- "Invada Tube Distortion (mono)"
            (9,    1,  2), -- Placa de áudio - ENTRADA dos amplificadores

	    (10,   2,  3), -- Placa de áudio - SAIDA dos instrumentos
            (11, 145,  3), -- "MDA TalkBox"
            (12, 170,  3), -- "MDA De-ess"
            (13, 328,  3), -- "C* Eq10X2 - 10-band equalizer"
            (14,   1,  3), -- Placa de áudio - ENTRADA dos amplificadores

            (15,   2,  4), -- Placa de áudio - SAIDA dos instrumentos
            (16,   1,  4), -- Placa de áudio - ENTRADA dos amplificadores

            (17,   2,  5), -- Placa de áudio - SAIDA dos instrumentos
            (18, 175,  5), -- "DS1"
            (19,   1,  5); -- Placa de áudio - ENTRADA dos amplificadores

     
--DELETE FROM instancia.conexao;
INSERT INTO instancia.conexao (id_instancia_efeito_saida, id_plug_saida, id_instancia_efeito_entrada, id_plug_entrada)
     VALUES (1,  1,  2,   7), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "ZamTube - Audio Input 1"
            (2,  6,  3,  33), -- "ZamTube - Audio Output 1" -> "TAP Vibrato - Input"
	    (3, 33,  4, 260), -- "TAP Vibrato - Output" -> "Invada Compressor (stereo) - In L"
	    (4, 291, 5,   2), -- "Invada Compressor (stereo) - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (6, 2, 7, 495), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> "Calf Crusher - In L"
	    (6, 2, 8, 325), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> 

	    (7, 598, 9, 1), -- "Calf Crusher - Out L" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"
	    (8, 356, 9, 2), -- "Gxdigital_delay - Out" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (10,   2, 11, 184), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "MDA TalkBox - Left In"
	    (11, 204, 12, 226), -- "MDA TalkBox - Right Out" -> "MDA De-ess - Left In"
	    (11, 204, 13, 400), -- "MDA TalkBox - Right Out" -> "C* Eq10X2 - 10-band equalizer - In Left"
	    (12, 253, 13, 401), -- "MDA De-ess - Left Out" -> "C* Eq10X2 - 10-band equalizer - In Right"
	    (12, 254, 14,   2), -- "MDA De-ess - Right Out" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"
	    (13, 494, 14,   1), -- "C* Eq10X2 - 10-band equalizer - Out Left" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"

	    (15,   1, 16, 1), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Esquerdo"
	    (15,   2, 16, 2), -- "Placa de áudio - SAÍDA dos instrumentos - Canal Direito" -> "Placa de áudio - ENTRADA dos amplificadores - Canal Direito"

	    (17,   1, 18, 236); -- "Placa de áudio - SAÍDA dos instrumentos - Canal Esquerdo" -> "DS1 - In"
	    

-- Plugs de um patch - Saida
SELECT id_patch, id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_saida, id_plug_saida
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_saida USING (id_efeito)
 WHERE id_patch = 4
  ORDER BY id_patch, id_efeito, id_instancia_efeito, efeito_nome, plug_saida.nome;

-- Plugs de um patch - Entrada
SELECT id_patch, id_efeito, efeito_nome || ' - ' || nome AS plug_nome, id_instancia_efeito as id_instancia_efeito_entrada, id_plug_entrada
  FROM instancia.view_patch_detalhes
  JOIN efeito.plug_entrada USING (id_efeito)
 WHERE id_patch = 4
  ORDER BY id_patch, id_efeito, id_instancia_efeito, efeito_nome, plug_entrada.nome;



-- Para selecionar um efeito com poucos parâmetros
SELECT id_efeito, id_plug_entrada, 'ENTRADA' as tipo, efeito.nome || ' - ' || plug_entrada.nome as nome
  FROM efeito.efeito
  JOIN efeito.plug_entrada USING (id_efeito)
 WHERE 
id_efeito IN (
	SELECT id_efeito 
	  FROM (
		SELECT COUNT(*) as total, id_efeito FROM efeito.plug_entrada
		GROUP BY id_efeito
		UNION ALL
		SELECT COUNT(*), id_efeito FROM efeito.plug_saida
		GROUP BY id_efeito
		) plugs
	GROUP BY id_efeito
	HAVING SUM(total) < 5
	ORDER BY id_efeito
)
UNION ALL
SELECT id_efeito, id_plug_saida, 'SAIDA' as tipo, efeito.nome || ' - ' || plug_saida.nome as nome
  FROM efeito.efeito
  JOIN efeito.plug_saida USING (id_efeito)
 WHERE 
id_efeito IN (
	SELECT id_efeito 
	  FROM (
		SELECT COUNT(*) as total, id_efeito FROM efeito.plug_entrada
		GROUP BY id_efeito
		UNION ALL
		SELECT COUNT(*), id_efeito FROM efeito.plug_saida
		GROUP BY id_efeito
		) plugs
	GROUP BY id_efeito
	HAVING SUM(total) < 5
	ORDER BY id_efeito
)
ORDER BY id_efeito, tipo;

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