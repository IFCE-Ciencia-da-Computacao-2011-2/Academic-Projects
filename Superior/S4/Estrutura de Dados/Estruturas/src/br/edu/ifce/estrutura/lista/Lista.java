package br.edu.ifce.estrutura.lista;

public interface Lista<Elemento> {
	void insert(Elemento elemento);
	void insert(Elemento elemento, int pos);
	Elemento getElement(int index);
	void remove(int index);
	boolean contains(Elemento elemento);
	int size();
}