package br.edu.ifce.estrutura.pilha;

public interface Pilha<Elemento> {
	void push(Elemento elemento);
	void pop();
	Elemento top();
	int size();
}
