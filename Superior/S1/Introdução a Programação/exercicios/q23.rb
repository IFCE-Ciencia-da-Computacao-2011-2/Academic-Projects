puts "*"*50
puts "Fatorial de um número inteiro positivo"
puts "*"*50

print "Inteiro a ser tirado fatorial: "
inteiro = gets.to_i

def fatorial(n)
	if n == 1
		return 1
	end

	return n * fatorial(n-1)
end

puts "\n #{inteiro}! = #{fatorial(inteiro)}"