puts "*"*50
puts "Num de coordenadas inteiras de uma circunfer�ncia"
puts "*"*50

print "Raio da circunfer�ncia: "
raio = gets.to_f


raio2 = raio**2 # Otimiza��o de algor�tmo

coordInteiras = [] # Optei por armazenar os pontos da circunfer�ncia
                   # em vez de simplesmente contar
comparacoes = 0

for eixoX in (-raio.to_i .. raio.to_i)
	for eixoY in (-raio.to_i .. raio.to_i)
		comparacoes += 1

		# Soma quadrados dos catetos (hipotenusa) <= r�
		# hipotenusa == dit�ncia do ponto ao centro do c�rculo
		if eixoX**2+eixoY**2 <= raio2
			coordInteiras << "(#{eixoX}, #{eixoY})"
		end
	end
end

puts "\nTotal de pontos"
puts " " << coordInteiras.length.to_s

#puts "\nPontos"
#puts coordInteiras

#puts "\nTotal de compara��es"
#puts " " << comparacoes.to_s

#puts "\nCompara��es em v�o"
#puts " " << (comparacoes - coordInteiras.length).to_s