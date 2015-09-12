package matematica.geral;

import static org.junit.Assert.*;

import org.junit.Test;

public class IncognitaTest {	
	@Test
	public void vezesRepresentacaoIgualTest() {
		Incognita x = new Incognita('x');
		Incognita x2 = new Incognita('x', 2);
		
		Incognita x3 = new Incognita('x', 3);

		assertEquals(x3, x.vezes(x2));
	}

	@Test(expected=RuntimeException.class)
	public void vezesRepresentacaoDistintaTest() {
		Incognita x = new Incognita('x');
		Incognita y2 = new Incognita('y', 2);

		x.vezes(y2);
	}
	
	@Test
	public void isEquivalentTest() {
		Incognita x = new Incognita('x');
		Incognita x2 = new Incognita('x', 2);
		Incognita y = new Incognita('y');

		assertTrue(x.isEquivalent(x2));
		assertFalse(x.isEquivalent(y));
	}

	@Test
	public void isEqualsTest() {
		Incognita x = new Incognita('x');
		Incognita x1 = new Incognita('x', 1);
		Incognita x2 = new Incognita('x', 2);
		Incognita y = new Incognita('y');

		assertEquals(x, x1);
		assertEquals(x1, x);
		assertNotEquals(x, x2);
		assertNotEquals(x2, x);
		assertNotEquals(x, y);
	}

	@Test
	public void isUnitariaTest() {
		Incognita x0 = new Incognita('x', 0);
		Incognita x = new Incognita('x');

		assertTrue(x0.isUnitaria());
		assertFalse(x.isUnitaria());
	}
}
