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
	
	public boolean isRaiz() {
		return this.pai == null;
	}

	public boolean isFilhoADireita() {
		return !isRaiz() && pai.direita == this;
	}
	
	public boolean isFilhoAEsquerda() {
		return !isRaiz() && pai.esquerda == this;
	}
	
	public boolean isFolha() {
		return esquerda == null && direita == null;
	}

	public boolean hasUnicoFilho() {
		return esquerda == null && direita != null 
			|| direita == null && esquerda != null;
	}
	
	public No<E> sucessor() {
		if (this.direita != null)
			return this.direita.min();

		No<E> no = this;
		while (no.isFilhoADireita())
			no = no.pai;

		return no.pai;
	}

	public No<E> min() {
		return this.esquerda == null 
			? this
			: this.esquerda.min();
	}

	public No<E> antecessor() {
		if (this.esquerda != null)
			return this.esquerda.max();

		No<E> no = this;
		while (no.isFilhoAEsquerda())
			no = no.pai;

		return no.pai;
	}

	public No<E> max() {
		return this.direita == null 
			? this
			: this.direita.max();
	}
}