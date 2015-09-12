package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.geral.Incognita;
import matematica.geral.polinomio.Monomio;
import matematica.geral.polinomio.OperacaoMonomioException;
import matematica.geral.polinomio.ParteLiteral;

import org.junit.Test;

public class MonomioTest {
	@Test
	public void unitarioTest() {
		Monomio unitario = Monomio.unitario();
		
		assertEquals(1, unitario.coeficiente(), 0);
		assertEquals(0, unitario.parteLiteral().size());
	}

	@Test
	public void maisParteLiteralIgualTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x, y));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(x, y));

		Monomio resultado = new Monomio(3, ParteLiteral.com(x, y));
		
		assertEquals(resultado, monomio1.mais(monomio2));
		assertEquals(resultado, monomio2.mais(monomio1));
	}
	
	@Test(expected=OperacaoMonomioException.class)
	public void maisParteLiteralDiferenteIncognitasIguaisTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x, x, y));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(x, y));
		
		monomio1.mais(monomio2);
	}
	
	@Test(expected=OperacaoMonomioException.class)
	public void maisParteLiteralDiferenteIncognitasDiferentesTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(y));
		
		monomio1.mais(monomio2);
	}
	
	@Test
	public void menosTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x, y));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(x, y));

		Monomio resultado1 = new Monomio(-1, ParteLiteral.com(x, y));
		Monomio resultado2 = new Monomio(1, ParteLiteral.com(x, y));

		assertEquals(resultado1, monomio1.menos(monomio2));
		assertEquals(resultado2, monomio2.menos(monomio1));
	}
	
	@Test(expected=OperacaoMonomioException.class)
	public void menosParteLiteralDiferenteIncognitasDiferentesTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		
		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(y));
		
		monomio1.menos(monomio2);
	}

	@Test
	public void vezesMonomioTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');

		Monomio monomio1 = new Monomio(5, ParteLiteral.com(x));
		Monomio monomio2 = new Monomio(2, ParteLiteral.com(y));

		Monomio resultado = new Monomio(50, ParteLiteral.com(x, x, y));
		
		assertEquals(resultado, monomio1.vezes(monomio1).vezes(monomio2));
		assertEquals(resultado, monomio2.vezes(monomio1).vezes(monomio1));
	}

	@Test
	public void vezesDoubleTest() {
		Incognita x = new Incognita('x');

		Monomio resultado1 = new Monomio(-5, ParteLiteral.com(x));
		Monomio resultado2 = new Monomio(-15, ParteLiteral.com(x));
		Monomio resultado3 = new Monomio(0, ParteLiteral.com(x));

		Monomio monomio1 = new Monomio(5, ParteLiteral.com(x));
		monomio1 = monomio1.vezes(-1);

		assertEquals(resultado1, monomio1);
		
		monomio1 = monomio1.vezes(3);
		assertEquals(resultado2, monomio1);
		
		monomio1 = monomio1.vezes(0);
		assertEquals(resultado3, monomio1);
	}

	@Test
	public void vezesIncognitaTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');

		Monomio resultado1 = new Monomio(1, ParteLiteral.com(x, y));
		Monomio resultado2 = new Monomio(1, ParteLiteral.com(x, y, y));

		Monomio monomio1 = new Monomio(1, ParteLiteral.com(x));
		monomio1 = monomio1.vezes(y);
		assertEquals(resultado1, monomio1);
		
		monomio1 = monomio1.vezes(y);
		assertEquals(resultado2, monomio1);
	}

	@Test
	public void equalsNuloTest() {
		Monomio m1 = Monomio.nulo();
		Monomio m2 = Monomio.nulo();
		
		assertTrue(m1.equals(m2));
	}

	@Test
	public void equalsUmaIncognitaTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');

		Monomio mx     = new Monomio(1, ParteLiteral.com(x));
		Monomio mdoisx = new Monomio(2, ParteLiteral.com(x));
		Monomio mdoisx1 = new Monomio(2, ParteLiteral.com(x));
		Monomio my      = new Monomio(1, ParteLiteral.com(y));

		assertTrue(mdoisx.equals(mdoisx));
		assertTrue(mdoisx.equals(mdoisx1));
		assertFalse(mdoisx.equals(my));
		assertFalse(mdoisx.equals(mx));
	}
	
	@Test
	public void equalMultiplasIncognitasTest() {
		Incognita x = new Incognita('x');
		Incognita y = new Incognita('y');
		Incognita z = new Incognita('z');
		Incognita z2 = new Incognita('z', 2);

		Monomio xyz2 = new Monomio(1, ParteLiteral.com(x, y, z2));
		Monomio xyzz = new Monomio(1, ParteLiteral.com(x, y, z, z));
		Monomio xy   = new Monomio(2, ParteLiteral.com(x, y));

		assertTrue(xyz2.equals(xyzz));
		assertTrue(xyzz.equals(xyz2));
		assertFalse(xyz2.equals(xy));
		assertFalse(xy.equals(xyz2));
	}
	
	@Test
	public void toStringTest() {
		Incognita z = new Incognita('z');
		Incognita x2 = new Incognita('x', 2);

		Monomio xz2 = new Monomio(1, ParteLiteral.com(z, x2));
		Monomio menos2xz2 = new Monomio(-2, ParteLiteral.com(z, x2));

		assertEquals(" + 1.0x^2.0z^1.0", xz2.toString());
		assertEquals(" - 2.0x^2.0z^1.0", menos2xz2.toString());
	}
	
	@Test
	public void isTermoIndependenteTest() {
		Incognita z = new Incognita('z');

		Monomio mz = Monomio.unitario().vezes(z);
		Monomio menos2 = Monomio.unitario().vezes(-2);

		assertTrue(menos2.isTermoIndependente());
		assertFalse(mz.isTermoIndependente());
	}
	
	@Test
	public void compareToSemParteLiteralTest() {
		Incognita z = new Incognita('z');

		Monomio mz = Monomio.unitario().vezes(z);
		Monomio menos2 = Monomio.unitario().vezes(-2);
		
		assertEquals(1, mz.compareTo(menos2));
		assertEquals(-1, menos2.compareTo(mz));
	}

	@Test
	public void compareToComParteLiteralTest() {
		// Ver teste do compareTo da ParteLiteral para melhor
		// análise
		Incognita z = new Incognita('z');
		Incognita y = new Incognita('y');

		Monomio mz = Monomio.unitario().vezes(z);
		Monomio menos2 = Monomio.unitario().vezes(y).vezes(-2);
		
		assertEquals(1, mz.compareTo(menos2));
	}
}
