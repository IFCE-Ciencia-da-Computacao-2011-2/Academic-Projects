puts "*"*50
puts "Algoritmo"
puts "*"*50

print "Digite um número inteiro qualquer: "
numero = gets.to_i

while numero != 1
	if numero % 2 == 0
		numero /= 2
	elsif
		numero = numero*3 + 1
	end

	puts numero
end