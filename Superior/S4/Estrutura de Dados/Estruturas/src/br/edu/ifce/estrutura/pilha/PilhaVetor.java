package br.edu.ifce.estrutura.pilha;

import java.util.EmptyStackException;

public class PilhaVetor<Elemento> implements Pilha<Elemento> {

	private static int FATOR_CRESCIMENTO = 2;

	private Elemento elementos[];
	private int quantidade;

	@SuppressWarnings("unchecked")
	public PilhaVetor() {
		elementos = (Elemento[]) new Object[10]; 
	}

	@Override
	public void push(Elemento elemento) {
		if (!podeAdicionar())
			aumentarEspacoAo(FATOR_CRESCIMENTO);

		elementos[quantidade] = elemento;
		quantidade++;
	}

	private boolean podeAdicionar() {
		return quantidade < elementos.length;
	}

	@SuppressWarnings("unchecked")
	private void aumentarEspacoAo(int fatorCrescimento) {
		Elemento[] novaListaDeElementos = (Elemento[]) new Object[elementos.length * fatorCrescimento];

		for (int i=0; i<this.elementos.length; i++)
			novaListaDeElementos[i] = this.elementos[i];

		this.elementos = novaListaDeElementos;
	}

	@Override
	public void pop() {
		if (isVazio())
			throw new EmptyStackException();

		quantidade--;
		elementos[quantidade] = null;
	}

	@Override
	public Elemento top() {
		if (isVazio())
			throw new EmptyStackException();

		return elementos[quantidade-1];
	}

	private boolean isVazio() {
		return quantidade == 0;
	}

	@Override
	public int size() {
		return quantidade;
	}
}
