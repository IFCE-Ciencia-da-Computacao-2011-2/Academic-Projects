package br.edu.ifce.estrutura.fila.teste;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.NoSuchElementException;

import junit.framework.TestCase;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import br.edu.ifce.estrutura.fila.Fila;
import br.edu.ifce.estrutura.fila.FilaEncadeada;
import br.edu.ifce.estrutura.fila.FilaVetor;

@RunWith(Parameterized.class)
public class FilaTeste extends TestCase {
	
	@Parameters
	public static Collection<Object[]> parameters() {
		List<Fila<String>> filasTestadas = new ArrayList<>();

		filasTestadas.add(new FilaVetor<>());
		filasTestadas.add(new FilaEncadeada<>());

		List<Object[]> retorno = new ArrayList<Object[]>();
		
		for (Fila<String> lista : filasTestadas)
			retorno.add(new Object[] {lista});

	    return retorno;
	}
	
	//////////////////
	
	private Fila<String> fila;

	public FilaTeste(Fila<String> Fila) {
		this.fila = Fila;
	}

	@Before
	public void setUp() {
		manualClear(fila);
	}
	
	private static void manualClear(Fila<?> fila) {
		while (fila.size() != 0)
			fila.dequeue();
	}

	@Test
	public void clear() {
		for (int i=0; i<200; i++)
			fila.enqueue(i+"");

		manualClear(fila);

		assertEquals(fila.size(), 0);

		for (int i=0; i<200; i++)
			fila.enqueue(i+"");
		
		manualClear(fila);
		
		assertEquals(fila.size(), 0);
	}

	@Test
	public void enqueueElementosDiferentes() {
		fila.enqueue("1");
		fila.enqueue("2");
		fila.enqueue("3");

		assertEquals(fila.size(), 3);
	}

	/**
	 * Lista permite adição de elementos iguais. 
	 * Estes ficam em posições distintas.
	 */
	@Test
	public void enqueueElementosIguais() {
		String objeto = "Macarronada assada";

		fila.enqueue(objeto);
		fila.enqueue(objeto);

		assertEquals(fila.size(), 2);
	}

	/**
	 * Verifica se pode adicionar muitos elementos sem quebrar
	 */
	@Test
	public void enqueueEstouroDePilha() {
		final int totalElementos = 10000;

		String elemento = "total "+totalElementos;
		for (int i=0; i<totalElementos; i++)
			fila.enqueue(elemento);

		assertEquals(fila.size(), totalElementos);
	}
	
	@Test
	public void first() {
		final String PRIMEIRO = "a";
		final String SEGUNDO = "b";
		final String TERCEIRO = "c";
		fila.enqueue(PRIMEIRO);
		fila.enqueue(SEGUNDO);
		fila.enqueue(TERCEIRO);
		
		assertEquals(PRIMEIRO, fila.first());
		fila.dequeue();
		assertEquals(SEGUNDO,  fila.first());
		fila.dequeue();
		assertEquals(TERCEIRO, fila.first());
		fila.dequeue();
	}
	
	@Test(expected=NoSuchElementException.class)
	public void firstListaVazia() {
		fila.first();
	}

	@Test
	public void sizeVazio() {
		assertEquals(fila.size(), 0);
	}
	
	@Test
	public void sizePreenchido() {
		final int TOTAL_ELEMENTOS = 7;
		for (int i=0; i<TOTAL_ELEMENTOS; i++)
			fila.enqueue(i+"");
		
		assertEquals(fila.size(), TOTAL_ELEMENTOS);
	}

	@Test
	public void sizeNaoAleatorio() {
		for (int i=0; i<5; i++)
			fila.enqueue(i+"");
	
		// Vai que é aleatório
		assertEquals(fila.size(), fila.size());
	}
	
	@Test
	public void sizeAposDeletarElementos() {
		for (int i=0; i<5; i++)
			fila.enqueue(i+"");

		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		
		assertEquals(fila.size(), 5-3);
	}
	
	@Test(expected=NoSuchElementException.class)
	public void dequeueListaVazia() {
		fila.dequeue();
	}
	
	@Test
	public void dequeue() {
		fila.enqueue("b");
		fila.enqueue("a");
		
		fila.dequeue();
		assertEquals(fila.size(), 1);
		fila.dequeue();
		assertEquals(fila.size(), 0);
	}


	@Test
	public void dequeueUnicoElemento() {
		fila.enqueue("Elemento");
		fila.dequeue();
		
		assertEquals(fila.size(), 0);
	}
}