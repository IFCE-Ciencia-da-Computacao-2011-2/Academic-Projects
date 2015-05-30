#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import math
import random

class matematica(object):

    # Iniciador
    def __init__(self):
        # \o/
        encherLinguica = True

    # Angulos
    def sen(self, angulo):
        """
        Desc:
        Retorna o seno de um ângulo em GRAUS

        numero = Float

        Envia: Float
        """
        return math.sin(math.radians(angulo))

    def cos(self, angulo):
        """
        Desc:
        Retorna o cosseno de um ângulo em GRAUS

        numero = Float

        Envia: Float
        """
        return math.cos(math.radians(angulo))

    def tan(self, angulo):
        """
        Desc:
        Retorna a tangente de um ângulo em GRAUS

        numero = Float

        Envia: Float
        """
        return math.tan(math.radians(angulo))


    # Números Racionais
    def modulo(self, numero):
        """
        Desc:
        Retorna o módulo do parâmetro numero

        numero = Float

        Envia: Float
        """

        if numero < 0:
            return - numero
        else:
            return numero

    def eNegativo(self, numero):
        """
        Desc:
        Função que verifica se o número dado é negativo

        numero = Float

        Envia: Boolean: True ou False
        """

        if numero < 0:
            return True
        else:
            return False

    def ePositivo(self, numero):
        """
        Desc:
        Função que verifica se o número dado é positivo

        numero = Float

        Envia: Boolean: True ou False
        """

        if numero > 0:
            return True
        else:
            return False

    # Sorteios
    def sortearPeso(self, lista):
        """
        Desc:
        Retorna um elemento sorteado

        lista = List: [(String, Boolean ou Int)], Int: Peso]

        Envia: Boolean: True ou False

        Exemplo:
        matematica.sortearPeso([["bola", 2], ["quadrado", 3]])
        Envia:
        (2/5 chances de enviar "bola" e 3/5 chances de enviar "quadrado")
        """

        # Contar o número de truplas dentro de lista
        self._numListas = len(lista)

        # Somar o número de possibilidades (total de pesos)
        self._totalPesos = 0
        for elemento in lista:
            self._totalPesos = elemento[1] + self._totalPesos

        # Sorteando um elemento
        self._elemSorteado = random.randint(1, self._totalPesos)

        # Verificando a que trupla pertence o elemento sorteado
        self._truplaSorteada = 0

        for numElem in range(self._numListas):
            if (self._elemSorteado > lista[numElem][1]):
                self._totalPesos   = self._totalPesos - lista[numElem][1]
                self._elemSorteado = self._elemSorteado - lista[numElem][1]
                continue
            else:
                self._truplaSorteada = numElem
                break

        return lista[self._truplaSorteada][0]

matematica = matematica()