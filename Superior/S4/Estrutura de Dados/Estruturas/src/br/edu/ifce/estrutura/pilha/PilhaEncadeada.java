package br.edu.ifce.estrutura.pilha;

import java.util.EmptyStackException;

public class PilhaEncadeada<Elemento> implements Pilha<Elemento> {

	private class Celula<E> {
		private E elemento;
		private Celula<E> proximo;

		public Celula(E elemento) {
			this.elemento = elemento;
		}

		public E elemento() {
			return elemento;
		}

		public Celula<E> proximo() {
			return proximo;
		}
		
		public void proximo(Celula<E> proximo) {
			this.proximo = proximo;
		}
	}

	private int quantidade;
	private Celula<Elemento> raiz;

	@Override
	public void push(Elemento elemento) {
		Celula<Elemento> novaRaiz = new Celula<>(elemento);

		novaRaiz.proximo(raiz);
		raiz = novaRaiz;

		quantidade++;
	}

	@Override
	public void pop() {
		if (isVazio())
			throw new EmptyStackException();

		raiz = raiz.proximo();
		quantidade--;
	}

	private boolean isVazio() {
		return quantidade == 0;
	}

	@Override
	public Elemento top() {
		if (isVazio())
			throw new EmptyStackException();

		return raiz.elemento();
	}

	@Override
	public int size() {
		return quantidade;
	}
}
