puts "*"*50
puts "Seqüência de frações"
puts "*"*50

def calcFracoes(n)
	soma = 0

	ultNumerador   = 2
	ultDenominador = 1
	penDenominador = 1

	for cont in 0...n

		soma += ultNumerador/(ultDenominador*1.0)

		puts " Resultado += #{ultNumerador}/#{ultDenominador}"

		ultNumerador = ultNumerador+ultDenominador
		penDenominador, ultDenominador = ultDenominador, ultDenominador+penDenominador
	end

	return soma
end


print " Digite a quantidade de termos: "
nTermos = gets.to_i

puts "\n\n"
puts "Resultado: #{calcFracoes(nTermos)}"
