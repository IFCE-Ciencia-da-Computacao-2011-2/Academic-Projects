package matematica.sistema_linear;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;

import org.junit.Test;

public class SolucaoSistemaLinearTest {

	@Test
	public void equalsTest() {
		SolucaoSistemaLinear solucao = new SolucaoSistemaLinear();
		solucao.addValorDaIncongnita(2)
			   .addValorDaIncongnita(3)
			   .addValorDaIncongnita(4);

		SolucaoSistemaLinear solucao2 = new SolucaoSistemaLinear();
		solucao2.addValorDaIncongnita(2)
			    .addValorDaIncongnita(3)
			    .addValorDaIncongnita(4);

		assertEquals(solucao, solucao2);
		assertEquals(solucao2, solucao);
		
		assertEquals(solucao, solucao);
	}

	@Test
	public void notEqualsTest() {
		SolucaoSistemaLinear solucao = new SolucaoSistemaLinear();
		solucao.addValorDaIncongnita(2)
			   .addValorDaIncongnita(3)
			   .addValorDaIncongnita(4);

		SolucaoSistemaLinear solucao2 = new SolucaoSistemaLinear();
		solucao2.addValorDaIncongnita(2)
			    .addValorDaIncongnita(3);

		SolucaoSistemaLinear solucao3 = new SolucaoSistemaLinear();
		solucao2.addValorDaIncongnita(2)
			    .addValorDaIncongnita(4)
			    .addValorDaIncongnita(3);

		assertNotEquals(solucao, solucao2);
		assertNotEquals(solucao, solucao3);
		
		assertNotEquals(solucao2, solucao3);
	}

	@Test
	public void toStringTest() {
		SolucaoSistemaLinear solucao = new SolucaoSistemaLinear();
		solucao.addValorDaIncongnita(2)
			   .addValorDaIncongnita(3)
			   .addValorDaIncongnita(4);

		System.out.println(solucao);
	}
}
