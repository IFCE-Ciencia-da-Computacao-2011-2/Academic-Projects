package grafo;

import java.util.Iterator;
import java.util.LinkedList;

public class Vertice implements Iterable<Vertice> {
	private String nome;
	private LinkedList<Vertice> adjacentes;

	public Vertice(String nome) {
		this.nome = nome;
		this.adjacentes = new LinkedList<Vertice>();
	}

	public void conectar(Vertice grafo) {
		this.adjacentes.add(grafo);
		if (grafo != this)
			grafo.adjacentes.add(this);
	}
	
	public LinkedList<Vertice> getGrafosConectados() {
		return adjacentes;
	}
	
	public LinkedList<Aresta> getArestas() {
		LinkedList<Aresta> arestas = new LinkedList<>();
		for (Vertice grafo : adjacentes)
			arestas.add(new Aresta(this, grafo));

		return arestas;
	}
	
	@Override
	public String toString() {
		return nome;
	}

	@Override
	public Iterator<Vertice> iterator() {
		return adjacentes.iterator();
	}
}
