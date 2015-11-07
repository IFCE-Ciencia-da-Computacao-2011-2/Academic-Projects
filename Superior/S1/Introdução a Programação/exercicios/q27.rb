puts "*"*50
puts "Soma dos inteiros de 1 a n"
puts "*"*50

print "Número inteiro qualquer: "
num = gets.to_i

total = 0
# Total vai receber total+1 (total+1)
#  e 
# num vai ser decrementado 1 (num-1)
#  toda vez
# até que (until)
# num seja igual a 0 (Condição: num==0)
total, num = total+num, num - 1 until num == 0

# Obs, assim que num dá zero, pára
# ou seja, total é soma a 0

puts total