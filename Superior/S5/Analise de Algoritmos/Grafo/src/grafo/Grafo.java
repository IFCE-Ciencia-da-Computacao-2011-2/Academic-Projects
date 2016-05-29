package grafo;

import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

public class Grafo {

	private List<Vertice> vertices;
	private LinkedList<Aresta> arestas;

	public Grafo() {
		vertices = new LinkedList<>();
		arestas = new LinkedList<>();
	}

	public void add(Vertice vertice) {
		this.vertices.add(vertice);
	}

	public void conectar(Vertice origem, Vertice destino) {
		Aresta aresta = new Aresta(origem, destino);
		conectar(aresta);
	}
	
	public void conectar(Vertice origem, Vertice destino, int peso) {
		Aresta aresta = new Aresta(origem, destino, peso);
		conectar(aresta);
	}
	
	private void conectar(Aresta aresta) {
		arestas.add(aresta);

		aresta.getOrigem().addAresta(aresta);
		if (aresta.getOrigem() != aresta.getDestino())
			aresta.getDestino().addAresta(aresta);
	}

	public Collection<Vertice> getVertices() {
		return vertices;
	}

	public Collection<Aresta> getArestas() {
		return arestas;
	}

	public Aresta getAresta(Vertice origem, Vertice destino) {
		for (Aresta aresta : arestas)
			if (aresta.getOrigem().equals(origem) && aresta.getDestino().equals(destino))
				return aresta;

		throw new RuntimeException("Aresta inexistente");
	}
}
