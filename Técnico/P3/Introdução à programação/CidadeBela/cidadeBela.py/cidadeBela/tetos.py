#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import math
import random
import turtle

from cidadeBela.cores      import cores
from cidadeBela.matematica import matematica

class tetos(object):

    # Iniciador
    def __init__(self):
        # Variáveis globais
        self.tetosHotel = ['teto0', 'teto1']
        self.tetosCasa  = ['teto0', 'teto2']
        self.tetosLoja  = ['teto0']
        self.tetosTodas = ['teto0', 'teto1', 'teto2']


        # Nome da tartaruga controladora
        self.turtle = turtle.getturtle()

    def tetos(self, tipoPredio=""):
        """
        Desc:
        Retorna uma lista contendo os tetos disponíveis de um determinado prédio

        tipoPredio = String: "hotel", "casa" ou "loja"

        Envia: List
        """

        if tipoPredio == 'hotel':
            return self.tetosHotel

        elif tipoPredio == 'casa':
            return self.tetosCasa

        elif tipoPredio == 'loja':
            return self.tetosLoja

        else:
            return self.tetosTodas

    # Tetos
    def teto0(self, a=50, l=50, p=50, cor='255255255'):
        """
        Desc:
        Desenha um teto

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        """

        self.turtle.left(90)

        self._cor = cores.clarearDEC2HEX(20, cor)

        self.turtle.color("black", self._cor)
        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.right(135)
            self.turtle.forward(p)
            self.turtle.right(45)
            self.turtle.forward(l)

        self.turtle.end_fill()


        self.turtle.right(90)

    def teto1(self, a=50, l=50, p=50, cor='255255255'):
        """
        Desc:
        Desenha um teto

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        """

        # Pegar posição inicial do teto
        self._posIni = self.turtle.pos()

        # Cores
        self._cor0 = cores.clarearDEC2HEX(0, cor)
        self._cor1 = cores.clarearDEC2HEX(20, cor)
        self._cor2 = cores.escurecerDEC2HEX(20, cor)

        # Desenhando
        self.turtle.left(90)

        self.turtle.color("black", self._cor1)
        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.right(135)
            self.turtle.forward(p)
            self.turtle.right(45)
            self.turtle.forward(l)

        self.turtle.end_fill()

        # Fazer quadrado interno
        self.turtle.penup()

        self._distancia = int(a*10/100)

        self.turtle.right(135)
        self.turtle.forward(p)

        self.turtle.right(45)
        self.turtle.forward(self._distancia)
        self.turtle.right(135)
        self.turtle.forward(self._distancia)

        self.turtle.left(135)

        self.turtle.pendown()

        for x in range(2):
            self.turtle.forward(l-self._distancia*2)
            self.turtle.right(135)
            self.turtle.forward(p-self._distancia*2)
            self.turtle.right(45)

        # Fazer descida
        #  Tras

        self.turtle.color("black", self._cor0)
        self.turtle.begin_fill()

        self.turtle.right(90)
        self.turtle.forward(self._distancia)

        self.turtle.left(90)
        self.turtle.forward(l-self._distancia*3)

        self.turtle.left(45)
        self.turtle.forward(self._distancia/matematica.sen(45))

        self.turtle.right(45)
        self.turtle.backward(l-self._distancia*2)

        self.turtle.end_fill()

        #  Lado
        self.turtle.color("black", self._cor2)
        self.turtle.begin_fill()

        self.turtle.right(90)
        self.turtle.forward(self._distancia)

        self.turtle.right(45)
        self.turtle.forward(p-self._distancia*3.5)

        self.turtle.right(45)
        self.turtle.forward(self._distancia)

        self.turtle.right(135)
        self.turtle.forward(p-self._distancia*2)

        self.turtle.end_fill()

        # Voltando a posição inicial
        self.turtle.left(45)

        self.turtle.penup()
        self.turtle.setpos(self._posIni)
        self.turtle.pendown()

    def teto2(self, a=50, l=50, p=50, cor='255255255'):
        """
        Desc:
        Desenha um teto

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        """

        # Triângulo da frente
        self.turtle.color("black", cores.clarearDEC2HEX (0, cor))
        self.turtle.begin_fill()

        self.turtle.right(90-35)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.right(180-110)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.right(145)
        self.turtle.forward(l)

        self.turtle.end_fill()

        self.turtle.pencolor(cores.clarearDEC2HEX(0, cor))
        self.turtle.backward(l)
        self.turtle.forward(l)

        # Triângulo da esquerda
        self.turtle.color("black", cores.clarearDEC2HEX(20, "255000000") )
        self.turtle.begin_fill()

        self.turtle.right(180-45)
        self.turtle.forward(p)

        self.turtle.right(10)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.right(170)
        self.turtle.forward(p)

        self.turtle.right(10)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.end_fill()

        self.turtle.right(35+90)

        # Triângulo da direita
        #  Se posicionando
        self.turtle.right(90)

        self.turtle.penup()
        self.turtle.forward(l)
        self.turtle.pendown()

        #  Começo
        self.turtle.color("black", cores.escurecerDEC2HEX(20, "255000000") )
        self.turtle.begin_fill()

        self.turtle.left(45)
        self.turtle.forward(p)

        self.turtle.left(100)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.left(80)
        self.turtle.forward(p)

        self.turtle.left(100)
        self.turtle.forward(l/2/matematica.cos(35))

        self.turtle.end_fill()

        #  Voltando a posição inicial
        self.turtle.penup()
        self.turtle.left(35)
        self.turtle.backward(l)
        self.turtle.left(90)
        self.turtle.pendown()

        self.turtle.pencolor("black")

    def teto3(self, a=50, l=50, p=50, cor="255255255"):
        """
        Desc:
        Desenha um teto

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        """

        # Base do teto
        self.teto0(a, l, p, cor)

        # Desenhando Heliporto
        #  Calculado distância entre vertices
        self._lParte   = matematica.sen(45)*p
        self._lCompleto= l+self._lParte

        self._tamanho = (math.sqrt(self._lParte**2+self._lCompleto**2))/10


        #  Se posicionando
        """
        self.turtle.penup()
        self.turtle.right(90)
        self.turtle.forward(l/10)
        self.turtle.right(-90)
        self.turtle.forward(matematica.sen(45)*p/10)
        self.turtle.pendown()

        self.turtle.right(90)

        # Desenhando
        for a in range(2):
            self.turtle.forward(l*4/5)
            self.turtle.left(45)
            self.turtle.forward(p*4/5)
            self.turtle.left(90+45)
        """
        self.turtle.penup()
        self.turtle.right(135/2)
        self.turtle.forward(self._tamanho)
        self.turtle.left(135/2)
        self.turtle.pendown()

        self.turtle.right(90)

        for c in range(2):
            # Usando Lei dos Senos
            self.turtle.forward(l - (matematica.sen(67.5)*self._tamanho)/matematica.sen(45) )
            self.turtle.left(45)

            self.turtle.forward(p - (matematica.sen(67.5)*self._tamanho)/matematica.sen(45) )
            self.turtle.left(90+45)
        """
        self.turtle.right(180-45)
        self.turtle.pensize(3)
        self.turtle.circle(int(p/4))
        self.turtle.pensize(1)
        self.turtle.right(-(180-45))
        """

tetos = tetos()
"""
self.turtle.left(90)
tetos.teto3(50, 200, 100)
self.turtle.mainloop()
"""