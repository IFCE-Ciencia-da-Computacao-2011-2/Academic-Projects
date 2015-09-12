
package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.geral.polinomio.OldTermo;
import matematica.geral.polinomio.OldPolinomio;

import org.junit.Test;

public class OldPolinomioTeste {

	@Test
	public void getTermoTest() {
		OldTermo termo2x4 = new OldTermo(2, 4);
		OldTermo termo2x5 = new OldTermo(2, 5);

		// 2x^4
		OldPolinomio y = OldPolinomio.nulo().add(termo2x4);

		assertEquals(termo2x4, y.getTermoComMesmoExpoenteDo(termo2x4));
		assertEquals(new OldTermo(0, termo2x5.expoente()), y.getTermoComMesmoExpoenteDo(termo2x5));
		assertNotEquals(termo2x5, y.getTermoComMesmoExpoenteDo(termo2x5));
	}

	@Test
	public void equalsTest() {
		OldPolinomio y1 = OldPolinomio.nulo().add(new OldTermo(2, 4));
		OldPolinomio y2 = OldPolinomio.nulo().add(new OldTermo(2, 4));

		OldPolinomio y3 = OldPolinomio.nulo().add(new OldTermo(2, 5));
		OldPolinomio yVazio = OldPolinomio.nulo();

		assertEquals(y1, y1);
		assertEquals(yVazio, yVazio);

		assertEquals(y1, y2);
		
		assertNotEquals(y1, y3);
		assertNotEquals(y1, yVazio);
	}

	@Test
	public void maisTest() {
		// 2x^4 + 2x^3 + 2x^2 + 2x^0
		OldPolinomio y1 = OldPolinomio.nulo();
		y1.add(new OldTermo(2, 4))
		  .add(new OldTermo(2, 3))
		  .add(new OldTermo(2, 2))
		  .add(new OldTermo(2, 0));

		// 1x^5 + 0x^3 + 1x^2
		OldPolinomio y2 = OldPolinomio.nulo();
		y2.add(new OldTermo(1, 5))
		  .add(new OldTermo(0, 3))
		  .add(new OldTermo(1, 2));

		OldPolinomio yResultado = OldPolinomio.nulo()
		  .add(new OldTermo(1, 5))
		  .add(new OldTermo(2, 4))
		  .add(new OldTermo(2, 3))
		  .add(new OldTermo(3, 2))
		  .add(new OldTermo(2, 0));

		
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
		OldPolinomio y1 = OldPolinomio.nulo();
		y1.add(new OldTermo(2, 4))
		  .add(new OldTermo(2, 3));

		// 2x^3 + 1x^2
		OldPolinomio y2 = OldPolinomio.nulo();
		y2.add(new OldTermo(2, 3))
		  .add(new OldTermo(1, 2));

		// + 4.0x^7  + 6.0x^6  + 2.0x^5
		OldPolinomio yResultado = OldPolinomio.nulo()
		  .add(new OldTermo(4, 7))
		  .add(new OldTermo(6, 6))
		  .add(new OldTermo(2, 5));

		assertEquals(yResultado, y1.vezes(y2));
		assertEquals(yResultado, y2.vezes(y1));
	}
}