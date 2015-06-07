package br.edu.ifce.estrutura.lista.teste;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import br.edu.ifce.estrutura.lista.ListED;
import br.edu.ifce.estrutura.lista.ListaDuplamenteEncadeada;
import br.edu.ifce.estrutura.lista.ListaEncadeada;
import br.edu.ifce.estrutura.lista.ListaVetor;

@RunWith(Parameterized.class)
public class ListEDTeste extends TestCase {
	
	@Parameters
	public static Collection<Object[]> parameters() {
		List<ListED<String>> listasTestadas = new ArrayList<>(10);

		listasTestadas.add(new ListaVetor<>());
		listasTestadas.add(new ListaVetor<>(7));
		listasTestadas.add(new ListaVetor<>(1500));
		
		listasTestadas.add(new ListaEncadeada<>());
		listasTestadas.add(new ListaDuplamenteEncadeada<>());

		List<Object[]> retorno = new ArrayList<Object[]>();
		
		for (ListED<String> lista : listasTestadas)
			retorno.add(new Object[] {lista});

	    return retorno;
	}
	
	//////////////////
	
	private ListED<String> lista;

	public ListEDTeste(ListED<String> lista) {
		this.lista = lista;
	}

	@Before
	public void setUp() {
		manualClear(lista);
	}
	
	private static void manualClear(ListED<?> lista) {
		while (lista.size() != 0)
			lista.remove(0);
	}

	@Test
	public void clear() {
		for (int i=0; i<200; i++)
			lista.insert(i+"");
		
		manualClear(lista);

		assertEquals(lista.size(), 0);
		
		for (int i=0; i<200; i++)
			lista.insert(i+"");
		
		manualClear(lista);
		
		assertEquals(lista.size(), 0);
	}

	@Test
	public void addElementosDiferentes() {
		lista.insert("1");
		lista.insert("2");
		lista.insert("3");

		assertEquals(lista.size(), 3);
	}

	/**
	 * Lista permite adição de elementos iguais. 
	 * Estes ficam em posições distintas.
	 */
	@Test
	public void addElementosIguais() {
		String objeto = "Macarronada assada";

		lista.insert(objeto);
		lista.insert(objeto);

		assertEquals(lista.size(), 2);
	}

	/**
	 * Verifica se pode adicionar muitos elementos sem quebrar
	 */
	@Test
	public void addEstouroDePilha() {
		final int totalElementos = 10000;

		String elemento = "total "+totalElementos;
		for (int i=0; i<totalElementos; i++)
			lista.insert(elemento);

		assertEquals(lista.size(), totalElementos);
	}

	@Test
	public void addEstouroDePilha2() {
		final int totalElementos = 10000;

		String elemento = "total "+totalElementos;
		for (int i=0; i<totalElementos; i++)
			lista.insert(elemento);
		
		for (int i=0; i<totalElementos; i++)
			lista.insert(elemento, i);

		assertEquals(lista.size(), totalElementos*2);
	}
	
	@Test
	public void addNoInicioVazio() {
		String elefante = "elefante";

		lista.insert(elefante, 0);
		
		assertTrue("Elemento nem sequer adicionado", lista.contains(elefante));
		assertEquals("Elemento adicionado na posição errada", lista.getElement(0), elefante);

		assertEquals("Elemento adicionado não foi contabilizado em size", lista.size(), 1);
	}
	
	@Test
	public void addNoInicio() {
		String macaco = "macaco";
		for (int i=0; i<30; i++)
			lista.insert(macaco + "" + i);

		String elefante = "elefante";

		lista.insert(elefante, 0);
		
		assertTrue("Elemento nem sequer adicionado", lista.contains(elefante));
		assertEquals("Elemento adicionado na posição errada", lista.getElement(0), elefante);
		assertEquals("Elementos posteriores foram reposicionados erroneamente", lista.getElement(1), macaco+"0");
		
		assertEquals("Elemento adicionado não foi contabilizado em size", lista.size(), 30 + 1);
	}

	@Test
	public void addNoMeio() {
		String macaco = "macaco";
		for (int i=0; i<30; i++)
			lista.insert(macaco + "" + i);

		String cobra = "cobra";
		
		lista.insert(cobra, 13);

		assertTrue("Elemento nem sequer adicionado", lista.contains(cobra));
		
		assertEquals("Elemento adicionado na posição errada", lista.getElement(13), cobra);
		
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(12), macaco+"12");
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(14), macaco+"13");
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(15), macaco+"14");

		assertEquals("Elemento adicionado não foi contabilizado em size", lista.size(), 30 + 1);
	}
	
	@Test
	public void addNaPosicaoAnteriorAoFim() {
		String macaco = "macaco";
		for (int i=0; i<30; i++)
			lista.insert(macaco + "" + i);

		String homem = "homem";
		lista.insert(homem, lista.size()-1);

		assertTrue("Elemento nem sequer adicionado", lista.contains(homem));
		
		assertEquals("Elemento adicionado na posição errada", lista.getElement(lista.size()-2), homem);
		
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(lista.size()-3), macaco+"28");
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(lista.size()-1), macaco+"29");

		assertEquals("Elemento adicionado não foi contabilizado em size", lista.size(), 30 + 1);
	}

	@Test
	public void addNoFim() {
		String macaco = "macaco";
		for (int i=0; i<30; i++)
			lista.insert(macaco + "" + i);
		
		String fim = "final";
		lista.insert(fim, lista.size());
		
		assertTrue("Elemento nem sequer adicionado", lista.contains(fim));
		assertEquals("Elemento adicionado na posição errada", lista.getElement(lista.size()-1), fim);
		assertEquals("Elementos foram reposicionados erroneamente", lista.getElement(lista.size()-2), macaco+"29");
		assertEquals("Elemento adicionado não foi contabilizado em size", lista.size(), 30 + 1);
	}
	
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void addAntesDoInicio() {
		String soin = "soin";
		for (int i=0; i<30; i++)
			lista.insert(soin + "i");
		
		String elefante = "elefante";
		
		lista.insert(elefante, -1);
		
		assertFalse("Elemento adicionados indevidamente", lista.contains(elefante));
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void addDepoisDoFim() {
		String soin = "soin";
		for (int i=0; i<30; i++)
			lista.insert(soin + "i");

		String homem = "homem";
		
		lista.insert(homem, lista.size()+1);
		
		assertFalse("Elemento adicionados indevidamente", lista.contains(homem));
	}

	@Test
	public void hasElementoAdicionado() {
		String palavraChave = "Bota preta";
		lista.insert(palavraChave);
		
		assertTrue(lista.contains(palavraChave));
	}

	
	@Test
	public void hasElementoNaoAdicionado() {
		String palavraAleatoria = ""+(Math.random() + Math.random() * Math.random()/3);

		lista.insert("1");
		lista.insert("2");
		lista.insert("3");

		assertFalse("Palavra aleatória " + palavraAleatoria + "não adicionada fora localizada o.O", lista.contains(palavraAleatoria));
	}
	
	
	@Test
	public void hasElementoNaPrimeiraReferencia() {
		lista.insert("bola");
		lista.insert("quadrado");

		assertTrue(lista.contains("bola"));
	}
	
	@Test
	public void hasNaUltimaReferencia() {
		String palavraAleatoria = ""+(Math.random() + Math.random() * Math.random()/3);

		lista.insert("bola");
		lista.insert("triangulo");
		lista.insert(palavraAleatoria);

		assertTrue(lista.contains(palavraAleatoria));
	}

	@Test
	public void hasPorReferencia() {
		String palavra = "Minha mãe é linda"; 
		lista.insert(palavra);

		assertTrue(lista.contains(palavra));
	}

	@Test
	public void hasPorEquals() {
		String string = new String("1234567890");
		String stringComConteudoIgualDaDeCimaMasComEnderecoDiferente = new String("1234567890");
		
		lista.insert(string);
		
		assertFalse(string == stringComConteudoIgualDaDeCimaMasComEnderecoDiferente);
		assertTrue(lista.contains(string));
	}

	@Test
	public void getPrimeiroElemento() {
		lista.insert("a");
		lista.insert("b");
		lista.insert("c");
		
		assertEquals(lista.getElement(0), "a");
	}

	@Test
	public void getUltimoElemento() {
		lista.insert("a");
		lista.insert("b");
		lista.insert("c");
		
		assertEquals(lista.getElement(lista.size()-1), "c");
	}
	
	@Test
	public void getElementoQualquer() {
		final int TOTAL_TESTES = 100;
		final int TOTAL_ELEMENTOS = 1000;

		for (int i=0; i<TOTAL_ELEMENTOS; i++)
			lista.insert(i+"");

		for (int i=0; i<TOTAL_TESTES; i++) {
			int numeroSorteado = (int) (TOTAL_ELEMENTOS * Math.random()); 
		
			assertEquals("Pego '" + lista.getElement(numeroSorteado) + "' mas deveria ser '" + numeroSorteado+"'", numeroSorteado+"", lista.getElement(numeroSorteado));
		}
	}

	@Test(expected=IndexOutOfBoundsException.class)
	public void getElementoAntesDoInicio() {
		lista.insert("askdnb jnaldh aw jlbals");
		lista.getElement(-1);
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void getElementoDepoisDoFim() {
		lista.insert("askdnb jnaldh aw jlbals");
		lista.getElement(lista.size());
	}
		
	@Test(expected=IndexOutOfBoundsException.class)
	public void getElementoDepoisDoFim2() {
		lista.insert("askdnb jnaldh aw jlbals");
		lista.getElement(lista.size()+2);
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void getElementoEmListaVazia() {
		lista.getElement(lista.size());
	}

	@Test
	public void sizeVazio() {
		assertEquals(lista.size(), 0);
	}
	
	@Test
	public void sizePreenchido() {
		final int TOTAL_ELEMENTOS = 7;
		for (int i=0; i<TOTAL_ELEMENTOS; i++)
			lista.insert(i+"");
		
		assertEquals(lista.size(), TOTAL_ELEMENTOS);
	}

	@Test
	public void sizeNaoAleatorio() {
		for (int i=0; i<5; i++)
			lista.insert(i+"");
	
		// Vai que é aleatório
		assertEquals(lista.size(), lista.size());
	}
	
	@Test
	public void sizeAposDeletarElementos() {
		for (int i=0; i<5; i++)
			lista.insert(i+"");

		lista.remove(0);
		lista.remove(0);
		lista.remove(0);
		
		assertEquals(lista.size(), 5-3);
	}
	
	@Test
	public void removePrimeiroElementoDaLista() {
		String primeiro = "a", segundo = "b", terceiro = "c", quarto = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quarto);
		lista.insert(ultimo);

		// Remover primeiro
		//String removido = lista.remove(0);
		lista.remove(0);

		assertEquals(lista.getElement(0), segundo);
		//assertEquals(removido, primeiro);
		assertFalse(lista.contains(primeiro));
	}
	
	@Test
	public void removeElementoDoMeioDaLista() {
		String primeiro = "a", segundo = "b", terceiro = "c", quarto = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quarto);
		lista.insert(ultimo);
		
		lista.remove(2);
		//String removido = lista.remove(3);
		
		assertEquals(lista.size(), 4);
		assertEquals(lista.getElement(2), quarto);
		assertEquals(lista.getElement(3), ultimo);
		
		//assertEquals(removido, ultimo);
		assertFalse(lista.contains(terceiro));
	}
	
	@Test
	public void removeElementoDoFimDaLista() {
		String primeiro = "a", segundo = "b", terceiro = "c", quatro = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quatro);
		lista.insert(ultimo);
		
		lista.remove(4);
		//String removido = lista.remove(4);
		
		assertEquals(lista.size(), 4);
		assertEquals(lista.getElement(3), quatro);
		
		//assertEquals(removido, ultimo);
		assertFalse(lista.contains(ultimo));
	}

	@Test
	public void removeUnicoElemento() {
		lista.insert("Elemento");
		lista.remove(0);
		
		assertEquals(lista.size(), 0);
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void getElementoRemovido() {
		lista.insert("Elemento");
		lista.remove(0);

		lista.getElement(0);
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void removeElementoAntesDoInicio() {
		String primeiro = "a", segundo = "b", terceiro = "c", quarto = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quarto);
		lista.insert(ultimo);

		
		lista.remove(-1);
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void removeElementoDepoisDoFim() {
		String primeiro = "a", segundo = "b", terceiro = "c", quarto = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quarto);
		lista.insert(ultimo);

		lista.remove(lista.size());
	}
	
	@Test(expected=IndexOutOfBoundsException.class)
	public void removeDePosicoesDeletadas() {
		String primeiro = "a", segundo = "b", terceiro = "c", quarto = "d", ultimo = "e";
		
		lista.insert(primeiro);
		lista.insert(segundo);
		lista.insert(terceiro);
		lista.insert(quarto);
		lista.insert(ultimo);

		int tamanhoOriginal = lista.size();
		
		lista.remove(0);
		lista.remove(1);
		
		lista.remove(tamanhoOriginal-1);
	}
}