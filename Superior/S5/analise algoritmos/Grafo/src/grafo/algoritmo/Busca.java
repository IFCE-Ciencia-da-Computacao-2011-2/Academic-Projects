package grafo.algoritmo;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

import grafo.Vertice;

public class Busca {
	public static void buscaEmLargura(Vertice grafo) {
		Map<Vertice, Vertice> marcados = new HashMap<Vertice, Vertice>();

		Queue<Vertice> grafos = new LinkedList<Vertice>();
		grafos.add(grafo);
		
		while (!grafos.isEmpty()) {
			grafo = grafos.remove();
			
			if (!marcados.containsKey(grafo)) {
				marcados.put(grafo, grafo);
				System.out.print(grafo + " ");
				grafos.addAll(grafo.getAdjacentes());
			}
		}
	}

	public static void buscaEmProfundidade(Vertice grafo) {
		Map<Vertice, Vertice> marcados = new HashMap<Vertice, Vertice>();
		marcados.put(grafo, grafo);
		System.out.print(grafo + " ");
		buscaEmProfundidade(grafo, marcados);
	}
	
	private static void buscaEmProfundidade(Vertice grafo, Map<Vertice, Vertice> marcados) {
		for (Vertice grafoConectado : grafo) {
			if (!marcados.containsKey(grafoConectado)) {
				marcados.put(grafoConectado, grafoConectado);
				System.out.print(grafoConectado + " ");
				buscaEmProfundidade(grafoConectado, marcados);
			}
		}
	}
}
