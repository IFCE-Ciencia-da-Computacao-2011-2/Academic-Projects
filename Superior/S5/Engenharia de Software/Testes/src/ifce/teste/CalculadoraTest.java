package ifce.teste;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * O framework de testes utilizado foi o JUnit.
 * 
 * Ele foi desenvolvido inicialmente por Erich Gamma e Kent Beck, sendo o �ltimo
 * atribu�do como criador do XP e TDD.
 * 
 * Seu principal uso � para testes unit�rios, onde 
 * pequenos trechos de c�digo - como m�todos - s�o testados utilizando-se
 * das assertivas dispostas pela biblioteca.
 * 
 * Tamb�m � utilizado para testes caixa-preta, juntamente com
 * Selenium, por exemplo.
 * 
 * Acredito que pode-se utilizar o c�digo abaixo como auto-explica��o.
 * Qualquer d�vida ou necessidade de verifica��o de aprendizado,
 * perguntar � minha pessoa
 */
public class CalculadoraTest {

	private Calculadora calculadora;

	@Before
	public void before() {
		this.calculadora = new Calculadora();
	}

	@Test
	public void somarTest() {
		assertEquals(2+ -3, calculadora.somar(2, -3));

		// Comutatividade
		assertEquals(2+3, calculadora.somar(2, 3));
		assertEquals(3+2, calculadora.somar(3, 2));
		
		// Associa��o
		assertEquals(calculadora.somar(5, calculadora.somar(3, 2)), calculadora.somar(calculadora.somar(5, 3), 2));

		// Elemento neutro
		assertEquals(2 + 0, calculadora.somar(2, 0));

		// Fechamento
		//assertTrue(new Integer(calculadora.somar(2, 3)) instanceof Integer);
	}

	@Test
	public void subtrairTest() {
		assertEquals(2 - 3, calculadora.subtrair(2, 3));
		assertEquals(3 - (-2), calculadora.subtrair(3, -2));
	}
	
	@Test
	public void multiplicarTest() {
		// Comutatividade
		assertEquals(2*3, calculadora.multiplicar(2, 3));
		assertEquals(3*2, calculadora.multiplicar(3, 2));

		// Associa��o
		assertEquals(calculadora.multiplicar(5, calculadora.multiplicar(3, 2)), calculadora.multiplicar(calculadora.multiplicar(5, 3), 2));

		// Elemento neutro
		assertEquals(-5 * 1, calculadora.multiplicar(-5, 1));
		
		// Elemento nulo
		assertEquals(2 * 0, calculadora.multiplicar(2, 0));
	}
	
	@Test
	public void dividirTest() {
		assertEquals(4/2, calculadora.dividir(4, 2));

		// Sempre arredonda pra baixo
		assertEquals(5/2, calculadora.dividir(5, 2));
		assertEquals(9/7, calculadora.dividir(9, 7));
		assertEquals(13/7, calculadora.dividir(13, 7));
		
		// Quociente de dois n�meros inteiros com sinais iguais
		assertTrue(calculadora.dividir(13, 7) > 0);
		assertTrue(calculadora.dividir(-13, -7) > 0);
		
		// Quociente de dois n�meros inteiros com sinais diferentes
		assertTrue(calculadora.dividir(-13, 7) < 0);
		assertTrue(calculadora.dividir(13, -7) < 0);
	}
}

