puts "*"*50
puts "Fibo"
puts "*"*50

print "N�mero de elementos: "
numElem = gets.to_i

puts "\nSequ�ncia" 

def fibo(n)
	retorno = [0, 1]

	2.upto(n-1) {
		|cont|
		retorno << retorno[cont-1] + retorno[cont-2]
	}
	if n == 0
		return 
	end
	return retorno[0..n-1]
end

puts fibo(numElem)