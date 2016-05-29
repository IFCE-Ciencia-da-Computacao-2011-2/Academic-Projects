package analise;

import analise.algoritmo.Ordenador;
import analise.resultados.TestesResultados;
import analise.util.Util;

public class Analisador {
	private int[] elementos;
	private int totalTestes;

	public Analisador(int[] elementos, int totalTestes) {
		this.elementos = elementos;
		this.totalTestes = totalTestes;
	}
	
	public TestesResultados analisar(Ordenador ordenador) {
		TestesResultados resultados = new TestesResultados();
		for (int i = 0; i < totalTestes; i++)
			resultados.addResultado(analisar(ordenador, this.elementos));
		
		return resultados;
	}
	
	private long analisar(Ordenador ordenador, int[] elementos) {
		int[] copia = Util.copy(elementos);

		long inicio = System.nanoTime();
		ordenador.ordenar(copia);
		long fim = System.nanoTime();
		
		if (!isOrdenado(copia))
			throw new RuntimeException("Algoritmo não ordenou!");
		
		return fim - inicio;
	}

	private boolean isOrdenado(int[] lista) {
		for (int i = 0; i < lista.length-1; i++) {
			if (lista[i] > lista[i+1]) {
				System.out.println(i + " " + lista[i] + " " + lista[i+1]);
				return false;
			}
		}

		return true;
	}
}
