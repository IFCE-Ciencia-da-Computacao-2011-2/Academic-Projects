package analise.algoritmo;

import analise.util.Util;

public class BubbleSort implements Ordenador {

	@Override
	public void ordenar(int[] lista) {
		int n = lista.length;
		boolean swapped = false;
		do {
			swapped = false;
			for (int i=1; i<n; i++) {
				if (lista[i-1] > lista[i]) {
					Util.swap(lista, i-1, i);
					swapped = true;
				}
			}
		} while (swapped);
	}
	
	
}
