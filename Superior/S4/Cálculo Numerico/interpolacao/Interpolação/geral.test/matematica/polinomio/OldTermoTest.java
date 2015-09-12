package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.geral.polinomio.OldTermo;

import org.junit.Test;

public class OldTermoTest {

	@Test
	public void maisMesmoCoeficienteTest() {
		OldTermo termo1 = new OldTermo(2, 0);
		OldTermo termo2 = new OldTermo(1, 0);

		OldTermo resultado = new OldTermo(3, 0);
		assertEquals(resultado, termo1.mais(termo2));
		assertEquals(resultado, termo1.mais(termo2));

		termo1 = new OldTermo(2, 3);
		termo2 = new OldTermo(-1, 3);

		resultado = new OldTermo(1, 3);
		assertEquals(resultado, termo1.mais(termo2));
		assertEquals(resultado, termo1.mais(termo2));
	}

	@Test(expected=RuntimeException.class)
	public void maisCoeficienteDiferenteTest() {
		OldTermo termo1 = new OldTermo(2, 1);
		OldTermo termo2 = new OldTermo(1, 0);

		termo1.mais(termo2);
	}

	@Test
	public void vezesTest() {
		OldTermo termo1 = new OldTermo(1, 0);
		OldTermo termo2 = new OldTermo(1, 1);

		OldTermo resultado = new OldTermo(1, 1);
		assertEquals(resultado, termo1.vezes(termo2));
		assertEquals(resultado, termo2.vezes(termo1));
	}

	@Test
	public void sobreTest() {
		OldTermo termo1 = new OldTermo(6, 3);
		OldTermo termo2 = new OldTermo(3, 1);

		OldTermo resultado = new OldTermo(2, 2);
		assertEquals(resultado, termo1.sobre(termo2));
	}
}
