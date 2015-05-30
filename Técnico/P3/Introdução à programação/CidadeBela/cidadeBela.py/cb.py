#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import math
import random
import turtle

import sys

from tkinter import *
from tkinter import messagebox
from tkinter import colorchooser
#from PIL import Image, ImageTk

import tkinter.ttk as ttk

from cidadeBela.cores      import cores
from cidadeBela.matematica import matematica

from cidadeBela.tetos   import tetos
from cidadeBela.portas  import portas
from cidadeBela.janelas import janelas

#from nomeDoarquivoSEM.PY import *

"""
from win32api import GetSystemMetrics
width = GetSystemMetrics [0]
height = GetSystemMetrics [1]

print(width,height)
"""

class cidadeBela(object):

    # Iniciador
    def __init__(self):
        # Janela sobre
        self.janSobre = None


        # Cor de fundo
        self.corFundo = "gray"


        turtle.screensize(1000, 700, self.corFundo)
        turtle.setup(width=1000, height=700)
        turtle.title("cidadeBela - Janela de desenho")


        turtle.speed(0)
        turtle.tracer(4)

        # Definindo variáveis globais
        self._tamPadrao = ""

        # Listas de prédios
        self.predios = ['Casa', 'Hotel']
        self.prediosProc = [ 'hotel', 'hotelInv', 'casa', 'casaInv' ]


        # Sorteando elementos
        self.sorteioPredios    = [["casa", 1], ["hotel", 1]]
        self.sorteioPrediosInv = [["casaInv", 1], ["hotelInv", 1]]


        #  Cores dos prédios
        self.coresHotel = ["076080190", "255255255", "167064057", "153204255", "000090245",
                           "201232098", "255058123", "010056150", "130255255", "255255000",
                           "255000000", "255127042", "000255000", "255170255", "000255170",
                           "212000255", "170255127", "127212255", "255127127", "255212085",
                           "212212255", "255255127", "222202144" ]
        self.coresCasa  = ['209187103', '115155225', '130047006', '255137111', '203229057',
                           '017130100', '025195159', '204057065', '194082255', '092221159',
                           '167045055', '238243030', '069241248', '000156228', '159094040',
                           '048033253', '040209239', '138164253', '190042177', '000122159',
                           '255255255', '253208201', '245228133']
        self.coresLoja  = ['255255255', '253208201', '245228133' ]

        #  Janelas dos prédios
        self.janelasHotel = janelas.janelasHotel
        self.janelasCasa  = janelas.janelasCasa
        self.janelasLoja  = janelas.janelasLoja
        self.janelasTodas = janelas.janelasTodas

        #  Tetos dos prédios
        self.tetosHotel = tetos.tetosHotel
        self.tetosCasa  = tetos.tetosCasa
        self.tetosLoja  = tetos.tetosLoja
        self.tetosTodas = tetos.tetosTodas

        #  Portas dos prédios
        self.portasHotel = portas.portasHotel
        self.portasCasa  = portas.portasCasa
        self.portasLoja  = portas.portasLoja
        self.portasTodas = portas.portasTodas

    # Funções primárias

    # ### Janelas Gráficas ### #
    def janelaFixar(self):
        """
        Desc: Faz a janela de desenho não fechar

        Chame-a sempre após terminar os desenhos
        """

        turtle.mainloop()

    def janelaLimpar(self):
        """
        Desc: Limpa a janela da gráfica
        """
        turtle.reset()
        #turtle.screensize(1000, 700, self.corFundo)

    def janelaFechar(self):
        """
        Desc: Fecha a janela da gráfica
        """
        turtle.bye()

    def janelaErro(self, erro):
        """
        Desc: Mostrar uma janela com uma mensagem de erro

        erro = String: Mensagem do erro
        """
        self._resultado = messagebox.showwarning(title = "Erro", message='Erro: ' + str(erro))


    def janelaCores(self, retorno="Geral"):
        """
        Desc: Mostra a janela gráfica de cores

        retorno = String: 'Geral', 'Dec' ou 'Hex'

        Retorna: Cor
        """
        return cores.janelaCores(retorno)

    def janelaSobre(self):
        """
        Desc: Sobre da classe
        """
        # Nova janela
        self._root = Tk()

        # Características da janela
        self._root.title('Sobre cidadeBela v1.0')
        self._root.geometry('403x222+363+119')
        self._root.resizable(FALSE,FALSE)

        # Widjets
        self._widget = self._janelaSobreDesenho(self._root)


        # Se fechar
        self._root.protocol("WM_DELETE_WINDOW", self._janelaSobreBotaoOk)


        self.janSobre = self._root


        # Não travar?
        #self._root.mainloop()

    def _janelaSobreDesenho(self, master=None):
        """
        Desc: Desenha a janelaSobre
        """

        self._style   = ttk.Style()
        self._theme   = self._style.theme_use()
        self._default = self._style.lookup(self._theme, 'background')
        master.configure(background=self._default)


        self.imagem = PhotoImage(master=master, file="imagens\\ifce.gif")
        self.lab32 = Label (master, image=self.imagem)
        self.lab32.place(relx=0.02,rely=0.09,relheight=0.7,relwidth=0.46)

        self.tBu35 = ttk.Button (master)
        self.tBu35.place(relx=0.77,rely=0.81)
        self.tBu35.configure(takefocus="")
        self.tBu35.configure(text="Ok")
        self.tBu35.configure(command=self._janelaSobreBotaoOk)

        self.mes38 = Message (master)
        self.mes38.place(relx=0.49,rely=0.19,relheight=0.57,relwidth=0.83)
        self.mes38.configure(anchor="nw")
        self.mes38.configure(text="Trabalho de informática\nProfessor: Ricardo Guedes\n\ncidadeBela desenvolvido por:\nGabriela Alves Valentim\nPaulo Mates Moura da Silva\nSamara da Costa Oliveira")


    def _janelaSobreBotaoOk(self, master=None):
        self._root.destroy()
        self.janSobre = None



    # ### Verificação ### #
    def getPos(self):
        """
        Desc: Método para pegar posição e sentido da tartaruga
        Use verificarPos() para verificar se é igual a inicial

        Exemplo:
        cb.getPos()
        cb.casa(25, 50, 30)
        cb.verificarPos()
        """

        self.turtlePosX = round(turtle.xcor())
        self.turtlePosY = round(turtle.ycor())
        self.turtleDir  = turtle.heading()

    def verificarPos(self):
        """
        Desc: Método para verificar se a posição e sentido da tartaruga é igual ao inicial
        Use getPos() para pegar o inicial

        Printa: String = Erro
        Retorna: Boolean = True (caso esteja ok) ou False (caso não)

        Exemplo:
        cb.getPos()
        cb.casa(25, 50, 30)
        cb.verificarPos()
        """

        self._retorno = True

        if (round(turtle.xcor()) != self.turtlePosX) or (round(turtle.ycor()) != self.turtlePosY):
            print("A posição atual da tartaruga difere da inicial ({0}, {1})\nEla está em: ({2}, {3})".format(str(self.turtlePosX),
                  str(self.turtlePosY),
                  str(round(turtle.xcor())),
                  str(round(turtle.ycor()))))
            self._retorno = False
        if turtle.heading() != self.turtleDir:
            print("A direção atual da tartaruga difere da inicial (" + str(self.turtleDir) + ")\nEla está em:", str(turtle.heading()))
            self._retorno = False

        return self._retorno


    # ### Blocos Básicos ### #
    #  Teto = "" ou False => Não tem teto
    #  Teto = True => teto convencional
    def paralelepipedo(self, a, l, p, cor="255255255", teto=False):
        """
        Desc: Base dos prédios 2.5D

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        teto= Boolean: False ou True
        """
        self._cor1 = cores.escurecerDEC2HEX(0, cor)

        turtle.color("black", self._cor1)
        turtle.begin_fill()
        # Frente
        for x in range(2):
            turtle.forward(l)
            turtle.left(90)
            turtle.forward(a)
            turtle.left(90)

        turtle.end_fill()


        # Profundidade
        turtle.forward(l)
        turtle.left(45)


        self._cor2 = cores.escurecerDEC2HEX(20, cor)

        turtle.color("black", self._cor2)
        turtle.begin_fill()

        for x in range(2):
            turtle.forward(p)
            turtle.left(45)
            turtle.forward(a)
            turtle.left(135)

        turtle.end_fill()

        turtle.right(45)
        turtle.backward(l)

        # Teto
        if(teto == True):
            turtle.left(90)
            turtle.forward(a)
            turtle.left(90)

            self._cor2 = cores.clarearDEC2HEX(20, cor)

            turtle.color("black", self._cor2)
            turtle.begin_fill()

            for x in range(2):
                turtle.right(135)
                turtle.forward(p)
                turtle.right(45)
                turtle.forward(l)

            turtle.end_fill()

            turtle.right(90)
            turtle.backward(a)
            turtle.right(90)

    def paralelepipedoInv(self, a, l, p, cor="255255255", teto=False):
        """
        Desc: Base dos prédios 2.5D (de costas!)

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = Sting: cor em RGB do prédio
        teto= Boolean: False ou True
        """

        # Pegando posição inicial

        # Se posicionando
        turtle.penup()
        turtle.left(45)
        turtle.backward(p)
        turtle.right(45)
        turtle.pendown()

        self._cor1 = cores.escurecerDEC2HEX(0, cor)

        turtle.color("black", self._cor1)
        turtle.begin_fill()

        # Frente
        for x in range(2):
            turtle.forward(l)
            turtle.left(90)
            turtle.forward(a)
            turtle.left(90)

        turtle.end_fill()

        turtle.penup()
        turtle.forward(l)
        turtle.left(45)
        turtle.pendown()

        # Profundidade
        self._cor2 = cores.escurecerDEC2HEX(20, cor)

        turtle.color("black", self._cor2)
        turtle.begin_fill()

        for x in range(2):
            turtle.forward(p)
            turtle.left(45)
            turtle.forward(a)
            turtle.left(135)

        turtle.end_fill()

        turtle.right(45)
        turtle.backward(l)


        # Teto
        if(teto == True):
            turtle.left(90)
            turtle.forward(a)
            turtle.left(90)


            self._cor2 = cores.clarearDEC2HEX(20, cor)

            turtle.color("black", self._cor2)
            turtle.begin_fill()

            for x in range(2):
                turtle.right(135)
                turtle.forward(p)
                turtle.right(45)
                turtle.forward(l)

            turtle.end_fill()


            turtle.right(90)
            turtle.backward(a)
            turtle.right(90)

        # Voltando à posição original
        turtle.penup()
        turtle.left(45)
        turtle.forward(p)
        turtle.right(45)
        turtle.pendown()

    # ### Funções Configuração ### #
    def formatarElem1(self, classe, metodo, parametros):
        """
        Desc:
        Função para retornar um método enviando o string de seu nome
        classe     = String: Classe a que o método pertence
        metodo     = String: Nome do método
        parametros = String: Parâmetros do método

        Envia: String: classe.metodo(parametros)
        """
        metodo = classe +"." + metodo + "( " + str(parametros) + " )"
        return metodo



    # ### Funções Configuração ### #

    def tamanhoPredios(self, tipoPredio="", sortear=True):
        """
        Desc:
        Retorna uma lista contendo o tamanho sugerido para um prédio especificado em 'tipoPredio'

        tipoPredio = String: "hotel", "casa" ou "loja"
        tipoPredio = Boolean: True para sortear valores, False para tamanho padrão

        Envia: List
        """

        if tipoPredio == 'hotel':
            if sortear == True:
                return [random.randint(75, 120), 65, random.randint(35, 55)]
            else:
                return [100, 65, 40]

        elif tipoPredio == 'casa':
            if sortear == True:
                return [random.randint(40, 45), 50, random.randint(25, 35)]
            else:
                return [40, 50, 30]

        elif tipoPredio == 'loja':
            return [0, 0, 0]

        else:
            return [0, 0, 0]

    def sortearPredio(self):

        self._predios  = ['casa', 'hotel']
        self._predioId = random.randint (0, len(self._predios)-1)

        # Retornar ID      e o          nome do Prédio
        return [self._predioId, self._predios[self._predioId]]


    # ### Funções 'Construtoras' ### #
    # Hotel
    def hotel(self, a, l, p, cor="", porta="", teto="",  janela=""):
        """
        Desc: Desenha uma hotel com:
         cor   = "" randômica (listada em self.coresHotel)
         porta = "" randomica (listada em portas.portas("hotel"))
         teto  = "" randômico (listada em tetos.tetos("hotel"))
         janela= "" randomica (listada em janelas.janelas("hotel"))

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = String: Cor em RGB do prédio
        porta  = Int: Id da porta
        teto   = Int: Id do teto
        janela = Int: Id da janela
        """

        #############################
        # Cor
        if cor != "":
            self._cor = cor
        else:
            # Sortear cor do prédios
            self._coresLis = self.coresHotel
            self._corId    = random.randint (0, len(self._coresLis)-1)
            self._cor      = self._coresLis[self._corId]
        #############################

        # Construindo base do prédio
        self.paralelepipedo(a, l, p, self._cor, teto=False)


        #############################
        # Colocando Porta
        turtle.forward(l/2)

        # Porta
        #   Retorna lista com as portas disponíveis
        self._portas = self.portasHotel

        if porta != "":
            if porta <= len(self._portas)-1:
                #   Formata: string => função
                self._portasort = self.formatarElem1('portas', self._portas[porta], 5)
                #   Desenha porta sorteada
                exec(self._portasort)
            else:
                self.janelaErro("Id da janela inválido!")
                #print("Id da janela inválido!")
        else:
            #  Sortear porta
            #   Sorteia uma porta
            self._portaId = random.randint (0, len(self._portas)-1)
            #   Formata: string => função
            self._portasort = self.formatarElem1('portas', self._portas[self._portaId], 5)
            #   Desenha porta sorteada
            exec(self._portasort)

        turtle.backward(l/2)
        #############################


        #############################
        # Colocando teto
        turtle.left(90)
        turtle.forward(a)

        # Teto
        #   Retorna lista com os tetos disponíveis
        self._tetos = self.tetosHotel

        if teto != "":
            if teto <= len(self._tetos)-1:
                self._tetoId = teto
                self._tetosort = self.formatarElem1('tetos',
                                                    self._tetos[self._tetoId],
                                                    str(a)+","+str(l)+","+str(p)+","+
                                                    "\'"+self._cor+"\'"
                                                    )
                exec(self._tetosort)
            else:
                self.janelaErro("Id do teto inválido!")
                #print("Id do teto inválido!")
        else:
            #  Sortear teto

            self._tetoId = random.randint (0, len(self._tetos)-1)
            self._tetosort = self.formatarElem1('tetos',
                                               self._tetos[self._tetoId],
                                               str(a)+","+str(l)+","+str(p)+","+
                                               "\'"+self._cor+"\'"
                                               )
            exec(self._tetosort)

        turtle.backward(a)
        turtle.right(90)
        #############################


        #############################
        # Colocando janelona
        #  Posicionando tat

        turtle.penup()

        turtle.left(90)
        turtle.forward(a*40/100)
        turtle.right(90)
        turtle.forward(l/2)

        turtle.pendown()

        # Colocando janela1
        #   Retorna lista com as janelas disponíveis
        self._janelas = self.janelasHotel

        if janela != "":
            if janela <= len(self._janelas)-1:
                self._janelaId = janela
                self._janelasort = self.formatarElem1('janelas',
                                                    self._janelas[self._janelaId],
                                                    "["+ str(a)+","+str(l) +"]"
                                                    )
                exec(self._janelasort)
            else:
                self.janelaErro("Id da janela inválida!")

        else:
            #  Sortear teto

            self._janelaId = random.randint (0, len(self._janelas)-1)
            self._janelasort = self.formatarElem1('janelas',
                                               self._janelas[self._janelaId],
                                               "["+ str(a)+","+str(l) +"]"
                                               )
            exec(self._janelasort)



        #  Posicionando tat
        turtle.penup()

        turtle.forward(l/2)
        turtle.left(45)
        turtle.forward(p/2)

        turtle.pendown()

        # Colocando janela2
        #   Retorna lista com as janelas disponíveis

        if janela != "":
            if janela <= len(self._janelas)-1:
                self._janelaId = janela
                self._janelasort = self.formatarElem1('janelas',
                                                    self._janelas[self._janelaId],
                                                    "["+ str(a)+","+str(p) +"]"+ ",45"
                                                    )
                exec(self._janelasort)
            else:
                self.janelaErro("Id da janela inválida!")

        else:
            #  Sortear teto
            self._janelasort = self.formatarElem1('janelas',
                                               self._janelas[self._janelaId],
                                               "["+ str(a)+","+str(p) +"]"+ ",45"
                                               )
            exec(self._janelasort)



        #  Reposicionando tat

        turtle.penup()

        turtle.backward(p/2)
        turtle.right(45)
        turtle.backward(l/2)

        turtle.backward(l/2)
        turtle.left(90)
        turtle.backward(a*40/100)
        turtle.right(90)

        turtle.pendown()

    # Hotel Invertido
    def hotelInv(self, a, l, p, cor="", porta="", teto="",  janela=""):
        """
        Desc: Desenha uma hotel invertido com:
         cor   = "" randômica (listada em self.coresHotel)
         porta = "" randomica (listada em portas.portas("hotel"))
         teto  = "" randômico (listada em tetos.tetos("hotel"))
         janela= "" randomica (listada em janelas.janelas("hotel"))

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        cor = String: Cor em RGB do prédio
        porta  = Int: Id da porta
        teto   = Int: Id do teto
        janela = Int: Id da janela
        """

        #############################
        # Cor
        if cor != "":
            self._cor = cor
        else:
            # Sortear cor do prédios
            self._coresLis = self.coresHotel
            self._corId    = random.randint (0, len(self._coresLis)-1)
            self._cor      = self._coresLis[self._corId]
        #############################


        #############################
        # Construindo base da casa
        self.paralelepipedoInv(a, l, p, self._cor, teto=False)
        #############################


        #############################
        # Janela

        # Colocando Janela
        #  Se posicionando
        turtle.penup()

        turtle.right(135)
        turtle.forward(p)
        turtle.left(135)

        turtle.forward(l/2)
        turtle.left(90)

        turtle.forward(a*40/100)
        turtle.right(90)
        turtle.pendown()

        #  Sortear e colocar janela
        self._janelas = self.janelasHotel
        if janela != "":
            if janela <= len(self._janelas)-1:
                self._janelaId = janela
                self._janelaSort = self.formatarElem1('janelas',
                                               self._janelas[self._janelaId],
                                               "["+ str(a)+","+str(l) +"]"
                                               )
                exec(self._janelaSort)
            else:
                self.janelaErro("Id da janela inválido!")
                #print("Id da janela inválido!")
        else:
            self._janelaId = random.randint (0, len(self._janelas)-1)
            self._janelaSort = self.formatarElem1('janelas',
                                               self._janelas[self._janelaId],
                                               "["+ str(a)+","+str(l) +"]"
                                               )
            exec(self._janelaSort)


        #  Posicionando tat
        turtle.penup()

        turtle.forward(l/2)
        turtle.left(45)
        turtle.forward(p/2)

        turtle.pendown()

        # Colocando janela2
        #   Retorna lista com as janelas disponíveis

        if janela != "":
            if janela <= len(self._janelas)-1:
                self._janelaId = janela
                self._janelasort = self.formatarElem1('janelas',
                                                    self._janelas[self._janelaId],
                                                    "["+ str(a)+","+str(p) +"]"+ ",45"
                                                    )
                exec(self._janelasort)
            else:
                self.janelaErro("Id da janela inválida!")

        else:
            # Sortear
            self._janelasort = self.formatarElem1('janelas',
                                               self._janelas[self._janelaId],
                                               "["+ str(a)+","+str(p) +"]"+",45"
                                               )
            exec(self._janelasort)

        #  Reposicionando tat
        turtle.penup()

        turtle.backward(p/2)
        turtle.right(45)
        turtle.backward(l/2)

        turtle.left(90)
        turtle.backward(a*40/100)
        turtle.right(90)
        turtle.backward(l/2)

        turtle.pendown()
        #############################


        #############################
        # Teto
        # Colocando teto
        turtle.left(90)
        turtle.forward(a)

        #   Retorna lista com os tetos disponíveis
        self._tetos = self.tetosHotel
        if teto != "":
            if teto <= len(self._tetos)-1:
                self._tetoId = teto
                self._tetosort = self.formatarElem1('tetos',
                                                    self._tetos[self._tetoId],
                                                    str(a)+","+str(l)+","+str(p)+","+
                                                    "\'"+self._cor+"\'"
                                                    )
                exec(self._tetosort)
            else:
                self.janelaErro("Id do teto inválido!")

        else:
            #  Sortear teto

            self._tetoId = random.randint (0, len(self._tetos)-1)
            self._tetosort = self.formatarElem1('tetos',
                                               self._tetos[self._tetoId],
                                               str(a)+","+str(l)+","+str(p)+","+
                                               "\'"+self._cor+"\'"
                                               )
            exec(self._tetosort)
        #############################


        #############################
        # Voltando à posição inicial
        turtle.penup()

        turtle.left(-45)
        turtle.forward(p)
        turtle.right(45)

        turtle.right(90)
        turtle.forward(a)
        turtle.right(-90)

        turtle.pendown()

    # Casa
    def casa(self, a, l, p, cor="", porta="", teto="",  janela=""):
        """
        Desc: Desenha uma casa com:
         cor   = "" randômica (listada em self.coresCasa)
         porta = "" randomica (listada em portas.portas("casa"))
         teto  = "" randômico (listada em tetos.tetos("casa"))
         janela= "" randomica (listada em janelas.janelas("casa"))

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        """

        #############################
        # Cor
        if cor != "":
            self._cor = cor
        else:
            # Sortear cor da casa
            self._coresLis = self.coresCasa
            self._corId    = random.randint (0, len(self._coresLis)-1)
            self._cor      = self._coresLis[self._corId]
        #############################


        #############################
        # Construindo base da casa
        self.paralelepipedo(a, l, p, self._cor, teto=False)
        #############################


        #############################
        # Colocando Porta
        turtle.forward(l/2)

        # Porta
        #   Retorna lista com as portas disponíveis
        self._portas = self.portasCasa

        if porta != "":
            if porta <= len(self._portas)-1:
                #   Formata: string => função
                self._portasort = self.formatarElem1('portas', self._portas[porta], 5)
                #   Desenha porta sorteada
                exec(self._portasort)
            else:
                self.janelaErro("Id da porta inválido!")
                #print("Id da porta inválido!")
        else:
            #  Sortear porta
            #   Sorteia uma porta
            self._portaId = random.randint (0, len(self._portas)-1)
            #   Formata: string => função
            self._portasort = self.formatarElem1('portas', self._portas[self._portaId], 5)
            #   Desenha porta sorteada
            exec(self._portasort)


        turtle.backward(l/2)
        #############################


        #############################
        # Colocando teto
        turtle.left(90)
        turtle.forward(a)

        self._tetos = self.tetosCasa
        if teto != "":
            if teto <= len(self._tetos)-1:
                self._tetoId = teto
                self._tetosort = self.formatarElem1('tetos',
                                                    self._tetos[self._tetoId],
                                                    str(a)+","+str(l)+","+str(p)+","+
                                                    "\'"+self._cor+"\'"
                                                    )
                exec(self._tetosort)
            else:
                self.janelaErro("Id do teto inválido!")
                #print("Id do teto inválido!")
        else:
            #  Sortear teto

            self._tetoId = random.randint (0, len(self._tetos)-1)
            self._tetosort = self.formatarElem1('tetos',
                                               self._tetos[self._tetoId],
                                               str(a)+","+str(l)+","+str(p)+","+
                                               "\'"+self._cor+"\'"
                                               )
            exec(self._tetosort)

        turtle.backward(a)
        turtle.right(90)
        #############################

    # Casa Invertida
    def casaInv(self, a, l, p, cor="", porta="", teto="",  janela=""):
        """
        Desc: Desenha uma casa invertida com:
         cor   = "" randômica (listada em self.coresCasa)
         porta = "" randomica (listada em portas.portas("casa"))
         teto  = "" randômico (listada em tetos.tetos("casa"))
         janela= "" randomica (listada em janelas.janelas("casa"))

        a = Int: altura
        l = Int: largura
        p = Int: profundidade
        """

        #############################
        # Cor
        if cor != "":
            self._cor = cor
        else:
            # Sortear cor da casa
            self._coresLis = self.coresCasa
            self._corId    = random.randint (0, len(self._coresLis)-1)
            self._cor      = self._coresLis[self._corId]
        #############################


        #############################
        # Construindo base da casa
        self.paralelepipedoInv(a, l, p, self._cor, teto=False)
        #############################


        #############################
        # Colocando Janela
        #  Se posicionando
        turtle.penup()

        turtle.right(135)
        turtle.forward(p)
        turtle.left(135)

        turtle.forward(l/2)
        turtle.left(90)

        turtle.forward(a/3)
        turtle.right(90)
        turtle.pendown()

        #  Sortear e colocar janela
        self._janelas = self.janelasCasa
        if janela != "":
            if janela <= len(self._janelas)-1:
                self._janelaId = janela
                self._janelaSort = self.formatarElem1('janelas', self._janelas[self._janelaId], 15)
                exec(self._janelaSort)
            else:
                self.janelaErro("Id da janela inválido!")
        else:
            self._janelaId = random.randint (0, len(self._janelas)-1)
            self._janelaSort = self.formatarElem1('janelas', self._janelas[self._janelaId], 15)
            exec(self._janelaSort)

        turtle.penup()
        turtle.left(90)
        turtle.backward(a/3)
        turtle.right(90)
        turtle.backward(l/2)

        turtle.pendown()
        #############################


        #############################
        # Colocando teto
        turtle.left(90)
        turtle.forward(a)

        self._tetos = self.tetosCasa
        if teto != "":
            if teto <= len(self._tetos)-1:
                self._tetoId = teto
                self._tetosort = self.formatarElem1('tetos',
                                                    self._tetos[self._tetoId],
                                                    str(a)+","+str(l)+","+str(p)+","+
                                                    "\'"+self._cor+"\'"
                                                    )
                exec(self._tetosort)
            else:
                self.janelaErro("Id do teto inválido!")
                #print("Id do teto inválido!")
        else:
            #  Sortear teto

            self._tetoId = random.randint (0, len(self._tetos)-1)
            self._tetosort = self.formatarElem1('tetos',
                                               self._tetos[self._tetoId],
                                               str(a)+","+str(l)+","+str(p)+","+
                                               "\'"+self._cor+"\'"
                                               )
            exec(self._tetosort)


        turtle.backward(a)
        turtle.right(90)


        #############################
        # Voltando à posição inicial
        turtle.penup()

        turtle.left(45)
        turtle.forward(p)
        turtle.right(45)

        turtle.pendown()
        #############################


    # ### Cidades Planejadas, ou não! ;D ### #
    # Função que faz a cidade
    def cidade(self, numeroDeRuas):
        """
        Cria uma pseudo cidade
        """


        # Configurações gerais
        self._tamRua     = 1200
        self._tamRuaLarg = 60
        self._tamRuaAlt  = self._tamRuaLarg*matematica.sen(45)
        self._tamCalcada = 8 # <------------- ajeitar isso agora
        self._tamQuarteiraoAlt = 200
        self._tamQuarteiroesSomados = 0

        self._tamPadrao= 50 # <------------- ajeitar isso agora
        self._tamCasa  = ['', '50']
        self._tamHotel = ['', '80']

        self._tamJanela = [-500,700/2]

        # Movendo tartaruga para o início da tela
        turtle.penup()
        turtle.setpos(self._tamJanela)#(-200, 200)
        turtle.pendown()

        # Desenhando ruas
        for a in range(0, numeroDeRuas):


            ######## Definindo um monte de variáveis ########
            # Zerando variáveis
            self._qTamanhoLarg = []
            self._qTamanhoAlt  = 0
            self._tamQuarteiroesSomados = 0


            # Sortear número de quarterões
            self._qNumeroDe = random.randint(2, 4)


            # Sorteando tamanho dos quarteroes
            #  Altura
            self._qTamanhoAlt = random.randint( int(self._tamQuarteiraoAlt*2/3),
                                                 self._tamQuarteiraoAlt )

            # Largura
            for a in range(0, self._qNumeroDe):
                if (a+1 != self._qNumeroDe):
                    self._qTamanhoLarg.append( random.randint(int(self._tamRua/self._qNumeroDe)  - int(self._tamRua/5),
                                                               (int(self._tamRua/self._qNumeroDe) + int(self._tamRua/10))
                                                            )
                                            )

                # Definindo tamanho do último quarteirão
                else:
                    for b in self._qTamanhoLarg:

                        self._tamQuarteiroesSomados = b + self._tamQuarteiroesSomados


                    self._qTamanhoLarg.append( self._tamRua - self._tamQuarteiroesSomados - self._tamRuaLarg*(self._qNumeroDe-1) )


            ######## Desenhando os quarteirões ########

            # Fazendo os quarteirões
            for a in range(0, self._qNumeroDe):

                # Desenhando a calçada
                #  Posicionando
                """turtle.penup()
                turtle.right(135-180)
                turtle.forward(self._tamCalcada)
                turtle.left(135-180)
                turtle.pendown()
                """

                turtle.color("black", "#A1B3B1")
                turtle.begin_fill()

                for c in range(2):
                    turtle.forward(self._qTamanhoLarg[a]+(matematica.sen(45)*self._tamCalcada*4))
                    turtle.right(90+45)

                    turtle.forward(self._qTamanhoAlt+(matematica.sen(45)*self._tamCalcada*4))
                    turtle.right(45)

                turtle.end_fill()

                #  Posicionando para fazer o quarteirão
                """
                turtle.penup()
                turtle.left(135-180)
                turtle.forward(self._tamCalcada)
                turtle.right(135-180)
                turtle.pendown()

                """
                # Colocando retangulo do quarterão no meio do da calçada
                turtle.penup()
                turtle.right(135/2)
                turtle.forward(self._tamCalcada)
                turtle.left(135/2)
                turtle.pendown()
                """"""

                # Desenhando um quarteirão

                turtle.color("black", "#73FB73")
                turtle.begin_fill()

                for c in range(2):
                    turtle.forward(self._qTamanhoLarg[a])#-(matematica.sen(45)*self._tamCalcada*4))
                    turtle.right(90+45)

                    turtle.forward(self._qTamanhoAlt)#-matematica.sen(45)*self._tamCalcada*4)
                    turtle.right(45)

                turtle.end_fill()

                # Colocando as casas
                #  Posicionando a tat
                turtle.penup()
                turtle.left(45)
                turtle.backward(self._qTamanhoAlt)

                turtle.right(45)
                turtle.pendown()

                self._numPredios = int(self._qTamanhoLarg[a]/self._tamPadrao)

                #  Desenhando os prédios
                for d in range(self._numPredios):

                    # Preparando variável
                    self._prediosorteado = self.sortearPredio()

                    self._var = "self." + self._prediosorteado[1]
                    if self._prediosorteado[0] == 0:
                        self._var= self._var + "("+str(random.randint(40, 50))+", " + str(self._tamPadrao) + ", 30)"
                    elif self._prediosorteado[0] == 1:
                        self._var= self._var + "(" + str(random.randint(60, 100)) + ", " + str(self._tamPadrao) + ", 50)"
                    else:
                        self.janelaErro("Erro")
                        #print("erro")

                    exec(self._var)
                    turtle.penup()
                    turtle.forward(self._tamPadrao)
                    turtle.pendown()

                # Voltando...
                turtle.penup()
                turtle.right(135/2)
                turtle.backward(self._tamCalcada)
                turtle.left(135/2)
                turtle.pendown()

                #  Voltando à posição original
                turtle.penup()
                turtle.backward(self._numPredios*self._tamPadrao)

                turtle.left(45)
                turtle.forward(self._qTamanhoAlt)

                turtle.right(45)



                # Se posicionando para ir ao próximo quarteirão
                turtle.forward(self._qTamanhoLarg[a])


                turtle.forward(self._tamRuaLarg)
                turtle.pendown()

            # Voltando ao inicio
            turtle.penup()
            #self.posAtual = turtle.pos()
            #print(0 - int(turtle.distance(self._tamJanela[0], self.posAtual[1])))
            #turtle.setx(0 - int(turtle.distance(self._tamJanela[0], self.posAtual[1])))
            turtle.backward(self._tamRua + self._tamRuaLarg)
            #print(turtle.pos())
            turtle.right(90)

            #  Quarteirão
            turtle.forward(self._qTamanhoAlt * matematica.sen(45))
            #  Rua
            turtle.forward(self._tamRuaAlt)

            turtle.left(90)
            turtle.pendown()

    ### CIDADE 2.0 ###

    def cidade_2(self, numLinQuarteiro):
        """
        Cria uma pseudo cidade
        cidadeBela.cidade reformulada!
        """

        # Configurações gerais
        self._tamLinQuart= 1200
        self._tamRuaLarg = 60
        self._tamRuaAlt  = self._tamRuaLarg*matematica.sen(45)
        self._tamCalcada = 8
        self._tamQuarteiraoProf = 200 # Profundidade

        self._tamPadrao= 50 # <------------- ajeitar isso agora
        #self._tamCasa  = ['', '50']
        #self._tamHotel = ['', '80']

        self._tamJanela = [-500,700/2]

        # Movendo tartaruga para o início da tela
        turtle.penup()
        turtle.setpos(self._tamJanela)#(-200, 200)
        turtle.pendown()

        # Desenhando quarteirões
        for a in range(0, numLinQuarteiro):
            # Definindo variáveis
            self._numQuarteiroes = random.randint(2, 4)
            self._qTamanhoProf   = random.randint( int(self._tamQuarteiraoProf*2/3),
                                                   self._tamQuarteiraoProf )


            # Desenhando os quarteirões
            self.linhaQuarteiroes(self._numQuarteiroes, self._tamRuaLarg, self._tamLinQuart, self._qTamanhoProf, self._tamCalcada)
            turtle.setpos(-500.00, turtle.ycor())

            # Posicionando para ir ao próximo quarteirão
            turtle.right(90)
            turtle.penup()
            turtle.forward( (matematica.sen(45)*self._qTamanhoProf) + self._tamRuaAlt)
            turtle.pendown()
            turtle.left(90)



    def quarteirao(self, largura, profundidade, tamCalcada=0):
        """
        Desc: Desenha um quarteirão

        largura      = Int: Largura do quarteirão
        profundidade = Int: Profundidade do quarteirão
        tCalcada     = Int: Tamanho da calçada ( faz parte do quarteirão )
        """

        # Desenhando calçada
        if tamCalcada != 0:
            turtle.color("black", "#A1B3B1")
            turtle.begin_fill()

            for c in range(2):
                turtle.forward(largura)
                turtle.right(90+45)

                turtle.forward(profundidade)
                turtle.right(45)

            turtle.end_fill()

        # Se posicionando para desenhar quarteirão
        turtle.penup()
        turtle.right(135/2)
        turtle.forward(tamCalcada)
        turtle.left(135/2)
        turtle.pendown()


        # Desenhando quarteirão
        turtle.color("black", "#73FB73")
        turtle.pencolor("black")
        turtle.begin_fill()

        for c in range(2):
            # Usando Lei dos Senos
            turtle.forward(largura - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45) )
            turtle.right(90+45)

            turtle.forward(profundidade - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45) )
            turtle.right(45)

        turtle.end_fill()

        # Voltando a posição original
        turtle.penup()
        turtle.right(135/2)
        turtle.backward(tamCalcada)
        turtle.left(135/2)
        turtle.pendown()


    def linhaQuarteiroes(self, numQuarteiroes, larguraRua, largura, profundidade, tamCalcada=0):
        """
        Desc: Desenha uma linha de quarteirões

        numQuarteiroes= Int: Quantidade de quarteiroes em uma linha
        larguraRua    = Int: Largura da rua
        largura       = Int: Tamanho da linha dos quarteiroes
        profundidade  = Int: Profundidade dos quarteirões
        random        = Boolean: Randomiza profundiade dos quarteirões: random.randInt(int(profundidade*2/3), profundidade)
        tamCalcada    = Int: Tamanho da calçada ( faz parte do quarteirão )
        """

        ### Definindo variáveis ###
        # Variáveis gerais
        #self._posIni = turtle.pos()
        self._qTamanhoLarg = []
        self._tamQuarteiroesSomados = 0


        # Formatando Variáveis


        #  Largura da rua
        if largura < larguraRua*(numQuarteiroes-1):

            self.janelaErro("Erro: larguraRua < larguraRua*(numQuarteiroes-1)")
            #print("Erro: larguraRua < larguraRua*(numQuarteiroes-1)")
            exit()
        else:
            largura = largura-larguraRua*(numQuarteiroes-1)


        #  Largura dos quarteirões
        #  Adiciona a lista self._qTamanhoLarg
        for a in range(0, numQuarteiroes):
            if (a+1 != numQuarteiroes):
                self._qTamanhoLarg.append( random.randint(int(largura/numQuarteiroes) - int(largura/10),
                                                         (int(largura/numQuarteiroes) + int(largura/10))
                                                          )
                                          )
            # Definindo tamanho do último quarteirão
            else:
                # Soma todos os quarteirões
                for b in self._qTamanhoLarg:
                    self._tamQuarteiroesSomados = b + self._tamQuarteiroesSomados

                # Adiciona o tamanho do úlimo quarteirão
                self._qTamanhoLarg.append( largura - self._tamQuarteiroesSomados )
                self._tamQuarteiroesSomados = self._tamQuarteiroesSomados + (largura - self._tamQuarteiroesSomados)


        ### Desenhando os quarteirões ###
        for a in self._qTamanhoLarg:
            # Base
            self.quarteirao(a, profundidade, tamCalcada)
            # Casas
            self.quarteiraoPredios(a, profundidade, tamCalcada)

            turtle.penup()
            turtle.forward(a)
            turtle.forward(larguraRua)
            turtle.pendown()


        turtle.penup()
        # Voltando quarteirões
        turtle.backward(self._tamQuarteiroesSomados)
        # Voltando ruas
        turtle.backward(numQuarteiroes*larguraRua)
        turtle.pendown()

        """
        turtle.penup()
        print(turtle.pos())
        turtle.setpos(self._posIni)
        print(turtle.pos())
        turtle.pendown()
        """


    def quarteiraoPredios(self, largura, profundidade, tamCalcada=0):
        """
        Desc: Desenha os prédios em um quarteirão

        largura      = Int: Largura do quarteirão
        profundidade = Int: Profundidade do quarteirão
        tCalcada     = Int: Tamanho da calçada ( faz parte do quarteirão )
        """
        # Ajeitando/definindo algumas variáveis
        if self._tamPadrao == "":
            self._tamPadrao = 50

        # Se posicionando para desenhar quarteirão (considerando a calçada)
        turtle.penup()
        turtle.right(135/2)
        turtle.forward(tamCalcada)
        turtle.left(135/2)
        turtle.pendown()

        # Desenhando os prédios de costas
        self._numPredios      = int((largura - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45))/self._tamPadrao)
        #    Espaço livre                     Largura do quarteirão - calçada                           -          Espaço ocupado
        self._numPrediosResto =     (largura - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45) ) - self._numPredios*self._tamPadrao

        if self._numPredios != 0:
            self._calcadaLateral  = self._numPrediosResto/self._numPredios/2

        for d in range(self._numPredios):
            turtle.penup()
            turtle.forward(self._calcadaLateral)
            turtle.pendown()

            self._predioSorteado = matematica.sortearPeso(self.sorteioPrediosInv)
            if self._predioSorteado == "casaInv":
                self.casaInv(random.randint(40, 50), self._tamPadrao, 30)
            elif self._predioSorteado == "hotelInv":
                self.hotelInv(random.randint(75, 100), self._tamPadrao, 50)
            else:
                self.janelaErro("Elemento não conhecido em 'self.sorteioPredios': " + self._predioSorteado)

            turtle.penup()
            turtle.forward(self._tamPadrao)
            turtle.forward(self._calcadaLateral)
            turtle.pendown()

        # Voltando à posição inicial dos predios de costas
        turtle.penup()
        turtle.backward(largura - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45))#(self._numPredios*self._tamPadrao)
        turtle.pendown()

        # Desenhando os prédios de frente
        #  Posicionando
        turtle.penup()
        turtle.right(135)
        turtle.forward(profundidade - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45))
        turtle.left(135)
        turtle.pendown()

        for d in range(self._numPredios):

            turtle.penup()
            turtle.forward(self._calcadaLateral)
            turtle.pendown()

            # Preparando variável
            self._predioSorteado = matematica.sortearPeso(self.sorteioPredios)

            if self._predioSorteado == "casa":
                self.casa(random.randint(40, 50), self._tamPadrao, 30)
            elif self._predioSorteado == "hotel":
                self.hotel(random.randint(75, 100), self._tamPadrao, 50)
            else:
                self.janelaErro("Elemento não conhecido em 'self.sorteioPredios': " + self._predioSorteado)

            turtle.penup()
            turtle.forward(self._tamPadrao)
            turtle.forward(self._calcadaLateral)
            turtle.pendown()

        turtle.backward(largura - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45))

        # Se reposicioando
        turtle.penup()
        turtle.right(135)
        turtle.backward(profundidade - 2*(matematica.sen(67.5)*tamCalcada)/matematica.sen(45))
        turtle.left(135)

        turtle.right(135/2)
        turtle.backward(tamCalcada)
        turtle.left(135/2)
        turtle.pendown()

def init():
    pass

####################################################################
####################      Fazer cidade     #########################
####################################################################
if __name__ == '__main__':
    cb = cidadeBela()

    """
    # Selecionando cores
    cb.janelaErro(cb.janelaCores("Hex"))

    # Sortear umas cores...
    coresSot = []
    for a in range(20):
        coresSort.append(cores.sortearcor("RGB"))
    print(coresSort)
    """

    #print(__file__)

    """
    # Testando verificador de posição
    cb.getPos()
    portas.porta5(1)
    turtle.forward(5)
    turtle.left(0.00000009)
    print(cb.verificarPos())
    """

    cb.cidade_2(2)
    cb.janelaFixar()
