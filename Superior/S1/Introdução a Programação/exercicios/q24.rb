puts <<COD
a = gets.to_i
b = gets.to_i
soma = 0
while a<b
	soma = soma + a**2
	a = a+1
end

COD

puts "*"*50
puts "Reescreva o c�digo acima usando somente..."
puts "*"*50

print "a: "
a = gets.to_i
aOrig = a

print "b: "
b = gets.to_i
bOrig = b

##########################
puts "\n -> While "
##########################
a = aOrig
b = bOrig

soma = 0
while a<b
	soma = soma + a**2
	a = a+1
end

puts "Soma = " << soma.to_s


##########################
puts "\n -> TIMES "
##########################
a = aOrig
b = bOrig

soma = 0

# Na pior das situa��es, o n�mero de repeti��o seria
# b-a + 1
# Na verdade � ainda menos por causa do a^2

if b>a
	b.times do # Aqui manda repetir b vezes
		soma = soma + a**2
		a = a+1
		# Mas n�o tem problema, j� que ele s� vai repetir at� a >= b
		if a >= b
			break
		end
	end
end

puts "Soma = " << soma.to_s


##########################
puts "\n -> UPTO "
##########################
a = aOrig
b = bOrig

soma = 0

# Na pior das situa��es, o n�mero de repeti��o seria
# b-a + 1
# Na verdade � ainda menos por causa do a^2

if b>a
	0.upto(b) { # Aqui manda repetir b vezes
		soma = soma + a**2
		a = a+1
		# Mas n�o tem problema, j� que ele s� vai repetir at� a >= b
		if a >= b
			break
		end
	}
end

puts "Soma = " << soma.to_s


##########################
puts "\n -> DOWNTO "
##########################
a = aOrig
b = bOrig

soma = 0

# Na pior das situa��es, o n�mero de repeti��o seria
# b-a + 1
# Na verdade � ainda menos por causa do a^2

if b>a
	b.downto(0) { # Aqui manda repetir b vezes
		soma = soma + a**2
		a = a+1
		# Mas n�o tem problema, j� que ele s� vai repetir at� a >= b
		if a >= b
			break
		end
	}
end

puts "Soma = " << soma.to_s