package br.edu.ifce.estrutura.fila;

import java.util.NoSuchElementException;

public class FilaEncadeada<Elemento> implements Fila<Elemento> {

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

	private Celula<Elemento> raiz;
	private Celula<Elemento> rabo;
	private int quantidade = 0;

	@Override
	public void enqueue(Elemento elemento) {
		Celula<Elemento> celula = new Celula<Elemento>(elemento);

		if (isVazio())
			raiz = celula;
		else
			rabo.proximo(celula);

		rabo = celula;
		quantidade++;
	}

	@Override
	public void dequeue() {
		if (isVazio())
			throw new NoSuchElementException();
		
		raiz = raiz.proximo();
		quantidade--;
	}

	@Override
	public Elemento first() {
		if (isVazio())
			throw new NoSuchElementException();

		return raiz.elemento();
	}
	
	private boolean isVazio() {
		return quantidade == 0;
	}

	@Override
	public int size() {
		return quantidade;
	}
}
