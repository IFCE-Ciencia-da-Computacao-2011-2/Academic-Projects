package analise.algoritmo;

import analise.util.Util;

/**
 * Inspirado em https://felipepriuli.wordpress.com/2013/01/08/counting-sort/
 * Algoritmos - Teoria e pr�tica 3� ed (p�gina 141 e 142)
 */
public class CountingSort implements Ordenador {

	@Override
	public void ordenar(int[] A) {
		int B[] = new int[A.length+1];
		int k = Util.max(A) + 1; // A inicializa��o por zero � substitu�da pela descoberta do m�ximo (k)
		int C[] = new int[k];

		// 1� - Inicializar - Java j� inicializa com zero
		//for (int i = 0; i < n; i++)
		//	count[i] = 0;

		// 2� - Contagem de ocorrencias
		for (int j = 0; j < A.length; j++)
			C[A[j]]++;

		// 3� - Ordenando os indices do vetor auxiliar
		for (int i = 1; i < k; i++)
			C[i] = C[i] + C[i - 1];

		for (int j = A.length-1; j >= 0; j--) {
			B[C[A[j]]] = A[j];
			C[A[j]]--;
		}
		
		// 4� Retornando os valores ordenados para o vetor de entrada
		// (Passo adicional)
		for (int i = 1; i < B.length; i++)
			A[i-1] = B[i];
	}
}
