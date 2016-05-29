package grafo.algoritmo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import grafo.Aresta;
import grafo.Grafo;
import grafo.Vertice;

/**
 * Baseado em:
 * http://www.vogella.com/tutorials/JavaAlgorithmsDijkstra/article.html
 */
public class Dijkstra {
	private Grafo grafo;

	private Set<Vertice> nosAnalizados;
	private Set<Vertice> nosNaoAnalizados;

	private Map<Vertice, Vertice> predecessores;
	private Map<Vertice, Integer> distancias;

	public Dijkstra(Grafo grafo) {
		this.grafo = grafo;
	}

	public void execute(Vertice origem) {
		nosAnalizados = new HashSet<Vertice>();
		nosNaoAnalizados = new HashSet<Vertice>();

		distancias = new HashMap<Vertice, Integer>();
		predecessores = new HashMap<Vertice, Vertice>();

		distancias.put(origem, 0);
		nosNaoAnalizados.add(origem);

		while (!nosNaoAnalizados.isEmpty()) {
			Vertice vertice = getMinimoDos(nosNaoAnalizados);

			nosAnalizados.add(vertice);
			nosNaoAnalizados.remove(vertice);

			buscarDistanciasMinimasDeAdjacentesDe(vertice);
		}
	}

	private Vertice getMinimoDos(Set<Vertice> vertices) {
		Iterator<Vertice> iterator = vertices.iterator();

		Vertice minimo = iterator.next();
		
		while (iterator.hasNext()) {
			Vertice vertice = iterator.next();
			if (getMenorDistanciaComputadaPara(vertice) < getMenorDistanciaComputadaPara(minimo))
				minimo = vertice;
		}

		return minimo;
	}

	private void buscarDistanciasMinimasDeAdjacentesDe(Vertice no) {
		List<Vertice> adjacentes = getAdjacentes(no);

		for (Vertice destino : adjacentes) {
			int distanciaParaAdjacente = getMenorDistanciaComputadaPara(no) + getDistancia(no, destino);

			if (distanciaParaAdjacente < getMenorDistanciaComputadaPara(destino)) {
				distancias.put(destino, distanciaParaAdjacente);
				predecessores.put(destino, no);
				nosNaoAnalizados.add(destino); // Se getMenorDistanciaComputadaPara < distanciaParaAdjacente, adjacente já computado
			}
		}
	}

	private List<Vertice> getAdjacentes(Vertice no) {
		List<Vertice> vizinhos = new ArrayList<Vertice>();
		for (Aresta aresta : no.getArestas())
			if (aresta.getOrigem().equals(no) && !isAnalisado(aresta.getDestino()))
				vizinhos.add(aresta.getDestino());

		return vizinhos;
	}

	private boolean isAnalisado(Vertice Vertice) {
		return nosAnalizados.contains(Vertice);
	}

	private int getDistancia(Vertice origem, Vertice destino) {
		return origem.getAresta(destino).getPeso();
	}


	private int getMenorDistanciaComputadaPara(Vertice destino) {
		Integer distancia = distancias.get(destino);

		return distancia == null ? Integer.MAX_VALUE : distancia;
	}

	public List<Aresta> getCaminho(Vertice destino) {
		List<Aresta> caminho = new LinkedList<Aresta>();
		Vertice vertice = destino;

		if (predecessores.get(vertice) == null)
			return caminho;

		while (predecessores.get(vertice) != null) {
			Vertice predecessor = predecessores.get(vertice);
			caminho.add(grafo.getAresta(predecessor, vertice));
			vertice = predecessor;
		}

		Collections.reverse(caminho);
		return caminho;
	}
}