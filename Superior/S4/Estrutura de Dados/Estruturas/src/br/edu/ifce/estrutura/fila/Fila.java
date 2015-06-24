package br.edu.ifce.estrutura.fila;

/**
 * FIFO
 * First In First Out
 * 
 * O elemento entra no fim e sai no início
 * Assim, first() retorna o primeiro elemento que entrou
 * na fila que ainda não saiu
 */
public interface Fila<Elemento> {
	/** Adicionar no fim da fila */
	void enqueue(Elemento elemento);
	/** Remover do começo da fila */
	void dequeue();
	Elemento first();
	int size();
}
