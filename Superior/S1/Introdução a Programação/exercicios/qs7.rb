# Entrada: Posição de um bispo.
# Saida: Posição para as quais o bispo pode ser movido.

puts "*"*50
puts "Posições do bispo"
puts "*"*50

# Desenho do campo
print "\n  "
for cont in 0 .. 7
	print "#{cont} "
end
puts ""
for cont in 0 .. 7
	if cont%2==0:
		puts cont.to_s + "|" + "#| |"*4
	else
		puts cont.to_s + "|" + " |#|"*4
	end
end


puts "\nDigite a posição do bispo"
print " Linha: "
linha = gets.to_i

print " Coluna: "
coluna = gets.to_i

puts ""

# Calculando posições

#  Eu faço um laço percorrendo todas as linhas
#  E mando printar as possições possíveis nessa coluna


for linhaDaInteracao in 0..7
	#    F(x) = |linha-linhaDaInteracao|
	distancia = (linha-linhaDaInteracao).abs

	# ColunaNaLinha = linha + distância
	#	Como distância é módulo, temos dois casos, para direita e para esquerda,
	#	Ou seja, em uma mesma linha temos duas posições possíveis

	# No fim, só verifico se a coluna está dentro do campo
	#  para saber se a posição é válida


	# Obs: (Se não tiver esse if, ele ia printar dois resultados 
	#       quando linha == linhaDaInteracao)
	if (distancia == 0)
		puts " Posição: [#{linhaDaInteracao}, #{coluna-distancia}]"

	else
		if (coluna-distancia >= 0 && coluna-distancia < 8)
			puts " Posição: [#{linhaDaInteracao}, #{coluna-distancia}]"
		end
		if (coluna+distancia >= 0 && coluna+distancia < 8)
			puts " Posição: [#{linhaDaInteracao}, #{coluna+distancia}]"
		end
	end
end