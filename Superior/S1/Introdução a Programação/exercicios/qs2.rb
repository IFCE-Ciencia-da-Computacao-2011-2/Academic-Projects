=begin
Raiz quadrada
=end

puts "*"*50
puts "Calcula Raiz Quadrada"
puts "*"*50

puts ""
puts "ax² + bx + c = 0"
puts ""

puts "ENTRADA:"
print " Digite a: "
 a = gets.to_i

print " Digite b: "
 b = gets.to_i

print " Digite c: "
 c = gets.to_i

puts "\n"
puts "#{a}x² + #{b}x + #{c} = 0\n"
puts "\n"

delta = (b**2)-(4*a*c)

if delta < 0
	puts "Não existe solução no conjunto dos reais"
	return
end

x1 = (-b+Math.sqrt(delta))/(2*a)
x2 = (-b-Math.sqrt(delta))/(2*a)


puts " S = {#{x1}, #{x2}}"
