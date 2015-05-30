#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import math
import random
import turtle

from cidadeBela.cores      import cores
from cidadeBela.matematica import matematica

class portas(object):

    # Iniciador
    def __init__(self):
        # Variáveis globais
        self.portasHotel = ['porta0', 'porta1']
        self.portasCasa  = ['porta2', 'porta3', 'porta4', 'porta5',
                            'porta6', 'porta7', 'porta8', 'porta9']
        self.portasLoja  = ['porta2']
        self.portasTodas = ['porta0', 'porta1', 'porta2', 'porta3', 'porta4', 'porta5',
                            'porta6', 'porta7', 'porta8', 'porta9']

        # Nome da tartaruga controladora
        self.turtle = turtle.getturtle()

    def portas(self, tipoPredio=""):
        """
        Desc:
        Retorna uma lista contendo as portas disponíveis de um determinado prédio

        tipoPredio = String: "hotel", "casa" ou "loja"

        Envia: List
        """

        if tipoPredio == "hotel":
            return self.portasHotel

        elif tipoPredio == "casa":
            return self.portasCasa

        elif tipoPredio == "loja":
            return self.portasLoja

        else:
            return self.portasTodas



    # Portas
    def porta0(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x90)
        """

        self.turtle.color("black", "#D8EEFF")
        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.forward(44.5/prop)
            self.turtle.left(90)
            self.turtle.forward(100/prop)
            self.turtle.left(90)

        self.turtle.backward(44.5/prop)

        for x in range(2):
            self.turtle.forward(44.5/prop)
            self.turtle.left(90)
            self.turtle.forward(100/prop)
            self.turtle.left(90)

        self.turtle.forward(44.5/prop)

        self.turtle.end_fill()

    def porta1(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = (100 porta + 90 arco)x90)
        """

        self.turtle.color("black", "#D8EEFF")
        self.turtle.begin_fill()

        self._posIni = self.turtle.pos()

        # Porta1
        for x in range(2):
            self.turtle.forward(44.5/prop)
            self.turtle.left(90)
            self.turtle.forward(100/prop)
            self.turtle.left(90)

        # Porta2
        self.turtle.backward(44.5/prop)

        for x in range(2):
            self.turtle.forward(44.5/prop)
            self.turtle.left(90)
            self.turtle.forward(100/prop)
            self.turtle.left(90)

        self.turtle.end_fill()

        # Arco
        self.turtle.color("black", "#99D1FB")
        self.turtle.begin_fill()

        self.turtle.left(90)
        self.turtle.forward(100/prop)
        self.turtle.right(90)
        self.turtle.forward(2*44.5/prop)
        self.turtle.left(90)

        self.turtle.circle (44.5/prop, 180)

        self.turtle.end_fill()

        # Voltar para posição inicial
        self.turtle.left(90)

        self.turtle.penup()
        self.turtle.setpos(self._posIni)
        self.turtle.pendown()

    def porta2(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """

        # Porta
        self.turtle.backward(55/2/prop)


        self.turtle.color("black", "#A05C34")
        self.turtle.begin_fill()

        for x in range(2):
            self.turtle.forward(55/prop)
            self.turtle.left(90)
            self.turtle.forward(100/prop)
            self.turtle.left(90)

        self.turtle.end_fill()

        # Janela
        self.turtle.penup()
        self.turtle.left(90)
        self.turtle.forward(100/prop - 10/prop)
        self.turtle.right(90)
        self.turtle.forward(10/prop)
        self.turtle.right(90)

        self.turtle.pendown()


        self.turtle.color("#6B3D23", "#E2F4FC")
        self.turtle.begin_fill()
        for x in range(2):
            self.turtle.forward(65/prop)
            self.turtle.left(90)
            self.turtle.forward(35/prop)
            self.turtle.left(90)
        self.turtle.end_fill()

        self.turtle.color("black", "white")

        self.turtle.penup()
        self.turtle.left(90)
        self.turtle.backward(10/prop)
        self.turtle.left(90)
        self.turtle.backward(100/prop - 10/prop)
        self.turtle.right(90)

        self.turtle.pendown()
        self.turtle.forward(55/2/prop)

    def porta3(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """

        self.turtle.backward (30/prop)

        self._cor = cores.converterDEC2HEX(255, 68, 78)

        self.turtle.color("black", self._cor)
        self.turtle.begin_fill()


        self.turtle.forward (60/prop)
        self.turtle.left (90)
        self.turtle.forward (60/prop)
        self.turtle.left (135)
        self.turtle.forward (60/matematica.cos(45)/prop)


        self.turtle.end_fill()

    ###### PARTE DE BAIXO #####

        self._cor = cores.converterDEC2HEX ( 0, 255, 255)

        self.turtle.color ("black", self._cor)
        self.turtle.begin_fill()

        self.turtle.left (-135)
        self.turtle.forward (100/prop)
        self.turtle.left (-90)
        self.turtle.forward (60/prop)
        self.turtle.left (-90)
        self.turtle.forward (40/prop)
        self.turtle.left(-45)
        self.turtle.forward (60/matematica.cos(45)/prop)
        self.turtle.left (-225)

        self.turtle.end_fill()


        self.turtle.forward (30/prop)

    def porta4(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """
        self.turtle.backward(55/2/prop)

        self.turtle.color ("#000000", "#630303")
        self.turtle.begin_fill()
        for s in range (2):
            self.turtle.forward (55/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)
        self.turtle.end_fill()

        self.turtle.left (90)
        self.turtle.forward (40/prop)
        self.turtle.left (-90)
        self.turtle.penup ()
        self.turtle.forward (10/prop)
        self.turtle.pendown ()

        self.turtle.color ("#000000", "#9F9F9F")
        self.turtle.begin_fill ()
        self.turtle.circle (8/prop)
        self.turtle.end_fill ()
        self.turtle.penup ()
        self.turtle.left (-90)
        self.turtle.forward (40/prop)
        self.turtle.left (-90)
        self.turtle.forward (10/prop)
        self.turtle.left (180)
        self.turtle.pendown()

        self.turtle.forward(55/2/prop)

    def porta5(self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x60)
        """
        self.turtle.backward(60/2/prop)

        self._cor = cores.converterDEC2HEX ( 98, 155, 236 )

        self.turtle.color ("black", self._cor)
        self.turtle.begin_fill()

        for x in range (2) :
            self.turtle.forward (60/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)

        self.turtle.end_fill()

        self.turtle.forward(60/2/prop)

    def porta6 (self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """

        self.turtle.backward(55/2/prop)

        self.turtle.color ("#000000", "#630303")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (55/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)
        self.turtle.end_fill()
        self.turtle.left (90)
        self.turtle.forward (50/prop)
        self.turtle.penup ()
        self.turtle.left (-90)
        self.turtle.forward (7.5/prop)
        self.turtle.pendown ()
        self.turtle.color ("#000000", "#7FFFFF")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (40/prop)
            self.turtle.left (90)
            self.turtle.forward (35/prop)
            self.turtle.left (90)
        self.turtle.end_fill ()
        self.turtle.penup ()
        self.turtle.left (180)
        self.turtle.forward (7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (50/prop)
        self.turtle.left (90)
        self.turtle.pendown ()

        self.turtle.forward(55/2/prop)

    def porta7 (self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """
        self.turtle.backward(55/2/prop)

        self.turtle.color ("#000000", "#4E2D2D")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (55/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)
        self.turtle.end_fill()

        self.turtle.penup ()
        self.turtle.forward (7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (10/prop)
        self.turtle.pendown ()

        self.turtle.color ("#000000", "#6C3838")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (80/prop)
            self.turtle.left (-90)
            self.turtle.forward (40/prop)
            self.turtle.left (-90)
        self.turtle.end_fill ()

        self.turtle.penup ()
        self.turtle.left(90)
        self.turtle.forward (7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (10/prop)

        self.turtle.left (90)
        self.turtle.pendown ()

        self.turtle.forward(55/2/prop)


    def porta8 (self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """
        self.turtle.backward(55/2/prop)

        self.turtle.color ("#000000", "#4E2D2D")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (55/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)
        self.turtle.end_fill()

        self.turtle.penup ()
        self.turtle.left (90)
        self.turtle.forward (40/prop)
        self.turtle.left (-90)
        self.turtle.forward (27.5/prop)
        self.turtle.left (90)
        self.turtle.forward (15/prop)
        self.turtle.left (-90)
        self.turtle.pendown ()

        self.turtle.color ("#000000", "#7FFFFF")
        self.turtle.begin_fill ()
        self.turtle.circle (20/prop)
        self.turtle.end_fill ()

        self.turtle.left (90)
        self.turtle.forward (40/prop)
        self.turtle.left (-90)
        self.turtle.penup ()
        self.turtle.forward (20/prop)
        self.turtle.left (-90)
        self.turtle.forward (20/prop)
        self.turtle.left (-90)
        self.turtle.pendown ()
        self.turtle.forward (40/prop)
        self.turtle.penup()
        self.turtle.forward (7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (75/prop)
        self.turtle.left (90)
        self.turtle.pendown ()

        self.turtle.forward(55/2/prop)

    def porta9 (self, prop=1):
        """
        Desc:
        Desenha uma porta

        prop   = Int: proporção (1 = 100x55)
        """

        self.turtle.backward(55/2/prop)

        self.turtle.color ("#000000", "#4E2D2D")
        self.turtle.begin_fill ()
        for s in range (2):
            self.turtle.forward (55/prop)
            self.turtle.left (90)
            self.turtle.forward (100/prop)
            self.turtle.left (90)
        self.turtle.end_fill()
        self.turtle.penup ()
        self.turtle.forward (7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (10/prop)
        self.turtle.pendown ()
        self.turtle.color ("#000000", "#6C3838")
        self.turtle.begin_fill ()
        for s in range (4):
            self.turtle.forward (40/prop)
            self.turtle.left (-90)
        self.turtle.end_fill ()

        self.turtle.penup ()

        self.turtle.left (90)
        self.turtle.forward(7.5/prop)
        self.turtle.left (90)
        self.turtle.forward (10/prop)
        self.turtle.left (90)

        self.turtle.pendown()

        self.turtle.forward(55/2/prop)

portas = portas()