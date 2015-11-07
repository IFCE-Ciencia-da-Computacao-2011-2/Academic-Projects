puts "*"*50
puts "Uso do while para"
puts "*"*50

print "(a)\n"

contador = 1
impressao = ""

while contador < 6
	impressao << "#{contador} "
	puts impressao

	contador+=1
end




print "\n\n(b) Modo 1: Um while\n"

contador = 1
impressao = "1 2 3 4 5"
branco = ""

while contador < 6
	puts branco + impressao

	impressao = impressao[0..-3]  # Remove o fim
	branco   += "  " # Adiciona os espaços no início
	contador += 1 
end



print "(b) Modo 2: While dentro de while\n"

contador = 1
branco = ""

while contador < 6
	print "  "*(contador-1)

	contadorNum = 1
	while contadorNum <= (6-contador)
		print "#{contadorNum} "
		contadorNum += 1
	end

	contador += 1
	puts ""
end



print "\n\n(c)\n"

contador = 1
branco = ""

while contador < 6
	contadorNum = 1
	while contadorNum <= contador
		print "#{contador} "
		contadorNum += 1
	end

	contador += 1
	puts ""
end