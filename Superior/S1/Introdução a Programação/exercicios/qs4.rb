puts "*"*50
puts "Fatorial de n"
puts "*"*50

print " Digite n: "
n = gets.to_i

def fatorial(n)	
	if n == 1
		return 1
	end

	return n * fatorial(n-1)
end

puts " #{n}! = #{fatorial(n)}"

=begin
for um in 0 .. 9
	for dois in 0 .. 9
		puts "#{um} x #{dois}"
	end
	puts ""
=end
