package matematica.polinomio;

import static org.junit.Assert.*;
import matematica.polinomio.Monomio;

import org.junit.Test;

public class MonomioTest {

	@Test
	public void maisMesmoCoeficienteTest() {
		Monomio termo1 = new Monomio(2, 0);
		Monomio termo2 = new Monomio(1, 0);

		Monomio resultado = new Monomio(3, 0);
		assertEquals(resultado, termo1.mais(termo2));
		assertEquals(resultado, termo1.mais(termo2));

		termo1 = new Monomio(2, 3);
		termo2 = new Monomio(-1, 3);

		resultado = new Monomio(1, 3);
		assertEquals(resultado, termo1.mais(termo2));
		assertEquals(resultado, termo1.mais(termo2));
	}

	@Test
	public void maisCoeficienteDiferenteTest() {
		Monomio termo1 = new Monomio(2, 1);
		Monomio termo2 = new Monomio(1, 0);

		termo1.mais(termo2);
	}

	@Test
	public void vezesTest() {
		Monomio termo1 = new Monomio(1, 0);
		Monomio termo2 = new Monomio(1, 1);

		Monomio resultado = new Monomio(1, 1);
		assertEquals(resultado, termo1.vezes(termo2));
		assertEquals(resultado, termo2.vezes(termo1));
	}

	@Test
	public void sobreTest() {
		Monomio termo1 = new Monomio(6, 3);
		Monomio termo2 = new Monomio(3, 1);

		Monomio resultado = new Monomio(2, 2);
		assertEquals(resultado, termo1.sobre(termo2));
	}
}
