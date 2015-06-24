package br.edu.ifce.estrutura.fila.teste;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import br.edu.ifce.estrutura.fila.Fila;
import br.edu.ifce.estrutura.fila.FilaVetor;

@RunWith(Parameterized.class)
public class FilaVetorTeste extends TestCase {

	@Parameters
	public static Collection<Object[]> parameters() {
		List<Fila<String>> filasTestadas = new ArrayList<>();

		filasTestadas.add(new FilaVetor<>());

		List<Object[]> retorno = new ArrayList<Object[]>();
		
		for (Fila<String> lista : filasTestadas)
			retorno.add(new Object[] {lista});

	    return retorno;
	}
	
	//////////////////
	
	@Before
	public void setUp() {
		fila = new FilaVetor<>();
	}

	private Fila<String> fila;

	public FilaVetorTeste(Fila<String> Fila) {
		this.fila = Fila;
	}

	@Test
	public void forcarReaproveitamentoDeVetorElementos() {
		// Inserindo elementos iniciais
		fila.enqueue("1");
		fila.enqueue("2");
		fila.enqueue("3");
		fila.enqueue("4");
		fila.enqueue("5");
		fila.enqueue("6");
		fila.enqueue("7");
		fila.enqueue("8");
		fila.enqueue("9");
		
		fila.dequeue();
		fila.dequeue();

		// Reaproveitando lista
		fila.enqueue("10");
		fila.enqueue("11");
		fila.enqueue("12");
		
		fila.dequeue();
		
		fila.enqueue("13");
		// Lista cheia. Deverá aumentá-la
		fila.enqueue("14");
		fila.enqueue("15");
	}

	@Test
	public void aumentoNormal() {
		// Inserindo elementos iniciais
		fila.enqueue("1");
		fila.enqueue("2");
		fila.enqueue("3");
		fila.enqueue("4");
		fila.enqueue("5");
		fila.enqueue("6");
		fila.enqueue("7");
		fila.enqueue("8");
		fila.enqueue("9");
		fila.enqueue("10");
		
		// Forçando aumento
		fila.enqueue("11");
	}

	@Test
	public void forcarReaproveitamentoDeVetorElementos2() {
		// Inserindo elementos iniciais
		fila.enqueue("1");
		fila.enqueue("2");
		fila.enqueue("3");
		fila.enqueue("4");
		fila.enqueue("5");
		fila.enqueue("6");
		fila.enqueue("7");
		fila.enqueue("8");
		fila.enqueue("9");
		fila.enqueue("10");
		
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();
		fila.dequeue();

		// Reaproveitando lista
		fila.enqueue("11");
		fila.enqueue("12");
		fila.enqueue("13");
		
		fila.dequeue();
		
		fila.enqueue("14");
		fila.enqueue("15");
	}
}