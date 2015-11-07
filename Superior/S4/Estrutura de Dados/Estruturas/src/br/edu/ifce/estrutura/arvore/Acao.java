package br.edu.ifce.estrutura.arvore;

interface Acao<E> {
	No<E> acao(No<E> no);
}