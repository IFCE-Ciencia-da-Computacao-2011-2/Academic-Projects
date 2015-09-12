package matematica.polinomio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertTrue;
import matematica.geral.Incognita;
import matematica.geral.polinomio.ParteLiteral;

import org.junit.Test;

public class ParteLiteralTest {
	@Test
	public void constructorTest() {
		Incognita x = new Incognita('x');
		ParteLiteral parteLiteral = ParteLiteral.com(x, x);

		Incognita x2 = new Incognita('x', 2);
		ParteLiteral resultado = ParteLiteral.com(x2);

		assertEquals(resultado, parteLiteral);
	}

	@Test
	public void vezesParteLiteralTest() {
		Incognita x = new Incognita('x');
		ParteLiteral parteLiteral = ParteLiteral.com(x);

		Incognita x2 = new Incognita('x', 2);
		ParteLiteral resultado = ParteLiteral.com(x2);

		assertEquals(resultado, parteLiteral.vezes(parteLiteral));
	}

	@Test
	public void vezesParteLiteralTest2() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		ParteLiteral parte1 = ParteLiteral.com(x, x, y);
		ParteLiteral parte2 = ParteLiteral.com(x, y);

		assertFalse(parte1.equals(parte2));
	}

	@Test
	public void vezesIncognitasIguaisTest() {
		Incognita x = new Incognita('x');
		ParteLiteral parteLiteral = ParteLiteral.com(x);

		Incognita x2 = new Incognita('x', 2);
		ParteLiteral resultado = ParteLiteral.com(x2);

		assertEquals(resultado, parteLiteral.vezes(x));
	}
	
	@Test
	public void vezesIncognitasDiferentesTest() {
		Incognita x = new Incognita('x');
		Incognita y3 = new Incognita('y', 3);

		ParteLiteral resultado = ParteLiteral.com(x, y3);

		ParteLiteral px = ParteLiteral.com(x);

		assertEquals(resultado, px.vezes(y3));
	}

	@Test
	public void isEquivalenteTest() {
		Incognita x = new Incognita('x');
		Incognita x2 = new Incognita('x', 2);
		Incognita y = new Incognita('y');

		assertTrue(ParteLiteral.com(x).isEquivalente(ParteLiteral.com(x2)));
		assertFalse(ParteLiteral.com(x).isEquivalente(ParteLiteral.com(y)));
		assertFalse(ParteLiteral.com(x, y).isEquivalente(ParteLiteral.com(y)));
	}

	@Test
	public void equalsTest() {
		Incognita x = new Incognita('x');
		Incognita x1 = new Incognita('x', 1);
		Incognita y = new Incognita('y');

		ParteLiteral px = ParteLiteral.com(x); 
		ParteLiteral px1 = ParteLiteral.com(x1);
		ParteLiteral py = ParteLiteral.com(y);
		ParteLiteral pyx = ParteLiteral.com(y, x);

		assertEquals(px, px1);
		assertEquals(px1, px);
		assertNotEquals(px, py);
		assertNotEquals(py, px);
		assertNotEquals(px, pyx);
	}
}
