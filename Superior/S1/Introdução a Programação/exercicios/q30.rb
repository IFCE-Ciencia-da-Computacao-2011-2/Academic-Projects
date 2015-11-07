puts "*"*50
puts "Eleição"
puts "*"*50

TOTAL_VOTOS = 5

# Pegar valores
votos = [0, 0, 0, 0, 0]

for idPessoa in (1..TOTAL_VOTOS)
    puts "\a"*2
    while true:
        puts "Opções: "
        puts " 1 - Ricardo Guedes (chapa 1)"
        puts " 2 - Ronaldo Framos (chapa 2)"
        puts " 3 - Carlos Alberto Pacheco Pereira (chapa 3)"

        puts "\n 0 - Branco"
        puts " 4 - Nulo"

        print "\nVoto: "
        voto = gets.to_i

        if voto < 0 || voto > 4
            puts "Opção Inválida!"
        else
            break
        end
    end
    votos[voto] += 1

    puts "\n Voto computado com sucesso"
    puts "\nPrecione ENTER para encerrar"
    gets
end


# Resultado
puts "\a"*10

puts "*"*50
puts "Resultado da eleição"
puts "*"*50

puts"\n  TOTAL          CHAPA"
puts"-----------------------------"
puts "    #{votos[1]}          (chapa 1)"
puts "    #{votos[2]}          (chapa 2)"
puts "    #{votos[3]}          (chapa 3)"

puts "\n    #{votos[0]}          Branco"
puts "    #{votos[4]}          Nulo"


print "\n\n Total de votos válidos: #{votos[1]+votos[2]+votos[3]}" 
print "\n Total de votos não válidos (brancos e nulos): #{votos[0]+votos[4]}"


puts "\n\n"


# Descobrir posição do maior a lá ordenamento
posMaior = 1
votosDosPerdedores = 0
for pos in (1..2)
    if votos[pos] < votos[pos+1]
        posMaior = pos+1
        votosDosPerdedores += votos[pos]
    else
        votosDosPerdedores += votos[pos+1]
    end
end


# Verificar se o ganhador possui mais de 50% dos votos

percentagem = votos[posMaior]*100/(votosDosPerdedores+votos[posMaior])

puts "Chapa ganhadora do 1° turno"
puts " Chapa #{posMaior} - #{votos[posMaior]} votos - #{percentagem}% dos votos válidos"

puts ""
if votosDosPerdedores < votos[posMaior]
    puts "Não será necessário a realização do 2° turno"
else
    puts "Será necessário a realização do 2° turno para terminar a eleição"
end