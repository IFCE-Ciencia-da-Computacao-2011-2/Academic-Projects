package interpolacao.lagrante.polinomio.test;

import static org.junit.Assert.*;
import interpolacao.lagrante.polinomio.Polinomio;
import interpolacao.lagrante.polinomio.Termo;

import org.junit.Test;

public class PolinomioTeste {

	@Test
	public void getTermoTest() {
		Termo termo2x4 = new Termo(2, 4);
		Termo termo2x5 = new Termo(2, 5);

		// 2x^4
		Polinomio y = new Polinomio().add(termo2x4);

		assertEquals(termo2x4, y.getTermoComMesmoExpoenteDo(termo2x4));
		assertEquals(new Termo(0, termo2x5.getExpoente()), y.getTermoComMesmoExpoenteDo(termo2x5));
		assertNotEquals(termo2x5, y.getTermoComMesmoExpoenteDo(termo2x5));
	}

	@Test
	public void equalsTest() {
		Polinomio y1 = new Polinomio().add(new Termo(2, 4));
		Polinomio y2 = new Polinomio().add(new Termo(2, 4));
		
		Polinomio y3 = new Polinomio().add(new Termo(2, 5));
		Polinomio yVazio = new Polinomio();

		assertEquals(y1, y1);
		assertEquals(yVazio, yVazio);

		assertEquals(y1, y2);
		
		assertNotEquals(y1, y3);
		assertNotEquals(y1, yVazio);
	}

	@Test
	public void somarComTest() {
		// 2x^4 + 2x^3 + 2x^2 + 2x^0
		Polinomio y1 = new Polinomio();
		y1.add(new Termo(2, 4))
		  .add(new Termo(2, 3))
		  .add(new Termo(2, 2))
		  .add(new Termo(2, 0));

		// 1x^5 + 0x^3 + 1x^2
		Polinomio y2 = new Polinomio();
		y2.add(new Termo(1, 5))
		  .add(new Termo(0, 3))
		  .add(new Termo(1, 2));

		Polinomio yResultado = new Polinomio()
		  .add(new Termo(1, 5))
		  .add(new Termo(2, 4))
		  .add(new Termo(2, 3))
		  .add(new Termo(3, 2))
		  .add(new Termo(2, 0));

		
		System.out.println("  " + y1);
		System.out.println("+ " + y2);
		System.out.println("--------------------------------");
		System.out.println(y1.somarCom(y2));

		assertEquals(yResultado, y1.somarCom(y2));
		assertEquals(yResultado, y2.somarCom(y1));
	}

	@Test
	public void multiplicarComTest() {
		// 2x^4 + 2x^3
		Polinomio y1 = new Polinomio();
		y1.add(new Termo(2, 4))
		  .add(new Termo(2, 3));

		// 2x^3 + 1x^2
		Polinomio y2 = new Polinomio();
		y2.add(new Termo(2, 3))
		  .add(new Termo(1, 2));

		// 4x^12 + 2x^8 + 4x^9 + 2x^6
		Polinomio yResultado = new Polinomio()
		  .add(new Termo(4, 12))
		  .add(new Termo(2, 8))
		  .add(new Termo(4, 9))
		  .add(new Termo(2, 6));
		
		System.out.println();
		System.out.println("  " + y1);
		System.out.println("* " + y2);
		System.out.println("--------------------------------");
		System.out.println(y1.multiplicarCom(y2));

		assertEquals(yResultado, y1.multiplicarCom(y2));
		assertEquals(yResultado, y2.multiplicarCom(y1));
	}
}
