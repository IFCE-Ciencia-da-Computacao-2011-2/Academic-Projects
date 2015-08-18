package interpolacao.sistemaLinear;

import static org.junit.Assert.*;

import org.junit.Test;

import interpolacao.sistemaLinear.sistemaLinear.EquacaoLinear;
import interpolacao.sistemaLinear.sistemaLinear.EquacaoLinearBuilder;

public class EquacaoLinearTest {

	@Test
	public void toStringTest() {
		EquacaoLinear equacao = EquacaoLinearBuilder.criar(0, 1, 2, 3, 4, 5);
		
		System.out.println(equacao);
	}

	@Test
	public void somarComTest() {
		EquacaoLinear equacao1 = EquacaoLinearBuilder.criar(0, 2, 2);
		EquacaoLinear equacao2 = EquacaoLinearBuilder.criar(1, 1, 5);
		
		EquacaoLinear resultado = EquacaoLinearBuilder.criar(1, 3, 7);

		assertEquals(resultado, equacao1.somarCom(equacao2));
	}
	
	@Test
	public void subtrairComTest() {
		EquacaoLinear equacao1 = EquacaoLinearBuilder.criar(2, 2, 2);
		EquacaoLinear equacao2 = EquacaoLinearBuilder.criar(2, 1, 5);
		
		EquacaoLinear resultado = EquacaoLinearBuilder.criar(0, 1, -3);

		assertEquals(resultado, equacao1.subtrairCom(equacao2));
	}

	@Test
	public void multiplicarPorTest() {
		double multiplicador = 3.0;

		EquacaoLinear equacao   = EquacaoLinearBuilder.criar(5, 1, 5);
		EquacaoLinear resultado = EquacaoLinearBuilder.criar(5*multiplicador, 1*multiplicador, 5*multiplicador);

		assertEquals(resultado, equacao.multiplicarPor(3));
	}
}
