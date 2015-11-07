package br.edu.ifce.estrutura.lista;


public class ListaDuplamenteEncadeada<Elemento> implements Lista<Elemento> {
	
	private class Celula<E> {
		private E elemento;
		private Celula<E> proxima;
		private Celula<E> anterior;

		public Celula(E elemento) {
			this.elemento = elemento;
			this.anterior = null;
			this.proxima = null;
		}

		private E elemento() {
			return elemento;
		}

		private void addLogoDepois(E elemento) {
			this.addEntre(this, getProxima(), elemento);
		}
		
		public void addLogoAntes(E elemento) {
			this.addEntre(getAnterior(), this, elemento);
		}
		
		private void addEntre(Celula<E> este, Celula<E> eEste, E elemento) {
			Celula<E> anterior = este;
			Celula<E> proxima = eEste;
			
			Celula<E> nova = new Celula<E>(elemento);

			if (anterior != null)
				anterior.setProxima(nova);
			nova.setAnterior(anterior);

			if (proxima != null)
				proxima.setAnterior(nova);
			nova.setProxima(proxima);
		}

		public E removerEste() {
			Celula<E> anterior = this.getAnterior();
			Celula<E> proxima = this.getProxima();
			
			if (anterior != null)
				anterior.setProxima(proxima);
			if (proxima != null)
				proxima.setAnterior(anterior);

			return this.elemento();
		}

		public Celula<E> getProxima() {
			return proxima;
		}
		
		public Celula<E> getAnterior() {
			return anterior;
		}
		
		protected void setAnterior(Celula<E> anterior) {
			this.anterior = anterior;
		}

		protected void setProxima(Celula<E> proxima) {
			this.proxima = proxima;
		}
	}

	private Celula<Elemento> primeira;
	private Celula<Elemento> ultima;
	private int length;

	public ListaDuplamenteEncadeada() {
		this.primeira = null;
		this.ultima = null;
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

		if (index > size()/2)
			return getCelulaDoFimParaOInicio(index);
		else
			return getCelulaDoInicioParaOFim(index);
	}

	private Celula<Elemento> getCelulaDoFimParaOInicio(int index) {
		int posicaoAtual = size()-1;
		Celula<Elemento> ponteiro = ultima;
		
		while (posicaoAtual != index) {
			ponteiro = ponteiro.getAnterior();
			posicaoAtual--;
		}

		return ponteiro;
	}

	private Celula<Elemento> getCelulaDoInicioParaOFim(int index) {
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
		if (isPrimeiraInsercao()) {
			primeira = new Celula<Elemento>(elemento);
			ultima = primeira;

		} else {
			ultima.addLogoDepois(elemento);
			ultima = ultima.getProxima();
		}

		length++;
	}
	
	private boolean isPrimeiraInsercao() {
		return primeira == null;
	}

	@Override
	public void insert(Elemento elemento, int index) {
		if (isForaDoIntervalo(index) && !isProximoIndexLivre(index))
			throw new ArrayIndexOutOfBoundsException(index);

		if (isProximoIndexLivre(index)) {
			insert(elemento);
			return;

		} else {
			Celula<Elemento> celula = getCelula(index);
			celula.addLogoAntes(elemento);
			
			if (isPrimeiroIndiceOcupado(index))
				primeira = celula.getAnterior();

			length++;
		}
	}

	private boolean isPrimeiroIndiceOcupado(int index) {
		return index == 0;
	}
	
	/** 
	 * @return É o index do último elemento?
	 */
	private boolean isUltimoIndiceOcupado(int index) {
		return isProximoIndexLivre(index+1);
	}

	private boolean isProximoIndexLivre(int index) {
		 return index == size();
	}

	@Override
	public void remove(int index) {
		if (isForaDoIntervalo(index))
			throw new ArrayIndexOutOfBoundsException(index);
		
		Celula<Elemento> seraRemovida = getCelula(index);

		if (isPrimeiroIndiceOcupado(index))
			this.primeira = primeira.getProxima();

		if (isUltimoIndiceOcupado(index))
			this.ultima = ultima.getAnterior();

		seraRemovida.removerEste();
		length--;
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
		while (atual != null) {
			retorno.append(atual.elemento);
			retorno.append(" -> ");

			atual = atual.proxima;
		}
		
		retorno.append("FIM DO ENCADEAMENTO");
		
		return retorno.toString();
	}
}