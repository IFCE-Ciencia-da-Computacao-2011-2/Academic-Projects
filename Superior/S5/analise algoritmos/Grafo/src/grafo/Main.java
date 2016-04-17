package grafo;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

public class Main {
	public static void main(String[] args) {
		Vertice S = new Vertice("S");
		Vertice A = new Vertice("A");
		Vertice B = new Vertice("B");
		Vertice C = new Vertice("C");
		Vertice D = new Vertice("D");
		Vertice E = new Vertice("E");
		
		S.conectar(A);
		S.conectar(B);
		A.conectar(C);
		B.conectar(C);
		B.conectar(D);
		C.conectar(E);
		D.conectar(E);
		
		System.out.println(S.getArestas());
		
		System.out.print("Busca em profundidade: ");
		buscaEmProfundidade(S);

		System.out.println();

		System.out.print("Busca em largura: ");
		buscaEmLargura(S);
	}
	
	public static void buscaEmLargura(Vertice grafo) {
		Map<Vertice, Vertice> marcados = new HashMap<Vertice, Vertice>();

		Queue<Vertice> grafos = new LinkedList<Vertice>();
		grafos.add(grafo);
		
		while (!grafos.isEmpty()) {
			grafo = grafos.remove();
			
			if (!marcados.containsKey(grafo)) {
				marcados.put(grafo, grafo);
				System.out.print(grafo + " ");
				grafos.addAll(grafo.getGrafosConectados());
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