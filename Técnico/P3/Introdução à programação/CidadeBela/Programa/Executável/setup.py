#!/usr/bin/env python
# -*- encoding: utf-8 -*-

# Compilador
from cx_Freeze import setup, Executable
#import cx_Freeze


setup(
    name = "cidadeBela",
    author = "Paulo Mateus, Gabriela Valentim, Samara Oliveira",
    author_email = "mateus.moura@hotmail.com",

    #url = "http://cx-oracletools.sourceforge.net",
    version = "0.3",
    description = "Programa cidadeBela",
    long_description = "Trabalho dos P4 de informática",

    license = "Leia LICENSE.txt",

    #build_exe = "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Programa",
    #target_dir = "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Programa",

    #cmdclass = dict(build_exe = build_exe),
    #options = ['Teste' = 'Teste'],

    executables = [Executable(
                    #"C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Trabalho\\cidadeBela\\janelaGrafica.py",
                    "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Trabalho\\trabalho\\cidadeBela.pyw",
                    #"E:\\Programação\\trabalho\\cidadeBela.pyw",
                    base = "Win32GUI",
                    icon = "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Trabalho\\cidadeBela\\icone.ico")]
                    #shortcutName = "cidadeBela.ico",
                    #shortcutDir  = "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Trabalho\\cidadeBela\\")]
                    #build_exe = "C:\\Documents and Settings\\Mateus\\Desktop\\cidadeBela\\Programa")]
)