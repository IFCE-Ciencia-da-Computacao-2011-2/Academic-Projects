=begin
Raiz quadrada
=end

puts "*"*50
puts "Tabuada de N"
puts "*"*50

print " Digite n: "
n = gets.to_i

for um in 0 .. 10
	puts "#{n} x #{um} = #{n * um}"
end

=begin
for um in 0 .. 9
	for dois in 0 .. 9
		puts "#{um} x #{dois}"
	end
	puts ""
=end
