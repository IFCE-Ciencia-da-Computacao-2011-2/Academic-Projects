package br.edu.ifce.estrutura.fila;

/**
 * FIFO
 * First In First Out
 * 
 * O elemento entra no fim e sai no in�cio
 * Assim, first() retorna o primeiro elemento que entrou
 * na fila que ainda n�o saiu
 */
public interface Fila<Elemento> {
	/** Adicionar no fim da fila */
	void enqueue(Elemento elemento);
	/** Remover do come�o da fila */
	void dequeue();
	Elemento first();
	int size();
}
