package grafo;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Vertice implements Iterable<Vertice> {
	private String nome;
	private List<Aresta> arestas;

	public Vertice(String nome) {
		this.nome = nome;
		this.arestas = new LinkedList<Aresta>();
	}

	public List<Vertice> getAdjacentes() {
		List<Vertice> vertices = new LinkedList<>();

		for (Aresta aresta : arestas) {
			if (aresta.getOrigem() != this)
				vertices.add(aresta.getOrigem());

			else if (aresta.getDestino() != this)
				vertices.add(aresta.getDestino());

			// Ciclo para si próprio
			else
				vertices.add(this);
		}

		return vertices;
	}

	public void addAresta(Aresta aresta) {
		this.arestas.add(aresta);
	}

	public List<Aresta> getArestas() {
		return arestas;
	}
	
	public Aresta getAresta(Vertice destino) {
		for (Aresta aresta : arestas)
			if (aresta.getOrigem().equals(this) && aresta.getDestino().equals(destino))
				return aresta;

		throw new RuntimeException("Aresta inexistente");
	}
	
	@Override
	public String toString() {
		return nome;
	}

	@Override
	public Iterator<Vertice> iterator() {
		return getAdjacentes().iterator();
	}
}
