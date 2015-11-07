# Entrada: Posi��o de um bispo.
# Saida: Posi��o para as quais o bispo pode ser movido.

puts "*"*50
puts "Posi��es do bispo"
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


puts "\nDigite a posi��o do bispo"
print " Linha: "
linha = gets.to_i

print " Coluna: "
coluna = gets.to_i

puts ""

# Calculando posi��es

#  Eu fa�o um la�o percorrendo todas as linhas
#  E mando printar as possi��es poss�veis nessa coluna


for linhaDaInteracao in 0..7
	#    F(x) = |linha-linhaDaInteracao|
	distancia = (linha-linhaDaInteracao).abs

	# ColunaNaLinha = linha + dist�ncia
	#	Como dist�ncia � m�dulo, temos dois casos, para direita e para esquerda,
	#	Ou seja, em uma mesma linha temos duas posi��es poss�veis

	# No fim, s� verifico se a coluna est� dentro do campo
	#  para saber se a posi��o � v�lida


	# Obs: (Se n�o tiver esse if, ele ia printar dois resultados 
	#       quando linha == linhaDaInteracao)
	if (distancia == 0)
		puts " Posi��o: [#{linhaDaInteracao}, #{coluna-distancia}]"

	else
		if (coluna-distancia >= 0 && coluna-distancia < 8)
			puts " Posi��o: [#{linhaDaInteracao}, #{coluna-distancia}]"
		end
		if (coluna+distancia >= 0 && coluna+distancia < 8)
			puts " Posi��o: [#{linhaDaInteracao}, #{coluna+distancia}]"
		end
	end
end