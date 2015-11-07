# Entrada: Posições de duas rainhas.
# Saida: Verificar se as rainhas podem atacar uma a outra.

puts "*"*50
puts "Posições duas rainhas"
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


puts "\nDigite a posição da rainha"
print " Linha: "
linha1 = gets.to_i

print " Coluna: "
coluna1 = gets.to_i

puts "\nDigite a posição da outra rainha"
print " Linha2: "
linha2 = gets.to_i

print " Coluna2: "
coluna2 = gets.to_i

puts ""

# Calculando posições

#  Para duas rainhas se chocarem, elas tem que estar:
ameaca = false
#   - Na mesma linha
if (linha1 == linha2)
	puts "AMEAÇA"
	ameaca = true
end

#   - Na mesma coluna
if (coluna1 == coluna2)
	puts "AMEAÇA"
	ameaca = true
end

#   - Na mesma diagonal

#  Diagonal de um quadrado entre os pontos 4:
#    |coluna1-coluna2| (<- módulo)
#    |linha1-linha2|   (<- módulo)

if (coluna1-coluna2).abs == (linha1-linha2).abs
	puts "AMEAÇA"
	ameaca = true
end

# Nunca ao mesmo tempo, se não estariam no mesmo canto
# mas não vem ao caso

if (not ameaca)
	puts "NÃO AMEAÇA"
end