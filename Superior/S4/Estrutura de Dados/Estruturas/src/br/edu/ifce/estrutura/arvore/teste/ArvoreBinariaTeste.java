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
	public void minimaArvoreComUmElementoTeste() {
		ArvoreBinaria<Integer> arvore = new ArvoreBinaria<>();
		arvore.inserir(2, 2);
		
		assertEquals(2, (int) arvore.min());
	}
	
	@Test
	public void maximaArvoreVaziaTeste() {
		ArvoreBinaria<Integer> arvore = new ArvoreBinaria<>();
		
		assertNull(arvore.max());
	}
	
	@Test
	public void maximaArvoreComUmElementoTeste() {
		ArvoreBinaria<Integer> arvore = new ArvoreBinaria<>();
		arvore.inserir(2, 2);
		
		assertEquals(2, (int) arvore.max());
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
	
	@Test
	public void removerFolhaTest() {
		arvore.remover(1);
		arvore.remover(5);

		assertNull(arvore.buscar(1));
		assertNull(arvore.buscar(5));

		orderTest(arvore.preOrder(), 2, 3, 4);
		orderTest(arvore.inOrder(), 4, 2, 3);
		orderTest(arvore.posOrder(), 4, 3, 2);
	}
	
	@Test
	public void removerFolhaRaizTest() {
		arvore = new ArvoreBinaria<>();
		arvore.inserir(10, 10);
		arvore.remover(10);

		assertNull(arvore.buscar(10));
	}

	@Test
	public void removerElementoInexistenteTest() {
		arvore.remover(35);

		orderTest(arvore.preOrder(), 1, 2, 3, 4, 5);
		orderTest(arvore.posOrder(), 5, 4, 3, 2, 1);
	}

	@Test
	public void removerNoComUmFilhoTest() {
		arvore = arvoreMaior();
		arvore.remover(3);
		arvore.remover(17);
		arvore.remover(22);

		assertNull(arvore.buscar(3));
		assertNull(arvore.buscar(17));
		assertNull(arvore.buscar(22));

		orderTest(arvore.preOrder(), 5, 8, 9, 10, 11, 12, 18, 19, 20, 21, 30, 40);
		orderTest(arvore.inOrder(), 8, 5, 12, 10, 9, 11, 30, 19, 18, 20, 21, 40);
		orderTest(arvore.posOrder(), 40, 30, 21, 20, 19, 18, 12, 11, 10, 9, 8, 5);
	}

	@Test
	public void removerRaizComUmFilhoDireitaTest() {
		arvore = new ArvoreBinaria<>();
		arvore.inserir(10, 10);
		arvore.inserir(12, 12);
		arvore.inserir(14, 14);

		arvore.remover(10);

		assertNull(arvore.buscar(10));

		orderTest(arvore.preOrder(), 12, 14);
		orderTest(arvore.inOrder(), 12, 14);
		orderTest(arvore.posOrder(), 14, 12);
	}
	
	@Test
	public void removerRaizComUmFilhoEsquerdaTest() {
		arvore = new ArvoreBinaria<>();
		arvore.inserir(10, 10);
		arvore.inserir(8, 8);
		arvore.inserir(7, 7);

		arvore.remover(10);

		assertNull(arvore.buscar(10));

		orderTest(arvore.preOrder(), 7, 8);
		orderTest(arvore.inOrder(), 8, 7);
		orderTest(arvore.posOrder(), 8, 7);
	}

	@Test
	public void removerNoComDoisFilhosESucessorFilhoADireitaTest() {
		arvore = arvoreMaior();

		arvore.remover(19);
		assertNull(arvore.buscar(19));

		orderTest(arvore.preOrder(), 3, 5, 8, 9, 10, 11, 12, 17, 18, 20, 21, 22, 30, 40);
		orderTest(arvore.inOrder(), 8, 3, 5, 12, 10, 9, 11, 30, 17, 20, 18, 22, 21, 40);
		orderTest(arvore.posOrder(), 40, 30, 22, 21, 20, 18, 17, 12, 11, 10, 9, 8, 5, 3);
	}

	@Test
	public void removerNoComDoisFilhosESucessorNaoFilhoADireitaTest() {
		arvore = new ArvoreBinaria<>();
		arvore.inserir(10, 10);
		arvore.inserir(8, 8);
		arvore.inserir(7, 7);

		arvore.inserir(15, 15);
		arvore.inserir(13, 13);
		arvore.inserir(14, 14);
		
		arvore.inserir(18, 18);
		arvore.inserir(17, 17);
		arvore.inserir(19, 19);

		arvore.remover(10);

		assertNull(arvore.buscar(10));
	}

	@Test
	public void removerRaizComSucessorEhFilhoADireitaTest() {
		arvore = new ArvoreBinaria<>();
		arvore.inserir(10, 10);
		arvore.inserir(8, 8);
		arvore.inserir(11, 11);

		arvore.remover(10);

		assertNull(arvore.buscar(10));
	}

	@Test
	public void removerNoComDoisFilhosFilhoNaoESucessorTest() {
		arvore = arvoreMaior();

		arvore.remover(12);
		assertNull(arvore.buscar(12));

		orderTest(arvore.preOrder(), 3, 5, 8, 9, 10, 11, 17, 18, 19, 20, 21, 22, 30, 40);
		orderTest(arvore.inOrder(), 8, 3, 5, 17, 10, 9, 11, 30, 19, 18, 20, 22, 21, 40);
		orderTest(arvore.posOrder(), 40, 30, 22, 21, 20, 19, 18, 17, 11, 10, 9, 8, 5, 3);
	}
	
	private ArvoreBinaria<Integer> arvoreMaior() {
		arvore = new ArvoreBinaria<>();
		
		/*
		 *           8 
		 *  3                    12
		 *     5            10             30
		 *             9     11      17        40
		 *                              19
		 *                            18  20
		 *                                  22
		 *                                21
		 */
		arvore.inserir(8, 8);
		arvore.inserir(3, 3);
		arvore.inserir(5, 5);
		
		arvore.inserir(12, 12);
		arvore.inserir(10, 10);
		arvore.inserir(9, 9);
		arvore.inserir(11, 11);
		
		arvore.inserir(30, 30);
		arvore.inserir(17, 17);
		arvore.inserir(19, 19);
		arvore.inserir(18, 18);
		arvore.inserir(20, 20);
		
		arvore.inserir(22, 22);
		arvore.inserir(21, 21);
		
		arvore.inserir(40, 40);
		
		return arvore;
	}
}
