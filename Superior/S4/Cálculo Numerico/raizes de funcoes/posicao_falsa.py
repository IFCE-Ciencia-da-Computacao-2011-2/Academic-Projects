# POSICAO FALSA
# CONDICAO DE PARADA: |Xi - Xi_anterior| <= precisao
import math

def f(x):
    return x**3 - 9*x + 3

def iniciar(precisao, intervalo):
    print("Precisao: {0:e}".format(precisao))
    print("Intervalo:", intervalo)
    print("Total estimado de interacoes:", k(precisao, intervalo))
    print("")
    
    iteracao = 0
    diferenca = 1

    a, b = intervalo[0], intervalo[1]

    Xi_anterior = 999 # Valor qualquer
    Xi = Xk(a, b)

    print("{0:^10}|{1:^22}|{2:^22}|{3:^20}|{4:^22}|{5:^20}".format("iteracao", "An", "Bn", "Xi", "f(Xi)", "|Xi - Xi-1|"))
    print("{0:^10}|{1:22}|{2:22}|{3:20}|{4:22}|{5:20}".format(iteracao, a, b, Xi, f(Xi), ""))

    while abs(Xi - Xi_anterior) > precisao:
        if f(a)*f(Xi) > 0:
            a = Xi
        else:
            b = Xi

        Xi_anterior = Xi
        Xi = Xk(a, b)
        
        iteracao += 1
    
        print("{0:^10}|{1:22}|{2:22}|{3:20}|{4:22}|{5:20e}".format(iteracao, a, b, Xi, f(Xi), abs(Xi - Xi_anterior)))
        
        if (iteracao > 10):
            break


def Xk(a, b):
    return (a*f(b) - b*f(a)) / (f(b) - f(a))

def k(precisao, intervalo):
    a, b = intervalo[0], intervalo[1]
    return (math.log(a+b) - math.log(precisao))/math.log(2)

iniciar(precisao = 10**-2, intervalo = [0, 1])
