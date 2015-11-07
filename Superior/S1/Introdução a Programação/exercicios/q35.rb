puts "*"*50
puts "Sqrt"
puts "*"*50


def sqrt(numero)

	palpite = 1

	for cont in 0...1000000
		# palpite = media(numero/palpite + palpite)
		palpite = (numero/(palpite*1.0)+palpite)/2.0
	end

	return palpite
end


print " Digite o número a ser obtido a raiz quadrada: "
numero = gets.to_i

puts "\n\n"
puts "Resultado:         #{sqrt(numero)}"
puts "Resultado do Ruby: #{numero**0.5}"
