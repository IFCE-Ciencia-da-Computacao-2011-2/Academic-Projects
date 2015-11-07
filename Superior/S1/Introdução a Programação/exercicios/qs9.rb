# Entrada: Posições de dois cavalos.
# Saida: Verificar se um cavalo pode atacar o outro.

puts "*"*50
puts "Posições de dois cavalos"
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


puts "\nDigite a posição do 1° cavalo"
print " Linha: "
linha1 = gets.to_i

print " Coluna: "
coluna1 = gets.to_i

puts "\nDigite a posição do 2° cavalo"
print " Linha2: "
linha2 = gets.to_i

print " Coluna2: "
coluna2 = gets.to_i

puts ""

# Calculando distâncias
distanciaLinha  = (linha1-linha2).abs
distanciaColuna = (coluna1-coluna2).abs

# distância no eixo X do cavalo com o outro = 2
# distância no eixo Y do cavalo com o outro = 1
#
# ou o contrário

if ((distanciaLinha == 2 && distanciaColuna == 1) ||
	(distanciaLinha == 1 && distanciaColuna == 2))
	puts "AMEAÇA"
else
	puts "Não Ameaça"
end