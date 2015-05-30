#! /usr/bin/env python
# -*- encoding: utf-8 -*-
# -*- python -*-

####################################################################
# Importando
import turtle
import sys

import random
import math

from sys import path

#path.append('cidadeBela')
#print(path)

from cb import *

from cidadeBela.tetos   import tetos
from cidadeBela.portas  import portas
from cidadeBela.janelas import janelas


# Configurações
py2 = py30 = py31 = False
version = sys.hexversion
if version >= 0x020600F0 and version < 0x03000000 :
    py2 = True    # Python 2.6 or 2.7
    from Tkinter import *
    import ttk
elif version >= 0x03000000 and version < 0x03010000 :
    py30 = True
    from tkinter import *
    import ttk
elif version >= 0x03010000:
    py31 = True
    from tkinter import *
    import tkinter.ttk as ttk
else:
    print ("""
    You do not have a version of python supporting ttk widgets..
    You need a version >= 2.6 to execute PAGE modules.
    """)
    sys.exit()

####################################################################


####################################################################
# Classe construtura da janela_principal

class janelaPrincipal:

    # Método inicial
    def __init__(self, master=None):
        """
        Desc: Criando janelaPrincipal

        Para ter controle para a janela, use:
        self.janelaPrincipal
        """

        # Definindo variáveis globais
        global cb
        #  Variável da janela filha
        self.lista = None
        #  Neta...
        self.visElem = None


        # Chamando cidadeBela
        cb = cidadeBela()

        # Características da janela
        master.title('Cidade Bela')
        master.iconbitmap(default='icone.ico')

        master.geometry('592x231+381+127')
        master.resizable(FALSE,FALSE)

        # Se fechar a janela
        master.protocol("WM_DELETE_WINDOW", self.botaoFechar)

        # Colocando os widgets
        self._widgets(master)

        # Manipular internamente e externamente a janela
        self.janelaPrincipal = master


    # Widgets
    def _widgets(self, master=None):
        """
        Desc: Insere os widgets na janela
        """
        # Set background of toplevel window to match
        # current style
        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)

        """"""
        # Top Menu
        self.m48 = Menu(master)
        master.configure(menu = self.m48)
        self.m48.add_command(label="Novo",command=self._novo)
        self.m48.add_command(label="Sobre",command=self._sobre)
        """"""

        # Frame
        self.tLa33 = ttk.Labelframe (master)
        self.tLa33.place(relx=0.03,rely=0.35,relheight=0.58,relwidth=0.9)
        self.tLa33.configure(text="Selecione o tipo de cidade")
        self.tLa33.configure(width="535")
        self.tLa33.configure(height="135")

        # Botões
        self.tLa33_tBu36 = ttk.Button (self.tLa33)
        self.tLa33_tBu36.place(relx=0.17,rely=0.3)
        self.tLa33_tBu36.configure(width="28")
        self.tLa33_tBu36.configure(takefocus="")
        self.tLa33_tBu36.configure(text="Cidade menos populosa")
        self.tLa33_tBu36.configure(command=self._cidadeMenosPopulosa)

        self.tLa33_cpd37 = ttk.Button (self.tLa33)
        self.tLa33_cpd37.place(relx=0.17,rely=0.59)
        self.tLa33_cpd37.configure(width="28")
        self.tLa33_cpd37.configure(takefocus="")
        self.tLa33_cpd37.configure(text="Cidade mais populosa")
        self.tLa33_cpd37.configure(command=self._cidadeMaisPopulosa)

        self.tLa33_tBu32 = ttk.Button (self.tLa33)
        self.tLa33_tBu32.place(relx=0.6,rely=0.44)
        self.tLa33_tBu32.configure(takefocus="")
        self.tLa33_tBu32.configure(text="Customizar cidades")
        self.tLa33_tBu32.configure(width="25")
        self.tLa33_tBu32.configure(command=self._cidadeCustomizar)


    # Ações
    #  Menu
    def _novo(self):
        """
        Desc: Cria uma nova janela de desenho
        """
        cb.janelaFechar()
        cb.__init__()
        self.janelaPrincipal.focus_set()
        self.janelaPrincipal.lift()

    def _sobre(self):
        """
        Desc: Mostra a cb.janelaSobre()
        """
        if cb.janSobre:
            #Mudar o foco para a janela sobre
            cb.janSobre.focus_set()
            return

        cb.janelaSobre()


    #  Botões
    def _cidadeMenosPopulosa(self):
        """
        Desc: Botão: Cidade menos populosa
        """
        # Minimizar janela
        self.janelaPrincipal.iconify()

        cb.janelaLimpar()

        cb.corFundo = "#d9fbdf"
        cb.sorteioPredios    = [["casa", 10], ["hotel", 2]]
        cb.sorteioPrediosInv = [["casaInv", 10], ["hotelInv", 2]]

        cb.cidade_2(5)

        # Maxmizar janela
        self.janelaPrincipal.deiconify()

        cb.janelaFixar()

    def _cidadeMaisPopulosa(self):
        """
        Desc: Botão: Cidade mais populosa
        """
        # Minimizar janela
        self.janelaPrincipal.iconify()

        cb.janelaLimpar()

        cb.sorteioPredios    = [["casa", 2], ["hotel", 10]]
        cb.sorteioPrediosInv = [["casaInv", 2], ["hotelInv", 10]]

        cb.cidade_2(5)

        # Maxmizar janela
        self.janelaPrincipal.deiconify()

        cb.janelaFixar()

    #  Testes
    def _cidadeCustomizar(self):
        """
        Desc: Botão: Customizar cidades
        """
        if self.lista:
            #Mudar o foco para a janela Janelas
            self.lista.janelaListas.focus_set()
            return

        self.lista = janelaListas(janelaMestre=root, master=self.lista)
        # Selecionar 'Janelas' automaticamente
        self.lista.m58_men59.invoke( 2 )
        self.lista.janelaListas.focus_set()


    #############################
    def botaoFechar(self):
        """
        Desc: Botão: Fechar
        Fecha a janela atual
        """
        # Verificar se algum dado foi alterado
        self._caixaDialogo = messagebox.askyesnocancel(master=self.janelaPrincipal, title="Fechar Cidade Bela",
                                        message="Você deseja fechar também a Janela de desenho?")

        if self._caixaDialogo == True:
            self.destroy(self.janelaPrincipal)
            cb.janelaFechar()
        elif self._caixaDialogo == False:
            self.destroy(self.janelaPrincipal)


    def destroy(self, master):
        """
        Desc: master.destroy()
        """
        master.destroy()
####################################################################


####################################################################

class janelaListas:

    # Método inicial
    def __init__(self, janelaMestre=None, master=None):
        """
        Desc: Criando janelaListas

        Para ter controle para a janela, use:
        self.janelaListas
        """

        # Verificar se janela já EXISTE
        #  Nem sei se assim funciona, então, DRECAPTED
        #if master:
        #    return

        # Definindo variáveis
        global cb

        #  Janelas dos prédios
        self.janelasHotel = cb.janelasHotel
        self.janelasCasa  = cb.janelasCasa
        self.janelasLoja  = cb.janelasLoja
        self.janelasTodas = cb.janelasTodas

        #  Tetos dos prédios
        self.tetosHotel = cb.tetosHotel
        self.tetosCasa  = cb.tetosCasa
        self.tetosLoja  = cb.tetosLoja
        self.tetosTodas = cb.tetosTodas

        #  Portas dos prédios
        self.portasHotel = cb.portasHotel
        self.portasCasa  = cb.portasCasa
        self.portasLoja  = cb.portasLoja
        self.portasTodas = cb.portasTodas


        # Características da janela
        master = Toplevel(janelaMestre)
        master.title('Configurando objetos')

        master.geometry('402x324+363+93')
        master.resizable(FALSE,FALSE)

        # Se fechar
        master.protocol("WM_DELETE_WINDOW", self.botaoFechar)

        # Colocando os widgets
        self._widgets(master)

        # Manipular internamente e externamente a janela
        self.janelaListas = master

    #############################
    # Widgets
    def _widgets(self, master=None):
        """
        Desc: Insere os widgets na janela
        """

        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)


        # Top Menu
        self.m58 = Menu(master)
        master.configure(menu = self.m58)

        self.m58_men59 = Menu(master, tearoff=0, )
        self.m58.add_cascade(label="Elementos", menu=self.m58_men59)
        self.m58_men59.add_command(label="Selecione o elemento:", state="disabled")
        self.m58_men59.add_separator()
        # Radio selecionado
        self.menuElementoSelec = "" #"Janelas"
        self.m58_men59.add_radiobutton(label="Janelas", variable=self.menuElementoSelec, value="Janelas", command=self.menuElementosJanelas)
        self.m58_men59.add_radiobutton(label="Portas" , variable=self.menuElementoSelec, value="Portas" , command=self.menuElementosPortas )
        self.m58_men59.add_radiobutton(label="Tetos"  , variable=self.menuElementoSelec, value="Tetos"  , command=self.menuElementosTetos  )

        # ComboBox
        #  Label
        self.mes56 = Message (master)
        self.mes56.place(relx=0.47,rely=0.06,relheight=0.07,relwidth=0.13)
        self.mes56.configure(text="Prédio:")
        self.mes56.configure(width="70")

        #  Combobox
        self.tCo55 = ttk.Combobox (master, state="readonly")
        self.tCo55.place(relx=0.6,rely=0.06,relheight=0.06,relwidth=0.33)
        self.tCo55.configure(height="21")
        self.tCo55.configure(takefocus="")
        self.tCo55.configure(width="132")
        self.tCo55.configure(values=cb.predios)
        #  Mudando o ítem selecionado
        self.tCo55.set(cb.predios[0])
        self.tCo55.bind('<<ComboboxSelected>>', self.comboBoxMudado )


        # LaberFrame
        self.tLa46 = ttk.Labelframe (master)
        self.tLa46.place(relx=0.05,rely=0.19,relheight=0.69,relwidth=0.88)
        self.tLa46.configure(text="Configurando lista")
        self.tLa46.configure(width="355")
        self.tLa46.configure(height="225")


        # Textos
        self.cpd50 = Message (master)
        self.cpd50.place(relx=0.1,rely=0.27,relheight=0.07,relwidth=0.23)
        self.cpd50.configure(text="Lista de ítens")
        self.cpd50.configure(width="100")

        self.cpd49 = Message (master)
        self.cpd49.place(relx=0.62,rely=0.27,relheight=0.07,relwidth=0.25)
        self.cpd49.configure(text="Todas os ítens")
        self.cpd49.configure(width="100")




        # ListBox
        self.tLa46_lis51 = Listbox (self.tLa46) #, selectmode=EXTENDED)
        self.tLa46_lis51.place(relx=0.03,rely=0.22,relheight=0.73,relwidth=0.35)
        self.tLa46_lis51.configure(background="white")

        self.tLa46_lis52 = Listbox (self.tLa46) #, selectmode=EXTENDED)
        self.tLa46_lis52.place(relx=0.62,rely=0.22,relheight=0.73,relwidth=0.35)
        self.tLa46_lis52.configure(background="white")


        # Botões
        self.cpd47 = ttk.Button (master)
        self.cpd47.place(relx=0.395,rely=0.48)
        self.cpd47.configure(takefocus="")
        self.cpd47.configure(text="Inserir")
        self.cpd47.configure(command=self.botaoInserir)

        self.cpd48 = ttk.Button (master)
        self.cpd48.place(relx=0.395,rely=0.58)
        self.cpd48.configure(takefocus="")
        self.cpd48.configure(text="Remover")
        self.cpd48.configure(command=self.botaoRemover)


        # Botões
        self.tBu33 = ttk.Button (master)
        self.tBu33.place(relx=0.025,rely=0.9)
        self.tBu33.configure(takefocus="")
        self.tBu33.configure(text="Visualizar elemento")
        self.tBu33.configure(command=self.botaoVisualizar)

        self.tBu53 = ttk.Button (master)
        self.tBu53.place(relx=0.57,rely=0.9)
        self.tBu53.configure(takefocus="")
        self.tBu53.configure(text="Alterar")
        self.tBu53.configure(command=self.botaoAlterar)

        self.tBu54 = ttk.Button (master)
        self.tBu54.place(relx=0.77,rely=0.9)
        self.tBu54.configure(takefocus="")
        self.tBu54.configure(text="Cancelar")
        self.tBu54.configure(command=self.botaoFechar)


    #############################


    #############################
    # Mechendo nos valores da janela
    def listBoxEncher(self, listbox, elementos):
        """
        Desc: Insere elementos em uma lista

        listbox  = Tkinter.listBox: ListBox na qual serão pegos os elementos
        elementos= List: Lista dos elementos que serão inseridos

        Retorna: List: Lista de elementos
        """

        # Inserindo os elementos
        for elem in elementos:
            listbox.insert(END, elem)


    def listBoxLimpar(self, listbox):
        """
        Desc: Limpar todos os elementos de uma lista

        listbox = Tkinter.listBox: ListBox na qual os elementos serão apagados
        """
        listbox.delete(0, END)


    def listboxPegarTodosElem(self, listbox):
        """
        Desc: Retorna todos os elementos de um determinado listbox

        listbox = Tkinter.listBox: ListBox na qual serão pegos os elementos

        Retorna: List: Lista de elementos
        """

        self._lista = []

        # Pegando todos os elementos
        for id in range(listbox.size()):
            self._lista.append(listbox.get(id))

        return self._lista


    def listboxPegarLabelElemIndividual(self, listbox, id):
        """
        Desc: Retorna todos os elementos de um determinado listbox

        listbox = Tkinter.listBox: ListBox na qual serão pegos os elementos
        listbox = List: Lista com a id do elemento sendo o 1 elemento

        Retorna: String: Label do elemento selecionado
        """

        self._retorno = []

        for a in range(len(id)):
            self._retorno.append(self.listboxPegarTodosElem(listbox)[int(id[a])])


        if len(self._retorno) == 1:
            return self._retorno[0]
        else:
            return self.listboxPegarTodosElem(listbox)[int(id[0])]


    def _listasRemoverElemRepetidos(self, lista1, lista2):
        """
        Desc: Remove todos os elementos da lista2 que já estão na lista1

        lista1 = List: Lista no qual serão comparados os elementos
        lista2 = List: Lista no qual serão retirados os elementos

        Retorna: lista2 sem elementos que lista1 possui
        """
        self._retorno = list(lista2)

        for elem in lista1:
            if elem in self._retorno:
                self._retorno.remove(elem)

        return self._retorno


    #############################


    #############################
    # Ações dos botões
    #  TopMenu
    def menuElementosJanelas(self):
        """
        Desc: Menu: Elementos->Janelas
        """

        # Radio selecionado
        self.menuElementoSelec = "Janelas"

        # Limpando os listBox
        self.listBoxLimpar(self.tLa46_lis51)
        self.listBoxLimpar(self.tLa46_lis52)

        # Inserindo elementos
        #  ListBox da esquerda
        if self.comboBoxSelecionado(self.tCo55) == "Casa":
            self.listBoxEncher(self.tLa46_lis51, self.janelasCasa)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.janelasHotel, self.janelasTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listasRemoverElemRepetidos(self.janelasCasa, self.janelasTodas))

        elif self.comboBoxSelecionado(self.tCo55) == "Hotel":

            self.listBoxEncher(self.tLa46_lis51, self.janelasHotel)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.janelasHotel, self.janelasTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listasRemoverElemRepetidos(self.janelasHotel, self.janelasTodas))


    def menuElementosPortas(self):
        """
        Desc: Menu: Elementos->Portas
        """
        # Radio selecionado
        self.menuElementoSelec = "Portas"

        # Limpando os listBox
        self.listBoxLimpar(self.tLa46_lis51)
        self.listBoxLimpar(self.tLa46_lis52)

        # Inserindo elementos
        if self.comboBoxSelecionado(self.tCo55) == "Casa":
            self.listBoxEncher(self.tLa46_lis51, self.portasCasa)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.portasCasa, self.portasTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listaRemovida)

        elif self.comboBoxSelecionado(self.tCo55) == "Hotel":
            self.listBoxEncher(self.tLa46_lis51, self.portasHotel)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.portasHotel, self.portasTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listaRemovida)


    def menuElementosTetos(self):
        """
        Desc: Menu: Elementos->Tetos
        """
        # Radio selecionado
        self.menuElementoSelec = "Tetos"

        # Limpando os listBox
        self.listBoxLimpar(self.tLa46_lis51)
        self.listBoxLimpar(self.tLa46_lis52)

        # Inserindo elementos
        if self.comboBoxSelecionado(self.tCo55) == "Casa":
            self.listBoxEncher(self.tLa46_lis51, self.tetosCasa)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.tetosCasa, self.tetosTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listaRemovida)

        elif self.comboBoxSelecionado(self.tCo55) == "Hotel":
            self.listBoxEncher(self.tLa46_lis51, self.tetosHotel)

            self._listaRemovida = self._listasRemoverElemRepetidos(self.tetosHotel, self.tetosTodas)
            self.listBoxEncher(self.tLa46_lis52, self._listaRemovida)


    #  Combobox
    def comboBoxMudado(self, comboBox):
        """
        Desc: Menu: Elementos->Janelas
        """
        if self.comboBoxSelecionado(comboBox) == "Casa":

            if self.menuElementoSelec == "Janelas":
                self.menuElementosJanelas()
            elif self.menuElementoSelec == "Portas":
                self.menuElementosPortas()
            elif self.menuElementoSelec == "Tetos":
                self.menuElementosTetos()

        elif self.comboBoxSelecionado(comboBox) == "Hotel":

            if self.menuElementoSelec == "Janelas":
                self.menuElementosJanelas()
            elif self.menuElementoSelec == "Portas":
                self.menuElementosPortas()
            elif self.menuElementoSelec == "Tetos":
                self.menuElementosTetos()

    def comboBoxSelecionado(self, comboBox=""):
        """
        Desc: Retorna o elemento selecionado de self.tCo55.get()

        combobox: INUTIO

        Retorna: Elemento selecionado de self.tCo55.get()
        """
        return self.tCo55.get()


    #  Botões
    def botaoInserir(self):
        """
        Desc: Botão: Inserir
        """
        # Formatando variáveis
        self._elementosRemAd = []

        # Removendo elementos
        #  Pegando elementos selecionados
        self.listasInserir = list(self.tLa46_lis52.curselection())

        if len(self.listasInserir) > 0:
            for elem in self.listasInserir:

                # Inserindo elemento que será escluído
                self._elementosRemAd.append(self.tLa46_lis52.get(elem))
                # Removendo da lista
                self.tLa46_lis52.delete(int(elem))


        # Inserindo elemento
        self.listBoxEncher(self.tLa46_lis51, self._elementosRemAd)


        # Alterando atributos da cidadeBela
        if self.menuElementoSelec == "Janelas":
            exec("self.janelas"+ str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))
        elif self.menuElementoSelec == "Portas":
            exec("self.portas" + str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))
        elif self.menuElementoSelec == "Tetos":
            exec("self.tetos"  + str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))


    def botaoRemover(self):
        """
        Desc: Botão: Remover
        """
        # Formatando variáveis
        self._elementosRemAd = []

        # Removendo elemento
        #  Pegando elementos selecionados
        self.listasRemover = list(self.tLa46_lis51.curselection())

        self._resto = len(self.listboxPegarTodosElem(self.tLa46_lis51)) - len(self.listasRemover)


        if len(self.listasRemover) > 0  and  self._resto > 0:

            for elem in self.listasRemover:

                # Inserindo elemento que será escluído
                self._elementosRemAd.append(self.tLa46_lis51.get(elem))
                # Removendo da lista
                self.tLa46_lis51.delete(int(elem))


        # Inserindo elemento
        self.listBoxEncher(self.tLa46_lis52, self._elementosRemAd)


        # Alterando atributos da cidadeBela
        if self.menuElementoSelec == "Janelas":
            exec("self.janelas"+ str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))
        elif self.menuElementoSelec == "Portas":
            exec("self.portas" + str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))
        elif self.menuElementoSelec == "Tetos":
            exec("self.tetos"  + str(self.comboBoxSelecionado(self.tCo55)) + " = " + str(self.listboxPegarTodosElem(self.tLa46_lis51)))

    def botaoAlterar(self):
        """
        Desc: Botão: Alterar
        Atualiza os elementos
        """
        #  Janelas dos prédios
        cb.janelasHotel = self.janelasHotel
        cb.janelasCasa  = self.janelasCasa
        cb.janelasLoja  = self.janelasLoja
        cb.janelasTodas = self.janelasTodas

        #  Tetos dos prédios
        cb.tetosHotel = self.tetosHotel
        cb.tetosCasa  = self.tetosCasa
        cb.tetosLoja  = self.tetosLoja
        cb.tetosTodas = self.tetosTodas

        #  Portas dos prédios
        cb.portasHotel = self.portasHotel
        cb.portasCasa  = self.portasCasa
        cb.portasLoja  = self.portasLoja
        cb.portasTodas = self.portasTodas


        # Fechando janela
        self.destroy(self.janelaListas)
        janPrincipal.lista = None

    def botaoVisualizar(self):
        """
        Desc: Botão: Visualizar Elemento
        Mostra o elemento seleciona na janela Visualizar elemento
        """

        # Pegar label do elemento selecionado
        self._elemento = []

        self._lista1 = list(self.tLa46_lis51.curselection())
        self._lista2 = list(self.tLa46_lis52.curselection())

        #  Se não tiver nenhum elemento selecionado nas duas listBox
        if self._lista1 == [] and self._lista2 == []:
            self._lista1 = ['0']

        #  self._lista1 só ficará vazia quando algum elemento de self._lista2
        #  estiver selecionado
        if self._lista1 == []:
            self._elemento.append( self._lista2 )
            self._elemento.append( self.listboxPegarLabelElemIndividual(self.tLa46_lis52, self._lista2) )
        else:
            self._elemento.append( self._lista1 )
            self._elemento.append( self.listboxPegarLabelElemIndividual(self.tLa46_lis51, self._lista1) )

        # Ver elemento selecionado
        # print(self._elemento[1])


        # Verificar se a janela já existe
        if janPrincipal.visElem:
            #Mudar o foco para a janela Janelas
            janPrincipal.visElem.visualizarElemento.focus_set()
            janPrincipal.visElem.desenharElem(self.menuElementoSelec, self._elemento[1])
            return

        # Criar janela
        janPrincipal.visElem = visualizarElemento(janelaMestre=self.janelaListas, master=janPrincipal.visElem)
        janPrincipal.visElem.visualizarElemento.focus_set()

        janPrincipal.visElem.desenharElem(self.menuElementoSelec, self._elemento[1])


    def botaoFechar(self):
        """
        Desc: Botão: Fechar
        Fecha a janela atual
        """
        # Verificar se algum dado foi alterado
        self._caixaDialogo = messagebox.askokcancel(master=self.janelaListas, title="Fechar janela", message="Você deseja fechar a janela?\nDados não foram atualizados!")

        if self._caixaDialogo == True:
            self.destroy(self.janelaListas)
            janPrincipal.lista = None
            janPrincipal.visElem = None
        else:
            self.janelaListas.focus_set()

    #############################


    #############################

    def destroy(self, master):
        """
        Desc: master.destroy()
        """
        master.destroy()

####################################################################


####################################################################

class visualizarElemento:
    def __init__(self, janelaMestre, master=None):
        """
        Desc: Criando visualizarElemento

        Para ter controle para a janela, use:
        self.visualizarElemento
        """

        # Definindo variáveis globais
        global cb


        #  Janela
        self.janela = None

        # Configurações da janela
        master = Toplevel(janelaMestre)

        master.title('Visualizar elemento')
        master.geometry('250x150+765+110')

        master.resizable(FALSE,FALSE)

        # Se fechar
        master.protocol("WM_DELETE_WINDOW", self.botaoFechar)


        # Colocando os widgets
        self._widgets(master)

        #          Tartaruga
        #Isso após de colocar os Widgets
        # Criando playground (self.janTat) para a tartaruga (self.tat)
        #|janela de desenho|          |onde vai desenhar|
        self.janTat = turtle.TurtleScreen(self.canvas)
        self.tat = turtle.RawTurtle(self.janTat)



        # Manipular internamente e externamente a janela
        self.visualizarElemento = master



    #############################
    # Widgets
    def _widgets(self, master=None):
        """
        Desc: Insere os widgets na janela
        """

        # Set background of toplevel window to match
        # current style
        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)

        self.canvas = Canvas(master, width=250, height=150)
        self.canvas.place(relx=0.0,rely=0.0)
    #############################


    #############################
    # Desenhar um elemento
    def desenharElem(self, classe, metodo):
        """
        Desc: Funcção chamada por Botão: Visualizar Elemento
        Mostra o elemento seleciona na janela Visualizar elemento
        """

        # Limpar a janela
        self.tat.reset()

        # Configurações gerais da tat
        #self.tat.hideturtle()

        self.tat.penup()
        self.tat.right(90)
        self.tat.forward( 150/2 - 150/10 )
        self.tat.left(90)
        self.tat.pendown()


        # Desenhar elemento selecionado
        #  Selecionando a tat correta

        # Desenhar elemento
        #  Formatando elemento
        if classe == "Portas":
            portas.turtle  = self.tat
            self._string = "portas."
        elif classe == "Janelas":
            janelas.turtle = self.tat
            self._string = "janelas."
        elif classe == "Tetos":
            tetos.turtle   = self.tat
            self.tat.left(90)
            self._string = "tetos."
        else:
            cb.janelaErro("Classe selecionada estranha... o.O")

        self._string += metodo + "()"


        # Desenhar
        exec(self._string)
        #turtle.forward(25)

        #  Retornando a tat original
        '''
        if classe == "Portas":
            portas.turtle  = turtle.getturtle()
        elif classe == "Janelas":
            janelas.turtle = turtle.getturtle()
        elif classe == "Tetos":
            self.tat.right(90)
            tetos.turtle   = turtle.getturtle()
        else:
            cb.janelaErro("Classe selecionada estranha... o.O\n\"" + classe + "\"")
        '''
        portas.turtle  = turtle.getturtle()
        janelas.turtle = turtle.getturtle()
        tetos.turtle   = turtle.getturtle()


    #############################


    #############################
    def botaoFechar(self):
        """
        Desc: Botão: Fechar
        Fecha a janela atual
        """
        self.destroy(self.visualizarElemento)
        janPrincipal.visElem = None


    def destroy(self, master):
        """
        Desc: master.destroy()
        """
        master.destroy()

####################################################################
# Chamando janela se o arquivo for execultado
if __name__ == '__main__':
    # JanelaPrincipal (raiz)
    root = Tk()

    #Desenhando janelaPrincipal
    janPrincipal = janelaPrincipal(root)
    root.mainloop()
