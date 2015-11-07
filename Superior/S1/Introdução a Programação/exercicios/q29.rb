puts "*"*50
puts "Soma dos pesos das pessoas com mais de 30 anos"
puts "*"*50

print "Total de pessoas: "
pessoas = gets.to_i

puts ""

pesoTotal = 0
for idPessoa in (1..pessoas)
    puts "#{idPessoa}° Pessoa "
    print " - Idade: "

    if gets.to_i > 30
        print " - Peso: " 
        pesoTotal += gets.to_f
        next
    end
    
    puts " PESSOA IGNORADA " 
end

puts "\nO somatório do peso das pessoas maiores de 30 anos é de:"
puts " #{pesoTotal} kg"