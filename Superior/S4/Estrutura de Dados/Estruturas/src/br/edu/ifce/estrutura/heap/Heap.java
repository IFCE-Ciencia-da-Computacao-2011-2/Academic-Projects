package br.edu.ifce.estrutura.heap;

public class Heap<E> {

	private final int POSICAO_RAIZ = 1;
	private Elemento<E>[] arvore;
	private int tamanho = 0;

	public Heap(int tamanhoMaximo) {
		this.arvore = new Elemento[tamanhoMaximo];
	}

	public Elemento<E> extrairMinimo() {
		if (size() == 0)
			return null;

		final Elemento<E> minimo = minimo();
		
		arvore[POSICAO_RAIZ] = null;
		swap(POSICAO_RAIZ, tamanho);
		tamanho--;

		bubbleDown(POSICAO_RAIZ);

		return minimo;
	}

	private void bubbleDown(int posicao) {
		while (hasAlgumFilhoMenor(posicao)) {
			int posicaoDoMenor = menorFilhoDe(posicao);
			swap(posicao, posicaoDoMenor);
			posicao = posicaoDoMenor;
		}
	}

	private int menorFilhoDe(int posicao) {
		Elemento<E> filhoEsquerda = getFilhoAEsquerdaDe(posicao);
		Elemento<E> filhoDireita  = getFilhoADireitaDe(posicao);

		if (filhoDireita == null)
			return POS_FILHO_ESQUERDA(posicao);
		else
			return filhoEsquerda.prioridade < filhoDireita.prioridade ? POS_FILHO_ESQUERDA(posicao) : POS_FILHO_DIREITA(posicao);
	}

	private Elemento<E> getFilhoADireitaDe(int posicao) {
		int filho = POS_FILHO_DIREITA(posicao);
		return filho >= arvore.length ? null : arvore[filho];
	}

	private Elemento<E> getFilhoAEsquerdaDe(int posicao) {
		int filho = POS_FILHO_ESQUERDA(posicao);
		return filho >= arvore.length ? null : arvore[filho];
	}

	private boolean hasAlgumFilhoMenor(int posicao) {
		Elemento<E> filhoEsquerda = getFilhoAEsquerdaDe(posicao);
		Elemento<E> filhoDireita  = getFilhoADireitaDe(posicao);

		return (filhoEsquerda != null && filhoEsquerda.prioridade < arvore[posicao].prioridade)
			||  filhoDireita  != null && filhoDireita.prioridade  < arvore[posicao].prioridade;
	}

	private int POS_FILHO_ESQUERDA(int posicao) {
		return posicao*2;
	}

	private int POS_FILHO_DIREITA(int posicao) {
		return posicao*2 + 1;
	}

	public Elemento<E> minimo() {
		return arvore[POSICAO_RAIZ];
	}

	public void add(int prioridade, E elemento) {
		arvore[tamanho+1] = new Elemento<E>(prioridade, elemento);
		tamanho++;
		bubbleUp(tamanho);
	}

	/**
	 * @param posicao Posição do elemento a ser "corrigido"
	 * 		  "corrigido" -> A ser colocado na posição correta
	 */
	private void bubbleUp(int posicao) {
		int posicaoPai = posicao/2;

		while (posicao > POSICAO_RAIZ && arvore[posicao].prioridade < arvore[posicaoPai].prioridade) {
			swap(posicao, posicaoPai);

			posicao = posicaoPai;
			posicaoPai = posicao/2;
		}
	}
	
	private void swap(int indexA, int indexB) {
		Elemento<E> auxiliar = arvore[indexA];
		arvore[indexA] = arvore[indexB];
		arvore[indexB] = auxiliar;
	}

	public int size() {
		return tamanho;
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("[");
		for (int i = 0; i < arvore.length; i++) {
			Elemento<E> elemento = arvore[i];

			if (elemento == null) {
				builder.append("null, ");
			} else {
				builder.append(elemento.toString());
				builder.append(", ");
			}
		}
		builder.append("]");
		
		return builder.toString();
	}
}
