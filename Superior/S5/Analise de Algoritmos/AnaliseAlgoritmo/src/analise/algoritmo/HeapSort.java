package analise.algoritmo;

import analise.util.Util;

// Inspirado em Algoritmos - Teoria e prática 3° ed (pag 112)
public class HeapSort implements Ordenador {

	@Override
	public void ordenar(int[] array) {
		int tamanho = array.length-1;

        buildMaxHeap(array);

        for (int i = array.length-1; i >= 1; i--) {
        	Util.swap(array, 0, i);
        	tamanho--;
            maxHeapify(array, 0, tamanho);
        }
    }
	
	private void buildMaxHeap(int[] A) {
		int tamanho = A.length-1;
		for (int i = tamanho/2; i >= 0; i--)
            maxHeapify(A, i, tamanho);
	}

    private void maxHeapify(int[] A, int i, int tamanho) {
        int l = i * 2;
        int r = l + 1;
        int maior = 0;

        if (l <= tamanho && A[l] > A[i])
        	maior = l;
        else
        	maior = i;

        if (r <= tamanho && A[r] > A[maior])
        	maior = r;

        if (maior != i) {
        	Util.swap(A, i, maior);
            maxHeapify(A, maior, tamanho);
        }
    }
}