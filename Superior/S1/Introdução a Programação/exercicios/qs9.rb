# Entrada: Posi��es de dois cavalos.
# Saida: Verificar se um cavalo pode atacar o outro.

puts "*"*50
puts "Posi��es de dois cavalos"
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


puts "\nDigite a posi��o do 1� cavalo"
print " Linha: "
linha1 = gets.to_i

print " Coluna: "
coluna1 = gets.to_i

puts "\nDigite a posi��o do 2� cavalo"
print " Linha2: "
linha2 = gets.to_i

print " Coluna2: "
coluna2 = gets.to_i

puts ""

# Calculando dist�ncias
distanciaLinha  = (linha1-linha2).abs
distanciaColuna = (coluna1-coluna2).abs

# dist�ncia no eixo X do cavalo com o outro = 2
# dist�ncia no eixo Y do cavalo com o outro = 1
#
# ou o contr�rio

if ((distanciaLinha == 2 && distanciaColuna == 1) ||
	(distanciaLinha == 1 && distanciaColuna == 2))
	puts "AMEA�A"
else
	puts "N�o Amea�a"
end