#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import turtle
import random

from tkinter import colorchooser

from cidadeBela.matematica import matematica

class cores(object):

    # Todos os direitos reservados à Paulo Mateus
    # Qualquer dúvida ou erro, mande um e-mail para mateus.moura@hotmail.com

    # Iniciador
    def __init__(self):
        # Variáveis
        self.turtle = turtle


    # Janelas gráficas
    def janelaCores(self, retorno="Geral"):
        """
        Desc: Mostra a janela gráfica de cores

        retorno = String: 'Geral', 'RGB' ou 'Hex'

        Retorna: Cor
        """
        self._corSelecionada = colorchooser.askcolor(color="#3863C7")

        if retorno == "Geral":
            return self._corSelecionada

        elif retorno == "Dec":
            self._corSelecionada = list(self._corSelecionada[0])

            self._corSelecionada[0] = int(self._corSelecionada[0])
            self._corSelecionada[1] = int(self._corSelecionada[1])
            self._corSelecionada[2] = int(self._corSelecionada[2])

            return self._corSelecionada

        elif retorno == "Hex":
            return self._corSelecionada[1]

    # Conversões
    '''
    def converterDEC2HEX(self, r, g, b):
        """
        Desc:
        Converte RGB decimal para Hexadecimal

        r = Int: Red. 0 a 255
        g = Int: Green. 0 a 255
        b = Int: Blue. 0 a 255

        Retorna: String: Cor Hexadecimal
        """

        r = hex(int(r))
        g = hex(int(g))
        b = hex(int(b))


        # Formatando
        r = r[2: len(r)]
        g = g[2: len(g)]
        b = b[2: len(b)]

        while len(r) < 2:
            r = "0"+r
        while len(g) < 2:
            g = "0"+g
        while len(b) < 2:
            b= "0"+b

        return "#"+r+g+b
    '''

    def converterDEC2HEX(self, r=0, g=0, b=0):
        """
        # PEGO EM: "Python para desenvolvedores 2ª edição"
        Desc:
        Converte RGB decimal para Hexadecimal

        r = Int: Red. 0 a 255
        g = Int: Green. 0 a 255
        b = Int: Blue. 0 a 255

        Retorna: String: Cor Hexadecimal
        """
        return '#{0:02x}{1:02x}{2:02x}'.format(r, g, b)

    def converterHEX2DEC(self, cor='#FFFFFF'):
        """
        # PEGO EM: "Python para desenvolvedores 2ª edição"
        Desc:
        Converte RGB Hexadecimal para decimal

        cor = String: #RRGGBB

        Retorna: List: Cor Decimal
        """
        if cor.startswith('#'): cor = cor[1:]
        r = int(cor[:2], 16)
        g = int(cor[2:4], 16)
        b = int(cor[4:], 16)
        return [r, g, b] # Uma sequência


    # Cores
    def clarear(self, porcentagem, r, g, b, formato='RGB'):
        """
        Desc:
        Clareia uma cor pela porcentagem pedida

        porcentagem = Int: Porcentagem para clarear
        r = Int: Red.   0 a 255
        g = Int: Green. 0 a 255
        b = Int: Blue.  0 a 255

        Retorna: String: Cor RGB
        """

        # Calculando
        porcentagem = 100-porcentagem

        r = 255-r
        g = 255-g
        b = 255-b

        r = (r*porcentagem // 100)
        g = (g*porcentagem // 100)
        b = (b*porcentagem // 100)

        r = str(255-r)
        g = str(255-g)
        b = str(255-b)

        # Formatando
        while len(r) < 3:
            r = "0"+r
        while len(g) < 3:
            g = "0"+g
        while len(b) < 3:
            b= "0"+b

        return r+g+b

    def clarearDEC2HEX(self, porcentagem, cor):
        """
        Desc:
        Clareia uma cor pela porcentagem pedida

        porcentagem = Int: Porcentagem para clarear
        cor = String: Cor em RGB decimal ("rgb"), onde
            r = Int: Red.   000 a 255
            g = Int: Green. 000 a 255
            b = Int: Blue.  000 a 255

        Retorna: String: Cor Hexadecimal
        """

        self._r = int(cor[0:3])
        self._g = int(cor[3:6])
        self._b = int(cor[6:9])

        cor = self.clarear(porcentagem, self._r, self._g, self._b)

        self._r = int(cor[0:3])
        self._g = int(cor[3:6])
        self._b = int(cor[6:9])

        return self.converterDEC2HEX(self._r, self._g, self._b )


    def escurecer(self, porcentagem, r, g, b ):
        """
        Desc:
        Escurece uma cor pela porcentagem pedida

        porcentagem = Int: Porcentagem para escurecer
        r = Int: Red.   0 a 255
        g = Int: Green. 0 a 255
        b = Int: Blue.  0 a 255

        Retorna: String: Cor RGB
        """


        # Calculando
        porcentagem = 100-porcentagem

        r = str((r*porcentagem // 100))
        g = str((g*porcentagem // 100))
        b = str((b*porcentagem // 100))

        # Formatando
        while len(r) < 3:
            r = "0"+r
        while len(g) < 3:
            g = "0"+g
        while len(b) < 3:
            b= "0"+b

        return r+g+b


    def escurecerDEC2HEX(self, porcentagem, cor):
        """
        Desc:
        Escurece uma cor pela porcentagem pedida

        porcentagem = Int: Porcentagem para escurecer
        cor = String: Cor em RGB decimal ("rgb"), onde
            r = Int: Red.   000 a 255
            g = Int: Green. 000 a 255
            b = Int: Blue.  000 a 255

        Retorna: String: Cor RGB em Hexadecimal
        """

        self._r = int(cor[0:3])
        self._g = int(cor[3:6])
        self._b = int(cor[6:9])

        cor = self.escurecer(porcentagem, self._r, self._g, self._b)

        self._r = int(cor[0:3])
        self._g = int(cor[3:6])
        self._b = int(cor[6:9])


        return self.converterDEC2HEX(self._r, self._g, self._b )


    def escurecerHex(self, porcentagem, hexadecimal):
        """
        !!PROBLEMA!!!
        Desc:
        Escurece uma cor pela porcentagem pedida

        cor = String: Cor RGB em Hexadecimal ("#rgb"), onde
            r = Int: Red.   00 a FF
            g = Int: Green. 00 a FF
            b = Int: Blue.  00 a FF

        Retorna: String: Cor RGB em Hexadecimal
        """

        # -----------------Problema!!!-----------------

        # Calculando
        porcentagem = 100-porcentagem

        #  Decimal   0x0A -> 10
        print("0x"+hexadecimal[1: 2])
        self._r = int("0x"+hexadecimal[1: 2])
        self._g = int("0x"+hexadecimal[3: 4])
        self._b = int("0x"+hexadecimal[5: 6])
        #  Calculando
        self._r = str((self._r*porcentagem // 100))
        self._g = str((self._g*porcentagem // 100))
        self._b = str((self._b*porcentagem // 100))

        return self.converterDEC2HEX(self._r, self._g, self._b )


    # Degradês
    def degradeQuadl(self, corinicial, corfinal, largura, altura, angulo=0):
        """
        Desc:
        Desenha em turtle um quadrilátero em degradê

        corinicial = List: [r, g, b]
        corfinal   = List: [r, g, b]
            r = Int: Red.   0 a 255
            g = Int: Green. 0 a 255
            b = Int: Blue.  0 a 255

        largura = Int
        altura  = Int
        angulo  = Int
        """

        # Andar a expressura do lapis
        if self.turtle.pen('pensize') == None:
            self._andar = 1
        else:
            self._andar = int(self.turtle.pen('pensize'))


        # Verificar se vai pintar para frente ou para trás

        if matematica.eNegativo(largura) == False:
            self._andar = self._andar
        else:
            self._andar = 0 - self._andar


        # Pintar
        self.turtle.left(angulo)
        #                       (Largura) / (a expressura do lápis)!
        for cv in range( matematica.modulo(int(largura/self._andar)) ):

            self.turtle.left(90-angulo)
            self._degradeMudarCor( corinicial, corfinal, cv, matematica.modulo(int(largura/self._andar)))
            self.turtle.forward(altura)
            self.turtle.backward(altura)
            self.turtle.right(90-angulo)

            self.turtle.forward(self._andar)

        self.turtle.penup()

        self.turtle.forward(0 - int(largura/matematica.modulo(self._andar)))
        self.turtle.pendown()

        self.turtle.right(angulo)

    def _degradeMudarCor(self, corinicial, corfinal, repeticao, totalrepeticoes ):
        """
        Desc:
        Muda a cor do lápis (self.turtle.pencolor())
        Método ligado a: cores.degradeQuadl()

        corinicial = List: [r, g, b]
        corfinal   = List: [r, g, b]
            r = Int: Red.   0 a 255
            g = Int: Green. 0 a 255
            b = Int: Blue.  0 a 255

        repeticao        = Int: Repetição atual
        totalrepeticoes  = Int: Total de repetições
        """

        # Adaptando o código
        self.turtle.colormode(255)

        # Diferença das cores
        self._CdifR = corfinal[0] - corinicial[0]
        self._CdifG = corfinal[1] - corinicial[1]
        self._CdifB = corfinal[2] - corinicial[2]


        # Pegando as 3 novas cores do degradê
        if matematica.eNegativo(self._CdifR) == False :
            self._CAtualR = int(self._CdifR/totalrepeticoes) * repeticao
        else :
            self._CAtualR = 0 - int(self._CdifR/totalrepeticoes) * (totalrepeticoes - (repeticao-1))

        if matematica.eNegativo(self._CdifG) == False :
            self._CAtualG = int(self._CdifG/totalrepeticoes) * repeticao
        else :
            self._CAtualG = 0 - int(self._CdifG/totalrepeticoes) * (totalrepeticoes - (repeticao-1))

        if matematica.eNegativo(self._CdifB) == False :
            self._CAtualB = int(self._CdifB/totalrepeticoes) * repeticao
        else :
            self._CAtualB = 0 - int(self._CdifB/totalrepeticoes) * (totalrepeticoes - (repeticao-1))

        # Mudando a cor do lápis
        self.turtle.pencolor((self._CAtualR, self._CAtualG, self._CAtualB))

        # Voltando ao inicio
        self.turtle.colormode(1)

    # Sortear cores
    def sortearcor(self, formato="Hex"):
        """
        Desc:
        Sorteia uma cor qualquer

        formato: String: 'Hex' ou 'Dec'

        Retorna: String: Cor RGB no 'formato' desejado
        """

        if formato=="Dec":
            return "{0:03d}{1:03d}{2:03d}".format(random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
        else:
            return self.converterDEC2HEX( random.randint(0, 255), random.randint(0, 255), random.randint(0, 255) )



cores = cores()
#cores.degradeQuadl([255,13,245], [31, 240, 123], 50, 40, 45)
#print(cores.converterHEX2DEC(cores.converterDEC2HEX(255, 234, 10)))
#turtle.mainloop()