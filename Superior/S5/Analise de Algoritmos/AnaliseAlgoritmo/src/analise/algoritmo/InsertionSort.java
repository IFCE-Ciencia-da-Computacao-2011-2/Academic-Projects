package analise.algoritmo;

public class InsertionSort implements Ordenador {

	@Override
	public void ordenar(int[] vetor) {
        for (int i = 1; i < vetor.length; i++) {
            int valueToSort = vetor[i];
            int j = i;

            while (j > 0 && vetor[j - 1] > valueToSort) {
                vetor[j] = vetor[j - 1];
                j--;
            }

            vetor[j] = valueToSort;
        }
    }	
}
