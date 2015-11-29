package br.edu.ifce.estrutura.heap;

public class Elemento<E> {
	public final int prioridade;
	public final E elemento;
	
	public Elemento(int prioridade, E elemento) {
		this.prioridade = prioridade;
		this.elemento = elemento;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof Elemento))
			return false;

		Elemento<?> elemento = (Elemento<?>) obj;
		return this.prioridade == elemento.prioridade
			&& this.elemento.equals(elemento.elemento);
	}
	
	@Override
	public String toString() {
		return "(" + this.prioridade+ "," + this.elemento.toString() +")";
	}
}
