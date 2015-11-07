package br.edu.ifce.estrutura.lista;


public class ListaEncadeada<Elemento> implements Lista<Elemento> {
	
	private class Celula<E> {
		private E elemento;
		private Celula<E> proxima;

		public Celula(E elemento) {
			this.elemento = elemento;
			this.proxima = null;
		}
		
		private E elemento() {
			return elemento;
		}

		public Celula<E> getProxima() {
			return proxima;
		}

		public void setProxima(Celula<E> proxima) {
			this.proxima = proxima;
		}
	}

	private Celula<Elemento> primeira;
	private int length;

	public ListaEncadeada() {
		this.primeira = null;
		this.length = 0;
	}

	@Override
	public Elemento getElement(int index) {
		if (isForaDoIntervalo(index))
			throw new ArrayIndexOutOfBoundsException(index);

		return getCelula(index).elemento();
	}

	private Celula<Elemento> getCelula(int index) {
		//if (isForaDoIntervalo(index))
		//	throw new ArrayIndexOutOfBoundsException(index);

		int posicaoAtual = 0;
		Celula<Elemento> ponteiro = primeira;
		
		while (posicaoAtual != index) {
			ponteiro = ponteiro.getProxima();
			posicaoAtual++;
		}

		return ponteiro;
	}

	private boolean isForaDoIntervalo(int index) {
		return index < 0 || index >= size();
	}

	@Override
	public void insert(Elemento elemento) {
		Celula<Elemento> novaCelula = new Celula<Elemento>(elemento);
		if (primeira == null)
			primeira = novaCelula;
		else
			ultimoElemento().setProxima(novaCelula);
		
		length++;
	}
	
	private Celula<Elemento> ultimoElemento() {
		Celula<Elemento> ponteiro = primeira;
		
		while (ponteiro.getProxima() != null)
			ponteiro = ponteiro.getProxima();

		return ponteiro;
	}

	@Override
	public void insert(Elemento elemento, int index) {
		if (isForaDoIntervalo(index) && !isFinal(index))
			throw new ArrayIndexOutOfBoundsException(index);
		
		Celula<Elemento> novaCelula = new Celula<Elemento>(elemento);
		if (isInicial(index))
			addNoInicio(novaCelula);

		else
			addNo(index, novaCelula);

		length++;
	}

	private boolean isInicial(int index) {
		return index == 0;
	}

	private boolean isFinal(int index) {
		 return index == size();
	}

	private void addNoInicio(Celula<Elemento> novaCelula) {
		Celula<Elemento> proxima = primeira;
		novaCelula.setProxima(proxima);
		primeira = novaCelula;
	}

	private void addNo(int index, Celula<Elemento> estaCelula) {
		Celula<Elemento> anterior = getCelula(index-1);
		Celula<Elemento> proxima = anterior.getProxima();
		
		anterior.setProxima(estaCelula);
		estaCelula.setProxima(proxima);
	}

	@Override
	public void remove(int index) {
		if (isForaDoIntervalo(index))
			throw new ArrayIndexOutOfBoundsException(index);
		
		Celula<Elemento> removido = isInicial(index) ? removePrimeira(index) : removeNaoPrimeira(index);

		length--;
	}

	private Celula<Elemento> removePrimeira(int index) {
		Celula<Elemento> atual = primeira;
		Celula<Elemento> proxima = atual.getProxima();

		this.primeira = proxima;
		return atual;
	}

	private Celula<Elemento> removeNaoPrimeira(int index) {
		Celula<Elemento> anterior = getCelula(index-1);
		Celula<Elemento> atual = anterior.getProxima();
		Celula<Elemento> proxima = atual.getProxima();
		
		anterior.setProxima(proxima);
		return atual;
	}

	@Override
	public boolean contains(Elemento elemento) {
		Celula<Elemento> ponteiro = primeira;

		while (ponteiro != null) {
			if (ponteiro.elemento().equals(elemento))
				return true;

			ponteiro = ponteiro.getProxima();
		}

		return false;
	}

	@Override
	public int size() {
		return length;
	}
	
	@Override
	public String toString() {
		Celula<Elemento> atual = primeira;

		StringBuilder retorno = new StringBuilder();
		while(atual != null) {
			retorno.append(atual.elemento);
			retorno.append(" -> ");

			atual = atual.proxima;
		}
		
		retorno.append("FIM DO ENCADEAMENTO");
		
		return retorno.toString();
	}
}