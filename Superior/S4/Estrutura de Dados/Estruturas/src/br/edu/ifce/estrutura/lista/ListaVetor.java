package br.edu.ifce.estrutura.lista;

public class ListaVetor<Elemento> implements Lista<Elemento> {
	
	private static int FATOR_CRESCIMENTO = 2;

	private Object[] elementos;
	private int indiceLivre;
	
	public ListaVetor() {
		this(10);
	}

	public ListaVetor(int capacidadeInicial) {
		elementos = new Object[capacidadeInicial];
		this.indiceLivre = 0;
	}

	@Override
	public Elemento getElement(int index) {
		if (isForaDoIntervalo(index))
			throw new ArrayIndexOutOfBoundsException(index);

		return (Elemento) elementos[index];
	}

	private boolean isForaDoIntervalo(int index) {
		return index < 0 || index >= size();
	}

	@Override
	public void insert(Elemento elemento) {
		if (!podeAdicionar())
			aumentarEspacoAo(FATOR_CRESCIMENTO);

		elementos[indiceLivre] = elemento;
		indiceLivre++;
	}

	private boolean podeAdicionar() {
		return indiceLivre < elementos.length;
	}

	@Override
	public void insert(Elemento elemento, int index) {
		if (isForaDoIntervalo(index) && !isFinal(index))
			throw new ArrayIndexOutOfBoundsException(index);

		if (!podeAdicionar())
			aumentarEspacoAo(FATOR_CRESCIMENTO);

		for (int i=size(); i>index; i--)
			elementos[i] = elementos[i-1];

		elementos[index] = elemento;

		indiceLivre++;
	}

	private boolean isFinal(int index) {
		 return index == size();
	}

	private void aumentarEspacoAo(int fatorCrescimento) {
		Object[] novaListaDeElementos = new Object[elementos.length * fatorCrescimento];

		for (int i=0; i<this.elementos.length; i++)
			novaListaDeElementos[i] = this.elementos[i];

		this.elementos = novaListaDeElementos;
	}

	@Override
	public void remove(int index) {
		if (isForaDoIntervalo(index))
			throw new ArrayIndexOutOfBoundsException(index);
		
		for (int i=index+1; i<this.size(); i++)
			this.elementos[i-1] = this.elementos[i];

		indiceLivre--;
		elementos[indiceLivre] = null;
	}

	@Override
	public boolean contains(Elemento elemento) {
		for (int i=0; i<this.size(); i++)
			if (elementos[i].equals(elemento))
				return true;

		return false;
	}

	@Override
	public int size() {
		return indiceLivre;
	}
}