package grafo;

import java.util.List;

import grafo.algoritmo.Busca;
import grafo.algoritmo.Dijkstra;

public class Main {
	public static void main(String[] args) {
		Grafo grafo = new Grafo();

		Vertice S = new Vertice("S");
		Vertice A = new Vertice("A");
		Vertice B = new Vertice("B");
		Vertice C = new Vertice("C");
		Vertice D = new Vertice("D");
		Vertice E = new Vertice("E");
		
		grafo.add(S);
		grafo.add(A);
		grafo.add(B);
		grafo.add(C);
		grafo.add(D);
		grafo.add(E);
		
		System.out.println(" S ---> A >----");
		System.out.println(" |            |");
		System.out.println(" |      /---> C --> E");
		System.out.println(" |     /            |");
		System.out.println(" |    /             |");
		System.out.println(" --> B ---> D >------");  

		grafo.conectar(S, A, 1);
		grafo.conectar(S, B, 2);
		grafo.conectar(A, C, 3);
		grafo.conectar(B, C, 1);
		grafo.conectar(B, D, 1);
		grafo.conectar(C, E, 1);
		grafo.conectar(D, E, 1);
		
		System.out.println(S.getArestas());
		
		System.out.print("Busca em profundidade: ");
		Busca.buscaEmProfundidade(S);

		System.out.println();

		System.out.print("Busca em largura: ");
		Busca.buscaEmLargura(S);
		
		System.out.println();
		System.out.println("Arestas: ");
		System.out.println(grafo.getArestas());
		
		Dijkstra dijkstra = new Dijkstra(grafo);
		dijkstra.execute(S);

		for (Vertice vertice : grafo.getVertices()) {
			List<Aresta> caminho = dijkstra.getCaminho(vertice);
			int custo = 0;
			for (Aresta aresta : caminho) 
				custo += aresta.getPeso();

			System.out.println("" + S + "->" + vertice);
			System.out.println("  - Custo total: " + custo);
			System.out.println("  - Caminho: " + caminho);
		}
	}
}