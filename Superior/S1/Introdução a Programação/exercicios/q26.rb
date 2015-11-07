puts "*"*50
puts "Num de coordenadas inteiras de uma circunferência"
puts "*"*50

print "Raio da circunferência: "
raio = gets.to_f


raio2 = raio**2 # Otimização de algorítmo

coordInteiras = [] # Optei por armazenar os pontos da circunferência
                   # em vez de simplesmente contar
comparacoes = 0

for eixoX in (-raio.to_i .. raio.to_i)
	for eixoY in (-raio.to_i .. raio.to_i)
		comparacoes += 1

		# Soma quadrados dos catetos (hipotenusa) <= r²
		# hipotenusa == ditância do ponto ao centro do círculo
		if eixoX**2+eixoY**2 <= raio2
			coordInteiras << "(#{eixoX}, #{eixoY})"
		end
	end
end

puts "\nTotal de pontos"
puts " " << coordInteiras.length.to_s

#puts "\nPontos"
#puts coordInteiras

#puts "\nTotal de comparações"
#puts " " << comparacoes.to_s

#puts "\nComparações em vão"
#puts " " << (comparacoes - coordInteiras.length).to_s