puts "*"*50
puts "Votos no cinema"
puts "*"*50

CAPACIDADE = 2

votos = [[], [], [], [], []];


for idPessoa in (1..CAPACIDADE)
    puts "-"*20
    puts "Pesquisa de opinião:"
    puts "-"*20
    puts "\n"

    print "Idade: "
    idade = gets.to_i

    while true:
        puts "\nOpinião a respeito do filme"
        puts "Opções: "
        puts " A - Ótimo"
        puts " B - Bom"
        puts " C - Regular"
        puts " D - Ruim"
        puts " E - Péssimo"

        print "\nNota: "
        nota = gets.to_s

        if nota[0] < 65 || nota[0] > 69 # De A até E
            puts "Opção Inválida!"
        else
				votos[nota[0]-65] << idade
            puts "Voto computado com sucesso"
	         break
        end
    end
end

puts "\a\a\a\a"
puts "\n\n"

# "Sobrecarga de método?"
class Array
    def sum
		inject(0.0) { |result, el| result + el }
    end

    def media
      size != 0 ? sum / size : 0
    end

   def max
		inject(0.0) { |result, el| result + el }
    end
end

puts "1. Quantidade de respostas ótimo"
puts " #{votos[0].length} votos ótimo"

puts "2. Diferença entre respostas bom e regular"
puts " #{votos[1].length - votos[2].length}"

puts "3. Média de idade das pessoas que responderam ruim"
puts " Média: #{votos[3].media}"


soma = votos[0].sum + votos[1].sum + votos[2].sum + 
	    votos[3].sum + votos[4].sum
percentagem = 0

if votos[4].length != 0
	percentagem = (votos[4].sum) *100 / (soma * 1.0)	
end

puts "4. A porcentagem de respostas péssimo e a maior idade que escolheu essa opção"
puts " Porcentagem: #{percentagem}"
if votos[4].length != 0
	puts " Maior idade: #{votos[4].sort[-1]}"
else
	puts " Sem votos para esta opção"
end

puts "5. Diferença de idade entre a maior idade que respondeu ótimo e a maior idade que respondeu ruim"
aMaisVelho = votos[0].length == 0 ? 0 : votos[0].sort[-1]
dMaisVelho = votos[3].length == 0 ? 0 : votos[3].sort[-1]

diferenca = aMaisVelho - dMaisVelho

puts " Diferença de idade: #{diferenca}"
