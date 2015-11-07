# Entrada: Posi��o(linha e coluna) de um cavalo em um tabuleiro de xadrez.
# Saida: Posi��es para onde o cavalo pode ser movido.

puts "*"*50
puts "Posi��es do cavalo"
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


puts "\nDigite a posi��o do cavalo"
print " Linha: "
linha = gets.to_i

print " Coluna: "
coluna = gets.to_i


puts ""

# Calculando posi��es
#  Temos 8 posi��es poss�veis, todas em L
#  Sempre temos a combina��o:
#  S {[Linha +- 2, Coluna +- 1], [Linha +- 1, Coluna +- 2]}
#
#  O lance � ver quais desse conjuno solu��o fica dentro do tabuleiro
for calculaLinha in 0..1

	for calculaColuna in 0 .. 1:
		# f(x) = 4x + (linha-2) <=> linhaMovido1 = linha +-2
		linhaMovido1 = linha + calculaLinha*4 - 2
		# f(x) = 2x + (linha-1) <=> linhaMovido2 = linha +-1
		linhaMovido2 = linha + calculaLinha*2 - 1

		# f(x) = 2x + (coluna-1) <=> colunaMovido1 = linha +-1
		colunaMovido1 = coluna + calculaColuna*2 - 1
		# f(x) = 4x + (coluna-2) <=> colunaMovido2 = linha +-2
		colunaMovido2 = coluna + calculaColuna*4 - 2

		if (linhaMovido1 >= 0 && colunaMovido1 >= 0 && 
			linhaMovido1  < 8 && colunaMovido1  < 8)
			puts " Posi��o: [#{linhaMovido1}, #{colunaMovido1}]"
		end
		if (linhaMovido2 >= 0 && colunaMovido2 >= 0 &&
			linhaMovido2  < 8 && colunaMovido2  < 8)
			puts " Posi��o: [#{linhaMovido2}, #{colunaMovido2}]"
		end
	end
end