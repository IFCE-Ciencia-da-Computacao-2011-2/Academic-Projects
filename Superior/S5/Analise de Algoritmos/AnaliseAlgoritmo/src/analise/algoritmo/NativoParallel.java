package analise.algoritmo;

import java.util.Arrays;

public class NativoParallel implements Ordenador {
	@Override
	public void ordenar(int[] lista) {
		Arrays.parallelSort(lista);
	}
}
