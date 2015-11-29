package br.edu.ifce.estrutura.heap.teste;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import br.edu.ifce.estrutura.heap.Elemento;
import br.edu.ifce.estrutura.heap.Heap;

public class HeapTeste {

	@Test
	public void adicionarElementoTeste() {
		Heap<Integer> heap = new Heap<>(16);
		heap.add(1, 1);

		assertEquals(heap.size(), 1);
	}
	
	@Test
	public void sizeTeste() {
		Heap<Integer> heap = new Heap<>(16);
		assertEquals(heap.size(), 0);

		heap.add(1, 1);
		assertEquals(heap.size(), 1);
		
		heap.add(5, 5);
		assertEquals(heap.size(), 2);
		
		heap.add(3, 3);
		assertEquals(heap.size(), 3);
	}
	
	@Test
	public void minimoHeapVazioTeste() {
		Heap<Integer> heap = new Heap<>(16);
		assertNull(heap.minimo());
	}

	@Test
	public void minimoTeste() {
		Heap<Integer> heap = new Heap<>(16);
		heap.add(5, 5);
		heap.add(3, 3);
		heap.add(7, 7);
		
		assertEquals(new Elemento<Integer>(3, 3), heap.minimo());
	}

	@Test
	public void removerTeste() {
		List<Elemento<Integer>> elementos = new ArrayList<>();
		elementos.add(new Elemento<>(2, 2));
		elementos.add(new Elemento<>(5, 5));
		elementos.add(new Elemento<>(3, 3));
		elementos.add(new Elemento<>(1, 1));
		elementos.add(new Elemento<>(7, 7));
		elementos.add(new Elemento<>(1, 1));
		elementos.add(new Elemento<>(53, 53));
		elementos.add(new Elemento<>(15, 15));

		Heap<Integer> heap = new Heap<>(16);
		for (Elemento<Integer> elemento : elementos)
			heap.add(elemento.prioridade, elemento.elemento);

		assertEquals(heap.size(), elementos.size());
		
		int[] resultado = new int[] {1, 1, 2, 3, 5, 7, 15, 53};
		int i = 0;

		Elemento<Integer> minimo;
		do {
			minimo = heap.extrairMinimo();
			assertEquals(resultado[i], minimo.prioridade);
			assertEquals(resultado.length - (i+1), heap.size());
			i++;

		} while (i < resultado.length);
	}
}
