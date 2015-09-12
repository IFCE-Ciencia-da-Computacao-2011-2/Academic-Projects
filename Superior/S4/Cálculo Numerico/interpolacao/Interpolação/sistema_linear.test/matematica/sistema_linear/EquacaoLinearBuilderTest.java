package matematica.sistema_linear;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import matematica.geral.Incognita;
import matematica.geral.polinomio.Monomio;
import matematica.geral.polinomio.ParteLiteral;
import matematica.geral.polinomio.Polinomio;
import matematica.sistema_linear.EquacaoLinear;
import matematica.sistema_linear.EquacaoLinear.Coeficiente;
import matematica.sistema_linear.EquacaoLinearBuilder;

import org.junit.Test;

public class EquacaoLinearBuilderTest {

	/**
	 * Ao verificar o termo independente pelo polinômio, este
	 * deve ser negativo, pois no polinômio, ele fica mesmo lado
	 * dos outros termos na igualdade:
	 * 
	 * Equação linear: a + b + c + d = 5
	 * Polinômio: a + b + c + d - 5 = 0
	 */
	@Test
	public void buildTest() {
		double parteLiteral = 3;

		EquacaoLinear equacao = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1)).mais(new Coeficiente(2)).mais(new Coeficiente(3)).mais(new Coeficiente(4)).mais(new Coeficiente(5))
			.igualA(parteLiteral)
			.build();

		List<Monomio> termos = new ArrayList<>();
		termos.add(new Monomio(1, ParteLiteral.com(new Incognita('a'))));
		termos.add(new Monomio(2, ParteLiteral.com(new Incognita('b'))));
		termos.add(new Monomio(3, ParteLiteral.com(new Incognita('c'))));
		termos.add(new Monomio(4, ParteLiteral.com(new Incognita('d'))));
		termos.add(new Monomio(5, ParteLiteral.com(new Incognita('e'))));

		Polinomio polinomio = Polinomio.nulo();
		for (Monomio termo : termos)
			polinomio = polinomio.mais(termo);

		polinomio = polinomio.mais(new Monomio(parteLiteral * -1));

		assertEquals(polinomio, equacao.representacaoPolinomial());
		assertEquals(termos, equacao.termos());

		assertEquals(parteLiteral, equacao.termoIndependente(), 0);
		assertEquals(parteLiteral * -1, equacao.representacaoPolinomial().termoIndependente().coeficiente(), 0);
	}
}
