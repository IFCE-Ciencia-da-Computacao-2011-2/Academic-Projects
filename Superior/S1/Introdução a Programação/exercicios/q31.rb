puts "*"*50
puts "Total de pessoas acima de 18 anos com estatura acima de 1,60 m"
puts "*"*50

total = 0
contador = 1

puts "\n1° Pessoa "
print " - Idade: "
idade = gets.to_i

begin
    if idade >= 18
        print " - Tamanho: "
        if gets.to_f > 1.6 
            total += 1
        end
    else
        puts " PESSOA IGNORADA "
    end

    contador += 1

    puts "#{contador}° Pessoa "
    print " - Idade: "

    idade = gets.to_i
end while idade > 0


puts "\n #{total} pessoas possuem estatura acima de 1,60m"