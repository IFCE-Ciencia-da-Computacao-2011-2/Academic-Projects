package ifce.padrao;

import java.util.ArrayList;
import java.util.List;

public class SomadorAdapter implements SomadorEsperado {
	@Override
	public int somaVetor(int[] vetor) {
		List<Integer> lista = new ArrayList<>();
		for (int i : vetor) lista.add(i);
		return new SomadorExistente().somaLista(lista);
	}
}
