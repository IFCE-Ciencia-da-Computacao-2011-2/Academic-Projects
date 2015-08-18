
package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.polinomio.Polinomio;
import matematica.polinomio.Monomio;

import org.junit.Test;

public class PolinomioTeste {

	@Test
	public void getTermoTest() {
		Monomio termo2x4 = new Monomio(2, 4);
		Monomio termo2x5 = new Monomio(2, 5);

		// 2x^4
		Polinomio y = Polinomio.nulo().add(termo2x4);

		assertEquals(termo2x4, y.getTermoComMesmoExpoenteDo(termo2x4));
		assertEquals(new Monomio(0, termo2x5.expoente()), y.getTermoComMesmoExpoenteDo(termo2x5));
		assertNotEquals(termo2x5, y.getTermoComMesmoExpoenteDo(termo2x5));
	}

	@Test
	public void equalsTest() {
		Polinomio y1 = Polinomio.nulo().add(new Monomio(2, 4));
		Polinomio y2 = Polinomio.nulo().add(new Monomio(2, 4));

		Polinomio y3 = Polinomio.nulo().add(new Monomio(2, 5));
		Polinomio yVazio = Polinomio.nulo();

		assertEquals(y1, y1);
		assertEquals(yVazio, yVazio);

		assertEquals(y1, y2);
		
		assertNotEquals(y1, y3);
		assertNotEquals(y1, yVazio);
	}

	@Test
	public void maisTest() {
		// 2x^4 + 2x^3 + 2x^2 + 2x^0
		Polinomio y1 = Polinomio.nulo();
		y1.add(new Monomio(2, 4))
		  .add(new Monomio(2, 3))
		  .add(new Monomio(2, 2))
		  .add(new Monomio(2, 0));

		// 1x^5 + 0x^3 + 1x^2
		Polinomio y2 = Polinomio.nulo();
		y2.add(new Monomio(1, 5))
		  .add(new Monomio(0, 3))
		  .add(new Monomio(1, 2));

		Polinomio yResultado = Polinomio.nulo()
		  .add(new Monomio(1, 5))
		  .add(new Monomio(2, 4))
		  .add(new Monomio(2, 3))
		  .add(new Monomio(3, 2))
		  .add(new Monomio(2, 0));

		
		System.out.println("  " + y1);
		System.out.println("+ " + y2);
		System.out.println("--------------------------------");
		System.out.println(y1.mais(y2));

		assertEquals(yResultado, y1.mais(y2));
		assertEquals(yResultado, y2.mais(y1));
	}

	@Test
	public void vezesTest() {
		// 2x^4 + 2x^3
		Polinomio y1 = Polinomio.nulo();
		y1.add(new Monomio(2, 4))
		  .add(new Monomio(2, 3));

		// 2x^3 + 1x^2
		Polinomio y2 = Polinomio.nulo();
		y2.add(new Monomio(2, 3))
		  .add(new Monomio(1, 2));

		// + 4.0x^7  + 6.0x^6  + 2.0x^5
		Polinomio yResultado = Polinomio.nulo()
		  .add(new Monomio(4, 7))
		  .add(new Monomio(6, 6))
		  .add(new Monomio(2, 5));

		assertEquals(yResultado, y1.vezes(y2));
		assertEquals(yResultado, y2.vezes(y1));
	}
}