puts "*"*50
puts "Cálculo do S"
puts "*"*50

resultado = 0

for dividendo in (1..10)
	resultado += dividendo%2==0 ? -dividendo/dividendo**2 : dividendo/dividendo**2
end

puts resultado