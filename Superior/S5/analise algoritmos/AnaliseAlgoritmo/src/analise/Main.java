package analise;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import analise.algoritmo.BubbleSort;
import analise.algoritmo.CountingSort;
import analise.algoritmo.HeapSort;
import analise.algoritmo.InsertionSort;
import analise.algoritmo.MergeSort;
import analise.algoritmo.Nativo;
import analise.algoritmo.NativoParallel;
import analise.algoritmo.Ordenador;
import analise.algoritmo.QuickSort;
import analise.resultados.ResultadosPorOrdenadores;
import analise.util.FileUtil;
import analise.util.Util;

public class Main {
	public static void main(String[] args) throws IOException {
		Ordenador[] ordenadores = new Ordenador[] {
			new Nativo(),
			new NativoParallel(),
			new CountingSort(),
			new HeapSort(),
			new InsertionSort(),
			new MergeSort(),
			new QuickSort()//,
			//new BubbleSort()
		};

		Map<String, List<ResultadosPorOrdenadores>> resultados = new HashMap<>();
		final int TOTAL_TESTES = 50;
		int[] elementos = FileUtil.lerArquivo("src/elementos.txt");
		//elementos = new int[] {2,5,4,3,9,1};
		
		System.out.println("1.000 elementos");
		int[] milElementos = Arrays.copyOfRange(elementos, 0, 1000);
		resultados.put("1.000 elementos", analisar(TOTAL_TESTES, milElementos, ordenadores));
		
		System.out.println("10.000 elementos");
		int[] dezMilElementos = Arrays.copyOfRange(elementos, 0, 10000);
		resultados.put("10.000 elementos", analisar(TOTAL_TESTES, dezMilElementos, ordenadores));

		System.out.println("100.000 elementos");
		resultados.put("100.000 elementos", analisar(TOTAL_TESTES, elementos, ordenadores));
		
		ResultadosView view = new ResultadosView(resultados);
		view.imprimir();
	}
	
	private static List<ResultadosPorOrdenadores> analisar(final int TOTAL_TESTES, int[] elementos, Ordenador[] ordenadores) {
		List<ResultadosPorOrdenadores> analises = new ArrayList<>();

		System.out.println(" - Desordenado");
		analises.add(analisarOrdenadores("Desordenado", TOTAL_TESTES, elementos, ordenadores));
		
		System.out.println(" - Ordenado");
		int[] copia = Util.copy(elementos);
		Arrays.sort(copia);
		analises.add(analisarOrdenadores("Ordenado", TOTAL_TESTES, copia, ordenadores));

		System.out.println(" - Ordenado decrescente");
		int[] copia2 = Util.copy(elementos);
		Util.reverse(copia2);
		analises.add(analisarOrdenadores("Ordenado decrescente", TOTAL_TESTES, copia2, ordenadores));
		
		
		System.out.println(" - Repetidos");
		int[] copia3 = Util.copy(elementos);
		Util.reverse(copia3);
		analises.add(analisarOrdenadores("Repetidos", TOTAL_TESTES, copia2, ordenadores));
		
		return analises;
	}

	private static ResultadosPorOrdenadores analisarOrdenadores(String titulo, final int TOTAL_TESTES, int[] elementos, Ordenador[] ordenadores) {
		Analisador analisador = new Analisador(elementos, TOTAL_TESTES);
		
		ResultadosPorOrdenadores resultados = new ResultadosPorOrdenadores(titulo, TOTAL_TESTES);
		
		for (Ordenador ordenador : ordenadores)
			resultados.add(ordenador, analisador.analisar(ordenador));
		
		return resultados;
	}
}
