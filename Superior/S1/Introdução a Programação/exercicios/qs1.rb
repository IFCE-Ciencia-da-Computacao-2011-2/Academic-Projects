=begin
Questão surpresa:
 Entrada: hora e minuto do início do jogo
 Saída  : hora e minuto do término do jogo

 Descubra: Quanto tempo durou o jogo
           (h, m)
=end

puts "*"*50
puts "Tempo de jogo"
puts "*"*50

inicial = []
final   = []

puts "ENTRADA:"
print " Hora de entrada: "
 inicial[0] = gets.to_i
print " Minuto de entrada: "
 inicial[1] = gets.to_i

puts "\nSAIDA:"
print " Hora de saída: "
 final[0] = gets.to_i
print " Minuto de saída: "
 final[1] = gets.to_i


def diferenca(horaInicial, horaFinal)
    if horaInicial[0] > horaFinal[0]
        horaFinal[0] += 24
    end

    horaInicial = horaInicial[0]*60 + horaInicial[1]
    horaFinal   = horaFinal[0]*60   + horaFinal[1]

    diferenca = horaFinal - horaInicial

    retorno = []	 
    retorno[0] = diferenca/60
	 retorno[1] = diferenca%60

    return retorno
end

dif = diferenca(inicial, final)

puts "Tempo de duração do jogo: #{dif[0]}h #{dif[1]}m"
