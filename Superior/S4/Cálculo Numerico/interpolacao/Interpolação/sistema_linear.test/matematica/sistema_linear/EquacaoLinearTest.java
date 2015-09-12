package matematica.sistema_linear;

import static org.junit.Assert.*;
import matematica.sistema_linear.EquacaoLinear;
import matematica.sistema_linear.EquacaoLinear.Coeficiente;
import matematica.sistema_linear.exception.OperacaoEquacaoLinearException;
import matematica.sistema_linear.EquacaoLinearBuilder;

import org.junit.Test;

public class EquacaoLinearTest {

	@Test
	public void toStringTest() {
		EquacaoLinear equacao = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1)).mais(new Coeficiente(2)).mais(new Coeficiente(3)).mais(new Coeficiente(4)).mais(new Coeficiente(5))
			.igualA(3)
			.build();

		String esperado = " + 1.0a0 + 2.0a1 + 3.0a2 + 4.0a3 + 5.0a4 = 3.0";
		assertEquals(esperado, equacao.toString());
	}

	@Test
	public void maisTest() {
		EquacaoLinear equacao1 = new EquacaoLinearBuilder()
			.mais(new Coeficiente(2)).mais(new Coeficiente(2))
			.igualA(0)
			.build();
		EquacaoLinear equacao2 = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1)).mais(new Coeficiente(5))
			.igualA(1)
			.build();
		
		EquacaoLinear resultado = new EquacaoLinearBuilder()
			.mais(new Coeficiente(3)).mais(new Coeficiente(7))
			.igualA(1)
			.build();

		assertEquals(resultado, equacao1.mais(equacao2));
	}
	
	@Test(expected=OperacaoEquacaoLinearException.class)
	public void maisComErrorTest() {
		EquacaoLinear equacao1 = new EquacaoLinearBuilder()
		.mais(new Coeficiente(2)).mais(new Coeficiente(2))
		.igualA(0)
		.build();
	EquacaoLinear equacao2 = new EquacaoLinearBuilder()
		.mais(new Coeficiente(1))
		.igualA(1)
		.build();
		
		equacao1.mais(equacao2);
	}
	
	@Test
	public void menosTest() {
		EquacaoLinear equacao1 = new EquacaoLinearBuilder()
		  .mais(new Coeficiente(2)).mais(new Coeficiente(2))
		  .igualA(2)
		  .build();
		
		EquacaoLinear equacao2 = new EquacaoLinearBuilder()
		  .mais(new Coeficiente(1)).mais(new Coeficiente(5))
		  .igualA(2)
		  .build();

		EquacaoLinear resultado1 = new EquacaoLinearBuilder()
		  .mais(new Coeficiente(1)).mais(new Coeficiente(-3))
		  .igualA(0)
		  .build();
		
		EquacaoLinear resultado2 = new EquacaoLinearBuilder()
		  .mais(new Coeficiente(-1)).mais(new Coeficiente(3))
		  .igualA(0)
		  .build();

		assertEquals(resultado1, equacao1.menos(equacao2));
		assertEquals(resultado2, equacao2.menos(equacao1));
	}

	@Test(expected=OperacaoEquacaoLinearException.class)
	public void menosComErrorTest() {
		EquacaoLinear equacao1 = new EquacaoLinearBuilder()
			.mais(new Coeficiente(2)).mais(new Coeficiente(2))
			.igualA(0)
			.build();
		EquacaoLinear equacao2 = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1))
			.igualA(1)
			.build();
			
		equacao1.menos(equacao2);
	}

	@Test
	public void vezesTest() {
		double multiplicador = 3.0;

		EquacaoLinear equacao = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1))
			.mais(new Coeficiente(5))
			.igualA(2)
			.build();
		EquacaoLinear resultado = new EquacaoLinearBuilder()
			.mais(new Coeficiente(1*multiplicador))
			.mais(new Coeficiente(5*multiplicador))
			.igualA(2*multiplicador)
			.build();

		assertEquals(resultado, equacao.vezes(multiplicador));
	}
}
