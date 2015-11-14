package br.edu.ifce.estrutura.arvore;

import br.edu.ifce.estrutura.arvore.No;

class No<E> {
	public final int chave;
	public E valor;

	public No<E> pai;
	public No<E> esquerda;
	public No<E> direita;

	public No(int chave, E valor) {
		this.chave = chave;
		this.valor = valor;
	}
	
	public boolean hasPai() {
		return this.pai != null;
	}

	public boolean isFilhoADireita() {
		return hasPai() && pai.direita == this;
	}
	
	public boolean isFilhoAEsquerda() {
		return hasPai() && pai.esquerda == this;
	}
	
	public boolean isFolha() {
		return esquerda == null && direita == null;
	}

	public boolean hasUnicoFilho() {
		return esquerda == null && direita != null 
			|| direita == null && esquerda != null;
	}
}