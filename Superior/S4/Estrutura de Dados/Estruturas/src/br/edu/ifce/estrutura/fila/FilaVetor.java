package br.edu.ifce.estrutura.fila;

import java.util.NoSuchElementException;

public class FilaVetor<Elemento> implements Fila<Elemento> {

	private static final int FATOR_CRESCIMENTO = 2;

	private Elemento[] elementos;

	private int primeiro;
	// Posição que se encontra o elemento do final da fila
	private int proximo;

	private int quantidade;

	public FilaVetor() {
		this(10);
	}

	@SuppressWarnings("unchecked")
	public FilaVetor(int quantidade) {
		primeiro = 0;
		proximo = 0;
		elementos = (Elemento[]) new Object[quantidade];
	}

	@Override
	public void enqueue(Elemento elemento) {
		if (isLotado())
			aumentarEspacoAo(FATOR_CRESCIMENTO);

		elementos[proximo] = elemento;
		proximo = proximoIndiceDe(proximo);

		quantidade++;
	}

	private boolean isLotado() {
		return quantidade == elementos.length;
	}

	private boolean apontaParaOFim(int ponteiro) {
		return ponteiro == elementos.length-1;
	}

	@Override
	public void dequeue() {
		if (isVazio())
			throw new NoSuchElementException();

		elementos[primeiro] = null;
		primeiro = proximoIndiceDe(primeiro);
		quantidade--;
	}
	
	private int proximoIndiceDe(int index) {
		return apontaParaOFim(index) ? 0 : index + 1;
	}

	private boolean isVazio() {
		return quantidade == 0;
	}

	@Override
	public Elemento first() {
		if (isVazio())
			throw new NoSuchElementException();

		return elementos[primeiro];
	}

	@Override
	public int size() {
		return quantidade;
	}

	private void aumentarEspacoAo(int fatorCrescimento) {
		FilaVetor<Elemento> fila = new FilaVetor<>(elementos.length * fatorCrescimento);
		
		while (!this.isVazio()) {
			Elemento elemento = this.first();
			this.dequeue();

			fila.enqueue(elemento);
		}
		
		substituirPor(fila);
	}

	private void substituirPor(FilaVetor<Elemento> fila) {
		this.elementos = fila.elementos;
		this.primeiro = fila.primeiro;
		this.proximo = fila.proximo;
		this.quantidade = fila.quantidade;
	}
}