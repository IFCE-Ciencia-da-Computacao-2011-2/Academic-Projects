package br.edu.ifce.estrutura.fila;

import java.util.NoSuchElementException;

public class FilaVetor<Elemento> implements Fila<Elemento> {

	private static int FATOR_CRESCIMENTO = 2;

	private Elemento[] elementos;

	private int inicio;
	// Posição que se encontra o elemento do final da fila
	private int fim;

	private int quantidade;

	@SuppressWarnings("unchecked")
	public FilaVetor() {
		inicio = 0;
		fim = 0;
		elementos = (Elemento[]) new Object[10];
	}

	@Override
	public void enqueue(Elemento elemento) {
		if (!podeAdicionar())
			aumentarEspacoAo(FATOR_CRESCIMENTO);

		if (apontaParaOFim(fim) || fim == 0 && size() == 0)
			fim = -1;

		fim++;
		elementos[fim] = elemento;

		quantidade++;
	}

	private boolean apontaParaOFim(int ponteiro) {
		return ponteiro == elementos.length-1;
	}

	private boolean podeAdicionar() {
		return quantidade < elementos.length;
	}

	@Override
	public void dequeue() {
		if (isVazio())
			throw new NoSuchElementException();

		elementos[inicio] = null;

		if (apontaParaOFim(inicio))
			inicio = -1;

		inicio++;
		quantidade--;
		
		if (size() == 0)
			fim = 0;
	}

	private boolean isVazio() {
		return quantidade == 0;
	}

	@Override
	public Elemento first() {
		if (isVazio())
			throw new NoSuchElementException();

		return elementos[inicio];
	}

	@Override
	public int size() {
		return quantidade;
	}

	@SuppressWarnings("unchecked")
	private void aumentarEspacoAo(int fatorCrescimento) {
		Elemento[] novaListaDeElementos = (Elemento[]) new Object[elementos.length * fatorCrescimento];

		if (fim > inicio)
			novaListaDeElementos = reorganizarDeFormaNormal(novaListaDeElementos);
		else
			novaListaDeElementos = reorganizarDeFormaCuidadosa(novaListaDeElementos);

		inicio = 0;
		fim = quantidade-1;

		this.elementos = novaListaDeElementos;
	}

	private Elemento[] reorganizarDeFormaNormal(Elemento[] lista) {
		int j = 0;
		for (int i=inicio; i<=fim; i++) {
			lista[j] = this.elementos[i];
			j++;
		}

		return lista;
	}

	private Elemento[] reorganizarDeFormaCuidadosa(Elemento[] lista) {
		int j = 0;
		for (int i=inicio; i<this.elementos.length; i++) {
			lista[j] = this.elementos[i];
			j++;
		}

		for (int i=0; i<=this.fim; i++) {
			lista[j] = this.elementos[i];
			j++;
		}

		return lista;
	}
}