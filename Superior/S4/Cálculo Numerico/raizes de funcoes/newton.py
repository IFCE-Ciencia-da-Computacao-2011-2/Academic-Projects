# NEWTON
import math

def f(x):
    return math.cos(x) + 1

## f' = derivada
def f1(x):
    return - math.sin(x)

def iniciar(x0, precisao):
    iteracao = 1

    Xi_anterior = x0
    Xi = Xi_anterior - f(Xi_anterior)/f1(Xi_anterior)

    print("{0:^10}|{1:^22}|{2:^22}|{3:^20}".format("iteracao", "Xi", "f(Xi)", "|Xi - Xi-1|"))
    print("{0:^10}|{1:22}|{2:22e}|{3:20e}".format(iteracao, Xi, f(Xi), abs(Xi - Xi_anterior)))

    while not (f(Xi) < precisao):
        Xi_anterior = Xi
        Xi = Xi_anterior - f(Xi_anterior)/f1(Xi_anterior)
        
        iteracao += 1
        
        print("{0:^10}|{1:22}|{2:22e}|{3:20e}".format(iteracao, Xi, f(Xi), abs(Xi - Xi_anterior)))
        
        if (iteracao > 15): break


iniciar(x0 = 3, precisao = 10**-7)
