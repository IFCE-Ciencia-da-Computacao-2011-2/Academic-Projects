package analise.algoritmo;

import java.util.Arrays;

public class Nativo implements Ordenador {
	@Override
	public void ordenar(int[] lista) {
		Arrays.sort(lista);
	}
}
