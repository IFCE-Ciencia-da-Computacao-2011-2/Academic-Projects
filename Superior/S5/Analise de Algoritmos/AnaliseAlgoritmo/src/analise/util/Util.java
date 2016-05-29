package analise.util;

public class Util {
	public static void swap(int[] a, int i, int j) {
		int t = a[i];
		a[i] = a[j];
		a[j] = t;
	}
	
	public static int[] copy(int array[]) {
		int[] copia = new int[array.length];
		System.arraycopy(array, 0, copia, 0, array.length);
		return copia;
	}
	
	public static void reverse(int array[]) {
		for(int i = 0; i < array.length; i++){
		    array[i] = array[i] ^ array[array.length - i - 1];
		    array[array.length - i - 1] = array[i] ^ array[array.length - i - 1];
		    array[i] = array[i] ^ array[array.length - i - 1];
		}
	}
	
	public static int max(int array[]) {
		int max = 0; 
		for (int elemento : array)
			if (elemento > max)
				max = elemento;
		return max;
	}
	
	public static int[] tudoIgual(int quantidadeDeElementos, int valor) {
		int[] array = new int[quantidadeDeElementos];
		for (int i = 0; i < quantidadeDeElementos; i++)
			array[i] = valor;

		return array;
	}
}
