#! /usr/bin/env python
# -*- encoding: utf-8 -*-
# -*- python -*-

# Importando
import sys

from cb import *

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

# Chamando classe
cb = cidadeBela()


# Classe da janela
def vp_start_gui():
    global val, w, root
    root = Tk()
    root.title('Cidade Bela v0.3')
    root.iconbitmap(default='icone.ico')
    root.geometry('592x231+381+127')
    w = janela_principal (root)
    init()
    root.mainloop()



def init():
    pass


# Ações

def novo():
    cb.fecharJanela()

def sobre():
    print("Cidade bela! xD")


def campo():
    #cb = cidadeBela()
    cb.limpartela()
    cb.cidade_2(2)
    cb.janelafixar()

def cidade():
    #cb = cidadeBela()
    cb.limpartela()
    cb.cidade_2(5)
    cb.janelafixar()


# Classe

class janela_principal:
    def __init__(self, master=None):
        # Set background of toplevel window to match
        # current style
        style = ttk.Style()
        theme = style.theme_use()
        default = style.lookup(theme, 'background')
        master.configure(background=default)

        """"""
        self.m48 = Menu(master)
        master.configure(menu = self.m48)
        self.m48.add_command(label="Novo",command=novo)
        self.m48.add_command(label="Sobre",command=sobre)
        """"""

        self.tLa33 = ttk.Labelframe (master)
        self.tLa33.place(relx=0.03,rely=0.35,relheight=0.58,relwidth=0.9)
        self.tLa33.configure(text="Selecione o tipo de cidade")
        self.tLa33.configure(width="535")
        self.tLa33.configure(height="135")

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







if __name__ == '__main__':
    vp_start_gui()
