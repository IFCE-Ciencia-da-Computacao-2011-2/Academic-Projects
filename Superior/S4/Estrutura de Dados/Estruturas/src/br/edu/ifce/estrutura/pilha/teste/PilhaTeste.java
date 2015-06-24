package br.edu.ifce.estrutura.pilha.teste;

import java.util.ArrayList;
import java.util.Collection;
import java.util.EmptyStackException;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import br.edu.ifce.estrutura.pilha.Pilha;
import br.edu.ifce.estrutura.pilha.PilhaEncadeada;
import br.edu.ifce.estrutura.pilha.PilhaVetor;

@RunWith(Parameterized.class)
public class PilhaTeste extends TestCase {
	
	@Parameters
	public static Collection<Object[]> parameters() {
		List<Pilha<String>> pilhasTestadas = new ArrayList<>();

		pilhasTestadas.add(new PilhaVetor<>());
		pilhasTestadas.add(new PilhaEncadeada<>());

		List<Object[]> retorno = new ArrayList<Object[]>();
		
		for (Pilha<String> lista : pilhasTestadas)
			retorno.add(new Object[] {lista});

	    return retorno;
	}
	
	//////////////////
	
	private Pilha<String> pilha;

	public PilhaTeste(Pilha<String> pilha) {
		this.pilha = pilha;
	}

	@Before
	public void setUp() {
		manualClear(pilha);
	}
	
	private static void manualClear(Pilha<?> pilha) {
		while (pilha.size() != 0)
			pilha.pop();
	}

	@Test
	public void clear() {
		for (int i=0; i<200; i++)
			pilha.push(i+"");

		manualClear(pilha);

		assertEquals(pilha.size(), 0);

		for (int i=0; i<200; i++)
			pilha.push(i+"");
		
		manualClear(pilha);
		
		assertEquals(pilha.size(), 0);
	}

	@Test
	public void addElementosDiferentes() {
		pilha.push("1");
		pilha.push("2");
		pilha.push("3");

		assertEquals(pilha.size(), 3);
	}

	/**
	 * Lista permite adição de elementos iguais. 
	 * Estes ficam em posições distintas.
	 */
	@Test
	public void addElementosIguais() {
		String objeto = "Macarronada assada";

		pilha.push(objeto);
		pilha.push(objeto);

		assertEquals(pilha.size(), 2);
	}

	/**
	 * Verifica se pode adicionar muitos elementos sem quebrar
	 */
	@Test
	public void addEstouroDePilha() {
		final int totalElementos = 10000;

		String elemento = "total "+totalElementos;
		for (int i=0; i<totalElementos; i++)
			pilha.push(elemento);

		assertEquals(pilha.size(), totalElementos);
	}
	
	@Test
	public void top() {
		final String PRIMEIRO = "a";
		final String SEGUNDO = "b";
		final String TERCEIRO = "c";
		pilha.push(PRIMEIRO);
		pilha.push(SEGUNDO);
		pilha.push(TERCEIRO);
		
		assertEquals(pilha.top(), TERCEIRO);
		pilha.pop();
		assertEquals(pilha.top(), SEGUNDO);
		pilha.pop();
		assertEquals(pilha.top(), PRIMEIRO);
		pilha.pop();
	}
	
	@Test(expected=EmptyStackException.class)
	public void topListaVazia() {
		pilha.top();
	}

	@Test
	public void sizeVazio() {
		assertEquals(pilha.size(), 0);
	}
	
	@Test
	public void sizePreenchido() {
		final int TOTAL_ELEMENTOS = 7;
		for (int i=0; i<TOTAL_ELEMENTOS; i++)
			pilha.push(i+"");
		
		assertEquals(pilha.size(), TOTAL_ELEMENTOS);
	}

	@Test
	public void sizeNaoAleatorio() {
		for (int i=0; i<5; i++)
			pilha.push(i+"");
	
		// Vai que é aleatório
		assertEquals(pilha.size(), pilha.size());
	}
	
	@Test
	public void sizeAposDeletarElementos() {
		for (int i=0; i<5; i++)
			pilha.push(i+"");

		pilha.pop();
		pilha.pop();
		pilha.pop();
		
		assertEquals(pilha.size(), 5-3);
	}
	
	@Test(expected=EmptyStackException.class)
	public void popListaVazia() {
		pilha.pop();
	}
	
	@Test
	public void pop() {
		pilha.push("b");
		pilha.push("a");
		
		pilha.pop();
		assertEquals(pilha.size(), 1);
		pilha.pop();
		assertEquals(pilha.size(), 0);
	}


	@Test
	public void popUnicoElemento() {
		pilha.push("Elemento");
		pilha.pop();
		
		assertEquals(pilha.size(), 0);
	}
}