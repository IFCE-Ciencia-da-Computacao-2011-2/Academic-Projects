#! /usr/bin/env python
# -*- encoding: utf-8 -*-
# -*- python -*-

####################################################################
# Importando
import sys


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


# Declarar janela TKINTER antes de importar cb
root = Tk()

from cb import *

####################################################################

#Chamando classe cidadeBela
cb = cidadeBela()

####################################################################
# Sei lá!
'''

#    If you use the following functions, change the names 'w' and
#    'w_win'.  Use as a template for creating a new Top-level window.

w = None
def create_janela_principal ():
    global w
    global w_win
    if w: # So we have only one instance of window.
        return
    w = Toplevel (root)
    w.title('janela_principal')
    w.geometry('592x231+381+127')
    w_win = janela_principal (w)

   #Template for routine to destroy a top level window.

def destroy():
    global w
    w.destroy()
    w = None
'''


####################################################################
# Criando janela


# Função chamada inicialmente
def vp_start_gui():
    global val, w, root

    # Características da janela
    root.title('Cidade Bela v0.3')
    root.iconbitmap(default='icone.ico')

    root.geometry('592x231+381+127')
    root.resizable(FALSE,FALSE)

    # Widgets da janela
    janela.janela_principal(root)
    init()

    root.mainloop()



def init():
    pass

####################################################################
# Ações da janela

def novo():
    cb.janelaFechar()

listas = None
def sobre():
    global listas
    global listas_janela
    global root

    # Se a janela "listas" já existe, não cria de novo
    if listas:
        return

    # Características da janela
    listas = Toplevel(root)
    listas.title('Janelas')
    listas.geometry('402x324+363+93')

    # Widgets da janela
    listas_janela = janela.janelas_editar_lista(listas)


def destroy():
    global listas
    listas.destroy()
    listas = None

def campo():
    cb.janelaLimpar()
    cb.cidade_2(2)
    cb.janelafixar()

def cidade():
    cb.janelaLimpar()
    cb.cidade_2(5)
    cb.janelafixar()

def teste():
    encherLinguica = True

####################################################################
# Classe construtura da janela_principal

class janelaGrafica:
    def __init__(self, master=None):
        # Set background of toplevel window to match
        # current style
        encherLinguica = True

    def janela_principal(self, master=None):
        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)

        """"""
        # Top Menu
        self.m48 = Menu(master)
        master.configure(menu = self.m48)
        self.m48.add_command(label="Novo",command=novo)
        self.m48.add_command(label="Sobre",command=sobre)
        """"""

        # Frame
        self.tLa33 = ttk.Labelframe (master)
        self.tLa33.place(relx=0.03,rely=0.35,relheight=0.58,relwidth=0.9)
        self.tLa33.configure(text="Selecione o tipo de cidade")
        self.tLa33.configure(width="535")
        self.tLa33.configure(height="135")

        # Botões
        self.tLa33_tBu36 = ttk.Button (self.tLa33)
        self.tLa33_tBu36.place(relx=0.15,rely=0.53)
        self.tLa33_tBu36.configure(takefocus="")
        self.tLa33_tBu36.configure(text="Campo")
        self.tLa33_tBu36.configure(command=campo)

        self.tLa33_cpd37 = ttk.Button (self.tLa33)
        self.tLa33_cpd37.place(relx=0.6,rely=0.53)
        self.tLa33_cpd37.configure(takefocus="")
        self.tLa33_cpd37.configure(text="Cidade")
        self.tLa33_cpd37.configure(command=cidade)

    def janelas_editar_lista(self, master=None):

        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)

        # Top Menu
        self.m58 = Menu(master)
        master.configure(menu = self.m58)
        self.m58_men59 = Menu(master,tearoff=0)
        self.m58.add_cascade(label="Elementos",menu=self.m58_men59)
        self.m58_men59.add_command(label="Selecione o elemento:",command=teste)
        self.m58_men59.add_separator()
        self.m58_men59.add_radiobutton(label="Janelas",command=teste)
        self.m58_men59.add_radiobutton(label="Portas",command=teste)
        self.m58_men59.add_radiobutton(label="Tetos",command=teste)

        self.tLa46 = ttk.Labelframe (master)
        self.tLa46.place(relx=0.05,rely=0.19,relheight=0.69,relwidth=0.88)
        self.tLa46.configure(text="Configurando lista")
        self.tLa46.configure(width="355")
        self.tLa46.configure(height="225")

        self.tLa46_lis51 = Listbox (self.tLa46)
        self.tLa46_lis51.place(relx=0.03,rely=0.22,relheight=0.73,relwidth=0.35)

        self.tLa46_lis51.configure(background="white")

        self.tLa46_lis52 = Listbox (self.tLa46)
        self.tLa46_lis52.place(relx=0.62,rely=0.22,relheight=0.73,relwidth=0.35)

        self.tLa46_lis52.configure(background="white")

        self.cpd47 = ttk.Button (master)
        self.cpd47.place(relx=0.39,rely=0.48)
        self.cpd47.configure(takefocus="")
        self.cpd47.configure(text="Inserir")

        self.cpd48 = ttk.Button (master)
        self.cpd48.place(relx=0.39,rely=0.58)
        self.cpd48.configure(takefocus="")
        self.cpd48.configure(text="Remover")

        self.cpd49 = Message (master)
        self.cpd49.place(relx=0.62,rely=0.27,relheight=0.07,relwidth=0.25)
        self.cpd49.configure(text="Todas as janelas")
        self.cpd49.configure(width="100")

        self.cpd50 = Message (master)
        self.cpd50.place(relx=0.1,rely=0.27,relheight=0.07,relwidth=0.23)
        self.cpd50.configure(text="Lista de janelas")
        self.cpd50.configure(width="100")

        self.tBu53 = ttk.Button (master)
        self.tBu53.place(relx=0.57,rely=0.9)
        self.tBu53.configure(takefocus="")
        self.tBu53.configure(text="Alterar")

        self.tBu54 = ttk.Button (master)
        self.tBu54.place(relx=0.77,rely=0.9)
        self.tBu54.configure(takefocus="")
        self.tBu54.configure(text="Cancelar")

        self.tCo55 = ttk.Combobox (master)
        self.tCo55.place(relx=0.6,rely=0.06,relheight=0.06,relwidth=0.33)
        self.tCo55.configure(height="21")
        self.tCo55.configure(takefocus="")
        self.tCo55.configure(textvariable="Teste")
        self.tCo55.configure(width="132")

        self.mes56 = Message (master)
        self.mes56.place(relx=0.47,rely=0.06,relheight=0.07,relwidth=0.13)
        self.mes56.configure(text="Prédio:")
        self.mes56.configure(width="70")

####################################################################
# Chamando janela se o arquivo for execultado
if __name__ == '__main__':
    janela = janelaGrafica()
    vp_start_gui()
