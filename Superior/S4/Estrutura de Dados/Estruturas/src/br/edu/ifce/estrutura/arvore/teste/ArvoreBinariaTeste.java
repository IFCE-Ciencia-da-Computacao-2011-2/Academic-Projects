package br.edu.ifce.estrutura.arvore.teste;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

import java.util.Iterator;

import org.junit.Before;
import org.junit.Test;

import br.edu.ifce.estrutura.arvore.ArvoreBinaria;

public class ArvoreBinariaTeste {

	private ArvoreBinaria<Integer> arvore;

	@Before
	public void before() {
		arvore = new ArvoreBinaria<>();
		
		/*
		 *    4 
		 *  2   5
		 * 1 3
		 */
		arvore.inserir(4, 4);
		arvore.inserir(2, 2);
		arvore.inserir(1, 1);
		arvore.inserir(3, 3);
		arvore.inserir(5, 5);
	}


	@Test
	public void buscarTeste() {
		assertEquals(4, (int) arvore.buscar(4));
		assertEquals(2, (int) arvore.buscar(2));
		assertEquals(1, (int) arvore.buscar(1));
		assertEquals(3, (int) arvore.buscar(3));
		assertEquals(5, (int) arvore.buscar(5));
	}

	@Test
	public void buscarNaoEncontradoTeste() {
		assertNotNull(arvore.buscar(4));
		assertNull(arvore.buscar(57));
	}
	
	@Test
	public void adicionarSubstituindoTeste() {
		/*
		 *      4 
		 *   2     5
		 * 35 3
		 */
		arvore.inserir(1, 35);
		
		assertNotEquals(1, (int) arvore.buscar(1));
		assertEquals(35, (int) arvore.buscar(1));
	}
	
	@Test
	public void minimaTeste() {
		assertEquals(1, (int) arvore.min());
	}
	
	@Test
	public void maximaTeste() {
		assertEquals(5, (int) arvore.max());
	}
	
	@Test
	public void minimaArvoreVaziaTeste() {
		ArvoreBinaria<Integer> arvore = new ArvoreBinaria<>();
		
		assertNull(arvore.min());
	}
	
	@Test
	public void maximaArvoreVaziaTeste() {
		ArvoreBinaria<Integer> arvore = new ArvoreBinaria<>();
		
		assertNull(arvore.max());
	}
	
	@Test
	public void sucessorTeste() {
		assertEquals(2, (int) arvore.sucessor(1));
		assertEquals(3, (int) arvore.sucessor(2));
		assertEquals(4, (int) arvore.sucessor(3));
		assertEquals(5, (int) arvore.sucessor(4));
		assertNull(arvore.sucessor(5));

		assertNull(arvore.sucessor(123));
	}
	
	@Test
	public void antecessorTeste() {
		assertNull(arvore.antecessor(1));
		assertEquals(1, (int) arvore.antecessor(2));
		assertEquals(2, (int) arvore.antecessor(3));
		assertEquals(3, (int) arvore.antecessor(4));
		assertEquals(4, (int) arvore.antecessor(5));

		assertNull(arvore.antecessor(123));
	}
	
	@Test
	public void preOrder() {
		orderTest(arvore.preOrder(), 1, 2, 3, 4, 5);
	}

	@Test
	public void posOrder() {
		orderTest(arvore.posOrder(), 5, 4, 3, 2, 1);
	}

	@Test
	public void inOrder() {
		orderTest(arvore.inOrder(), 4, 2, 1, 3, 5);
	}

	private void orderTest(Iterator<Integer> iterator, int ... ordem) {
		int i = 0;

		while (iterator.hasNext()) {
			Integer elemento = iterator.next();
			assertEquals(ordem[i], (int) elemento);
			i++;
		}
	}
}
