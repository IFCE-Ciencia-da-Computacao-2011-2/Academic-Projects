puts "While = Enquanto a condição é verdadeira"
puts "Until = Até que a condição seja verdadeira"
puts "Times = int.times = repetir 'int' vezes"
puts "For   = \"Para cada elemento da lista\"\n"

puts "*"*50
puts "Uso do until para"
puts "*"*50

puts "(a)"

contador = 1
impressao = ""

until contador == 6
	impressao << "#{contador} "
	puts impressao

	contador+=1
end



puts "\n(b)"

contador = 1

until contador == 6
	print "  "*(contador-1)

	contadorNum = 1
	until contadorNum > 6-contador
		print "#{contadorNum} "
		contadorNum += 1
	end

	contador += 1
	puts ""
end



puts "\n(c)"

contador = 1

until contador == 6
	contadorNum = 1
	until contadorNum > contador
		print "#{contador} "
		contadorNum += 1
	end

	contador += 1
	puts ""
end

############################################################

puts "\n"+"*"*50
puts "*"*50
puts "Uso do for para"
puts "*"*50

puts "(a)"

impressao = ""
for contador in (1..5)
	impressao << "#{contador} "
	puts impressao
end



puts "\n(b)"

for linha in (1...6)
	print "  "*(linha-1)

	contadorNum = 1
	for contadorNum in (1..6-linha)
		print "#{contadorNum} "
	end
	puts ""
end



puts "\n(c)"

for linha in (1..5)
	contadorNum = 1
	for contadorNum in (1..linha)
		print "#{linha} "
	end

	puts ""
end



############################################################

puts "\n"+"*"*50
puts "*"*50
puts "Uso do times para"
puts "*"*50

puts "(a)"

linha = 1
impressao = ""

5.times do
	impressao << "#{linha} "
	puts impressao
	linha+=1
end



puts "\n(b)"

linha = 1

5.times do
	print "  "*(linha-1)

	contadorNum = 1
	(6-linha).times do
		print "#{contadorNum} "
		contadorNum += 1
	end

	linha += 1
	puts ""
end



puts "\n(c)"

linha = 1

5.times do
	contadorNum = 1
	linha.times do
		print "#{linha} "
	end

	linha += 1
	puts ""
end