
package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.geral.Incognita;
import matematica.geral.polinomio.Monomio;
import matematica.geral.polinomio.Polinomio;
import matematica.geral.polinomio.ParteLiteral;

import org.junit.Test;

public class PolinomioTeste {

	@Test
	public void unitarioTest() {
		Polinomio unitario = Polinomio.unitario();

		Polinomio unitario2 = Polinomio.nulo()
			.mais(new Monomio(1));
		
		Polinomio naoUnitario = Polinomio.nulo()
				.mais(new Monomio(2));

		assertEquals(unitario, unitario2);
		assertNotEquals(unitario, naoUnitario);
	}

	@Test
	public void equalsTest() {
		Incognita x4 = new Incognita('x', 4);
		Incognita x5 = new Incognita('x', 5);

		Monomio termo2x4 = new Monomio(2, ParteLiteral.com(x4));
		Monomio termo2x5 = new Monomio(2, ParteLiteral.com(x5));

		Polinomio y1 = Polinomio.nulo().mais(termo2x4);
		Polinomio y2 = Polinomio.nulo().mais(termo2x4);

		Polinomio y3 = Polinomio.nulo().mais(termo2x5);
		Polinomio yVazio = Polinomio.nulo();

		assertEquals(y1, y1);
		assertEquals(yVazio, yVazio);

		assertEquals(y1, y2);
		
		assertNotEquals(y1, y3);
		assertNotEquals(y1, yVazio);
	}

	@Test
	public void maisTest() {
		Incognita x = new Incognita('x');

		// 2x^4 + 2x^3 + 2x^2 + 2x^0
		Polinomio y1 = Polinomio.nulo()
				.mais(new Monomio(2, ParteLiteral.com(x, x, x, x)))
				.mais(new Monomio(2, ParteLiteral.com(x, x, x)))
				.mais(new Monomio(2, ParteLiteral.com(x, x)))
				.mais(new Monomio(2));

		// 1x^5 + 0x^3 + 1x^2
		Polinomio y2 = Polinomio.nulo()
				.mais(new Monomio(1, ParteLiteral.com(x, x, x, x, x)))
				.mais(new Monomio(0, ParteLiteral.com(x, x, x)))
				.mais(new Monomio(1, ParteLiteral.com(x, x)));
		  

		Polinomio yResultado = Polinomio.nulo()
		  .mais(new Monomio(1, ParteLiteral.com(x, x, x, x, x)))
		  .mais(new Monomio(2, ParteLiteral.com(x, x, x, x)))
		  .mais(new Monomio(2, ParteLiteral.com(x, x, x)))
		  .mais(new Monomio(3, ParteLiteral.com(x, x)))
		  .mais(new Monomio(2));


		assertEquals(yResultado, y1.mais(y2));
		assertEquals(yResultado, y2.mais(y1));
	}

	@Test
	public void menosMonomioTest() {
		Incognita x = new Incognita('x');

		// 3x^4 + 2x^2
		Polinomio y1 = Polinomio.nulo()
				.mais(new Monomio(3, ParteLiteral.com(x, x, x, x)))
				.mais(new Monomio(2, ParteLiteral.com(x, x)));

		// 2x^4
		Monomio y2 = new Monomio(2, ParteLiteral.com(x, x, x, x));

		// 3x^4 + 2x^2 - 2x^4 = 1x^4 + 2x^2
		Polinomio yResultado1 = Polinomio.nulo()
		  .mais(new Monomio(1, ParteLiteral.com(x, x, x, x)))
		  .mais(new Monomio(2, ParteLiteral.com(x, x)));

		assertEquals(yResultado1, y1.menos(y2));
	}

	@Test
	public void menosPolinomioTest() {
		Incognita x = new Incognita('x');

		// 3x^4 + 2x^2
		Polinomio y1 = Polinomio.nulo()
				.mais(new Monomio(3, ParteLiteral.com(x, x, x, x)))
				.mais(new Monomio(2, ParteLiteral.com(x, x)));

		// 2x^4 - 5x^3
		Polinomio y2 = Polinomio.nulo()
				.mais(new Monomio(2, ParteLiteral.com(x, x, x, x)))
				.mais(new Monomio(-5, ParteLiteral.com(x, x, x)));

		// 3x^4 + 2x^2 - (2x^4 - 5x^3) = 1x^4 + 5x^3 + 2x^2
		Polinomio yResultado1 = Polinomio.nulo()
		  .mais(new Monomio(1, ParteLiteral.com(x, x, x, x)))
		  .mais(new Monomio(5, ParteLiteral.com(x, x, x)))
		  .mais(new Monomio(2, ParteLiteral.com(x, x)));

		// 2x^4 - 5x^3 - (3x^4 + 2x^2) = -1x^4 - 5x^3 - 2x^2
		Polinomio yResultado2 = Polinomio.nulo()
		  .mais(new Monomio(-1, ParteLiteral.com(x, x, x, x)))
		  .mais(new Monomio(-5, ParteLiteral.com(x, x, x)))
		  .mais(new Monomio(-2, ParteLiteral.com(x, x)));

		assertEquals(yResultado1, y1.menos(y2));
		assertEquals(yResultado2, y2.menos(y1));
	}
	
	@Test
	public void vezesTest() {
		Incognita x = new Incognita('x');

		// 2x^4 + 2x^3
		Polinomio y1 = Polinomio.nulo()
			.mais(new Monomio(2, ParteLiteral.com(x, x, x, x)))
			.mais(new Monomio(2, ParteLiteral.com(x, x, x)));

		// 2x^3 + 1x^2
		Polinomio y2 = Polinomio.nulo()
			.mais(new Monomio(2, ParteLiteral.com(x, x, x)))
			.mais(new Monomio(1, ParteLiteral.com(x, x)));

		// + 4.0x^7  + 6.0x^6  + 2.0x^5
		Polinomio yResultado = Polinomio.nulo()
		  .mais(new Monomio(4, ParteLiteral.com(x, x, x, x, x, x, x)))
		  .mais(new Monomio(6, ParteLiteral.com(x, x, x, x, x, x)))
		  .mais(new Monomio(2, ParteLiteral.com(x, x, x, x, x)));

		assertEquals(yResultado, y1.vezes(y2));
		assertEquals(yResultado, y2.vezes(y1));
	}

	@Test
	public void termoIndependenteTest() {
		Monomio mZero = Monomio.nulo();
		Monomio mUnitario = Monomio.unitario();

		Polinomio unitario = Polinomio.unitario();
		Polinomio semUnitario = Polinomio.nulo()
				.mais(Monomio.unitario().vezes(2).vezes(new Incognita('x', 2)));

		assertEquals(mUnitario, unitario.termoIndependente());
		assertEquals(mZero, semUnitario.termoIndependente());
	}

	@Test
	public void isEquivalenteMesmaQuantidadeDeIncognitasTest() {
		Incognita x = new Incognita('x');
		
		ParteLiteral x2 = ParteLiteral.com(x, x);
		ParteLiteral x3 = ParteLiteral.com(x, x, x);
		ParteLiteral x4 = ParteLiteral.com(x, x, x, x);

		// 3x^4 + 2x^2
		Polinomio y1 = Polinomio.nulo()
				.mais(new Monomio(3, x4))
				.mais(new Monomio(2, x2));

		// 2x^4 - 5x^3
		Polinomio y2 = Polinomio.nulo()
				.mais(new Monomio(2, x4))
				.menos(new Monomio(5, x3));

		// 9x^4 - 2x^3
		Polinomio y3 = Polinomio.nulo()
				.mais(new Monomio(9, x4))
				.menos(new Monomio(2, x3));

		assertTrue(y1.isEquivalente(y1));
		assertFalse(y1.isEquivalente(y2));
		assertFalse(y1.isEquivalente(y3));

		assertTrue(y2.isEquivalente(y2));
		assertTrue(y2.isEquivalente(y3));
		assertTrue(y3.isEquivalente(y2));
	}
	
	@Test
	public void isEquivalenteQuantidadeDeIncognitasDiferentesTest() {
		Incognita x = new Incognita('x');

		ParteLiteral x2 = ParteLiteral.com(x, x);
		ParteLiteral x3 = ParteLiteral.com(x, x, x);
		ParteLiteral x4 = ParteLiteral.com(x, x, x, x);

		// 3x^4 + 2x^2 - 5
		Polinomio y1 = Polinomio.nulo()
				.mais(new Monomio(3, x4))
				.mais(new Monomio(2, x2))
				.menos(new Monomio(5));

		// 2x^4 - 5x^2
		Polinomio y2 = Polinomio.nulo()
				.mais(new Monomio(2, x4))
				.mais(new Monomio(-5, x2));

		// 9x^4 - 2x^3
		Polinomio y3 = Polinomio.nulo()
				.mais(new Monomio(9, x4))
				.menos(new Monomio(2, x3));

		assertFalse(y1.isEquivalente(y2));
		assertFalse(y1.isEquivalente(y3));
		
		assertFalse(y2.isEquivalente(y1));
		assertFalse(y2.isEquivalente(y3));

		assertFalse(y1.isEquivalente(y3));
		assertFalse(y3.isEquivalente(y1));
	}
}