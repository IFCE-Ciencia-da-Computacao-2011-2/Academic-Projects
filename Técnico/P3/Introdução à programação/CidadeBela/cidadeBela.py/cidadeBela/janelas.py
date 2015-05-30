#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import math
import random
import turtle

from cidadeBela.cores      import cores
from cidadeBela.matematica import matematica

class janelas(object):

    # Iniciador
    def __init__(self):
        # Definindo variáveis globais
        self.janelasHotel = ['janela8', 'janela9', 'janela10']
        self.janelasCasa  = ['janela0', 'janela1', 'janela2', 'janela3', 'janela4',
                             'janela5', 'janela6', 'janela7', 'janela10']
        self.janelasLoja  = ['janela0']
        self.janelasTodas = ['janela0', 'janela1', 'janela2', 'janela3', 'janela4',
                             'janela5', 'janela6', 'janela7', 'janela8', 'janela9',
                             'janela10']

        # Nome da tartaruga controladora
        self.turtle = turtle.getturtle()

    def janelas(self, tipoPredio=""):
        """
        Desc:
        Retorna uma lista contendo as janelas disponíveis de um determinado prédio

        tipoPredio = String: "hotel", "casa" ou "loja"

        Envia: List
        """

        """
        -> Listar os módulos desejados
        self.retornador = []
        #dir(portas) lista todos os mótodos
        for a in dir(portas):
            if a[0] != "_" and a[1] != "_" and a[-1] != "_" and a[-2] != "_":
                self.retornador.append(a)
        print(self.retornador)
        """

        if tipoPredio == "hotel":
            return self.janelasHotel

        elif tipoPredio == "casa":
            return self.janelasCasa

        elif tipoPredio == "loja":
            return self.janelasLoja

        else:
            return self.janelasTodas



    # Janelas
    def janela0(self, tamanho=60, angulo=0, cor="#E2F4FC"):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        angulo = Int: ângulo de inclinamento do eixo x (para pseudo z)
        """

        turtle.left(angulo)
        self.turtle.backward(tamanho/2)

        self.turtle.color("black", cor)
        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.forward(tamanho)
            self.turtle.left(90-angulo)
            self.turtle.forward(tamanho)
            self.turtle.left(90+angulo)
        self.turtle.end_fill()

        self.turtle.forward(tamanho/2)
        self.turtle.right(angulo)

    def janela1(self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """
        self._posAt = self.turtle.pos()

        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)

        #self.turtle.pensize(2)
        self.turtle.color("#838B83", "#87CEEB")
        self.turtle.begin_fill()

        for a in range (4):
            self.turtle.forward(tamanho)
            self.turtle.left(90)

        self.turtle.end_fill()

        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.backward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.backward(tamanho)
        self.turtle.forward(tamanho)
        self.turtle.penup()
        self.turtle.setpos(self._posAt)
        self.turtle.pendown()
        self.turtle.left(180)

        #self.turtle.pensize(1)

    def janela2(self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """
        self._posAt = self.turtle.pos()

        #self.turtle.pensize(2)
        self.turtle.color("#8B8B7A", "#FFC1C1")
        self.turtle.begin_fill()
        self.turtle.circle(tamanho/2)
        self.turtle.end_fill()
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.backward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.backward(tamanho)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.setpos(self._posAt)
        self.turtle.pendown()
        self.turtle.left(180)

        #self.turtle.pensize(1)

    def janela3(self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """
        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)

        #self.turtle.pensize(2)
        self.turtle.color("#8B864E", "#BFEFFF")
        self.turtle.begin_fill()
        for a in range(4):
            self.turtle.forward(tamanho)
            self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#8B864E", "#8B5A2B")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.end_fill()
        self.turtle.backward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.color("#8B864E", "#8B5A2B")
        self.turtle.begin_fill()
        self.turtle.backward(tamanho/3)
        self.turtle.right(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.end_fill()
        self.turtle.backward(tamanho)

        #Retornando para a janela ficar no meio
        self.turtle.forward(tamanho/2)

    def janela4 (self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """
        posAt = self.turtle.pos()

        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)
        #self.turtle.pensize(2)

        self.turtle.color("#1C1C1C", "#00E5EE")
        self.turtle.begin_fill()
        for a in range (4):
            self.turtle.forward(tamanho)
            self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#1C1C1C", "#8B3E2F")
        self.turtle.begin_fill()
        self.turtle.left(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.end_fill()
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.right(180)
        self.turtle.color("#1C1C1C", "#8B3E2F")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.end_fill()
        self.turtle.penup()

        self.turtle.setpos(posAt)
        self.turtle.left(90)
        self.turtle.backward(tamanho/2)
        self.turtle.right(90)

        self.turtle.pendown()
        self.turtle.left(90)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.color("#1C1C1C", "#8B3E2F")
        self.turtle.begin_fill()
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.backward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.right(90)
        self.turtle.end_fill()
        self.turtle.forward(tamanho)
        self.turtle.color("#1C1C1C", "#8B3E2F")
        self.turtle.begin_fill()
        ## self.turtle.backward(tamanho/2-1)
        self.turtle.right(180)
        self.turtle.forward(tamanho/2-tamanho/50)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2-tamanho/16.5)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2-tamanho/50)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.setpos(posAt)
        self.turtle.pendown()


    def janela5 (self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """

        #self.turtle.pensize(3)
        posAt = self.turtle.pos()

        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)

        self.turtle.color("#7A378B", "#8B008B")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#9A32CD", "#D15FEE")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#9A32CD", "#FFBBFF")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.color("#9A32CD", "#D15FEE")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#9A32CD", "#FFBBFF")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.setpos(posAt)
        self.turtle.pendown()
        self.turtle.left(180)

        self.turtle.pencolor("black")

    def janela6(self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """

        #self.turtle.pensize(3)
        posAt = self.turtle.pos()

        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)

        self.turtle.color("#8B4513", "#8B7765")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.color("#8B4513", "#CDB38B")
        self.turtle.begin_fill()
        self.turtle.forward(tamanho-tamanho/10)
        self.turtle.left(90)
        self.turtle.forward(tamanho-tamanho/10)
        self.turtle.left(90)
        self.turtle.forward(tamanho-tamanho/10)
        self.turtle.left(90)
        self.turtle.forward(tamanho-tamanho/10)
        self.turtle.left(90)
        self.turtle.end_fill()
        self.turtle.left(90)
        self.turtle.forward(tamanho/3)
        self.turtle.right(90)
        self.turtle.penup()
        self.turtle.forward(tamanho/10)
        self.turtle.pendown()
        self.turtle.color("#8B4513", "#8B4513")
        self.turtle.begin_fill()
        self.turtle.circle(tamanho/10)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.setpos(posAt)

    def janela7(self, tamanho=60):
        """
        Desc:
        Desenha uma janela

        tamanho   = Int: tamanho (tamanho x tamanho)
        """

        #self.turtle.pensize(3)
        posAt = self.turtle.pos()

        #Recuando para a janela ficar no meio
        self.turtle.backward(tamanho/2)

        #self.turtle.pensize(2)
        self.turtle.color("#A0522D", "#DEB887")

        self.turtle.begin_fill()
        for a in range (4):
            self.turtle.forward(tamanho)
            self.turtle.left(90)
        self.turtle.end_fill()

        self.turtle.forward(tamanho/2)
        self.turtle.left(90)
        self.turtle.forward(tamanho)
        self.turtle.backward(tamanho/2 - tamanho/12.5)

        self.turtle.penup()
        self.turtle.left(90)
        self.turtle.forward(tamanho/6)
        self.turtle.pendown()
        self.turtle.color("#A0522D", "#8B4513")
        self.turtle.begin_fill()
        self.turtle.circle(tamanho/10)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.left(90)
        self.turtle.forward( tamanho/5 )
        self.turtle.left(90)
        self.turtle.forward( tamanho/3.125 )
        self.turtle.pendown()
        self.turtle.color("#A0522D", "#8B4513")
        self.turtle.begin_fill()
        self.turtle.circle(tamanho/10)
        self.turtle.end_fill()
        self.turtle.penup()
        self.turtle.setpos(posAt)

    def janela8(self, tamanho=60, angulo=0):
        """
        Desc:
        Desenha uma janela para HOTEL

        tamanho  = List: tamanho [tamanhoA x tamanhoL]
        angulo   = Int: ângulo de inclinamento do eixo x (para pseudo z)
        """
        # Caso coloquem essa janela em casas...
        if len(list(tamanho)) == 1:
            tamanhoL = tamanho
            tamanhoA = tamanhoL
        else:
            tamanhoA = tamanho[0]*55/100
            tamanhoL = tamanho[1]*85/100

        self.turtle.backward(tamanhoL/2)

        if angulo != 0:
            self.turtle.color( cores.escurecerDEC2HEX(20, "148233252"), cores.escurecerDEC2HEX(20, "210247255") )
        else:
            self.turtle.color("#94E9FC", "#D2F7FF")

        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.forward(tamanhoL)
            self.turtle.left(90-angulo)
            self.turtle.forward(tamanhoA)
            self.turtle.left(90+angulo)

        self.turtle.end_fill()

        self.turtle.forward(tamanhoL/2)

        self.turtle.pencolor("black")

    def janela9(self, tamanho=1, angulo=0):
        """
        Desc:
        Desenha uma janela para HOTEL

        tamanho  = List: tamanho [tamanhoA x tamanhoL]
        angulo   = Int: ângulo de inclinamento do eixo x (para pseudo z)
        """
        # Caso coloquem essa janela em casas...
        if len(list(tamanho)) == 1:
            tamanhoL = tamanho
            tamanhoA = tamanhoL
        else:
            tamanhoA = tamanho[0]*55/100
            tamanhoL = tamanho[1]*85/100


        # Pegando o número de janelinhas
        self._tamJanela = tamanhoL/2*85/100
        self._janY  = int (tamanhoA / self._tamJanela )
        self._resto = tamanhoA - (tamanhoL/2*85/100)*self._janY


        # Posicionando tat
        self.turtle.penup()
        self.turtle.backward(tamanhoL/2)
        self.turtle.pendown()


        # Cores
        if angulo != 0:
            self.turtle.color( cores.escurecerDEC2HEX(20, "148233252"), cores.escurecerDEC2HEX(20, "210247255") )
        else:
            self.turtle.color("#94E9FC", "#D2F7FF")



        # Desenhando janelas pelo eixo x
        for a in range(self._janY):
            # Subindo
            self.turtle.penup()
            self.turtle.left(90 - angulo)
            self.turtle.forward( self._resto / (self._janY*2) )
            self.turtle.right(90 - angulo)
            self.turtle.pendown()

            # Indo para trás
            self.turtle.penup()
            self.turtle.forward(tamanhoL/4)
            self.turtle.pendown()

            # Desenhando as janelas
            self.turtle.right(angulo)
            if angulo != 0:
                self.janela0(self._tamJanela, angulo, cor=cores.escurecerDEC2HEX(20, '226244252'))
            else:
                self.janela0(self._tamJanela, angulo)
            self.turtle.left(angulo)

            self.turtle.penup()
            self.turtle.forward(tamanhoL/2)
            self.turtle.pendown()

            self.turtle.right(angulo)
            if angulo != 0:
                self.janela0(self._tamJanela, angulo, cor=cores.escurecerDEC2HEX(20, '226244252'))
            else:
                self.janela0(self._tamJanela, angulo)
            self.turtle.left(angulo)


            # Subindo
            self.turtle.penup()
            self.turtle.left(90 - angulo)
            self.turtle.forward( (self._resto / (self._janY*2) ) + self._tamJanela)
            self.turtle.right(90 - angulo)
            self.turtle.pendown()

            self.turtle.penup()
            self.turtle.backward(tamanhoL/2+tamanhoL/4)
            self.turtle.pendown()



        # Posicionando tat
        self.turtle.penup()
        self.turtle.forward(tamanhoL/2)

        self.turtle.left(90 - angulo)
        self.turtle.backward( self._janY * (self._resto/self._janY  + self._tamJanela) )
        self.turtle.right(90 - angulo)
        self.turtle.pendown()

        self.turtle.pencolor("black")

    def janela10(self, tamanho=0, angulo=0):
        """
        Desc:
        Não desenha uma janela
        """

janelas = janelas()