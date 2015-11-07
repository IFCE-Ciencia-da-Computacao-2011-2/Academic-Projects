puts "*"*50
puts "Fibo"
puts "*"*50

print " Digite a quantidade de elementos: "
n = gets.to_i

anterior = 0
proximo = 1

for pos in 1 .. n
	puts proximo

	anterior, proximo = proximo, anterior + proximo
end

=begin
for um in 0 .. 9
	for dois in 0 .. 9
		puts "#{um} x #{dois}"
	end
	puts ""
=end
