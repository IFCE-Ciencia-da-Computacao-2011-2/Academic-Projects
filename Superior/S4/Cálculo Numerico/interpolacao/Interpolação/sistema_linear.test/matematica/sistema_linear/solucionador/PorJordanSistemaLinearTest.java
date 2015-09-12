package matematica.sistema_linear.solucionador;

import static org.junit.Assert.*;

import matematica.sistema_linear.exception.EntradaException;
import matematica.sistema_linear.solucionador.PorJordanSistemaLinear;
import matematica.sistema_linear.SistemaLinear;
import matematica.sistema_linear.SistemaLinearBuilder;
import matematica.sistema_linear.SolucaoSistemaLinear;

import org.junit.Test;

public class PorJordanSistemaLinearTest {

	@Test
	public void solucionarTest() throws Exception {
		SistemaLinearBuilder builder = new SistemaLinearBuilder();

		// termoIndependente =  a0  a1  a2
		builder.addEquacao(4,  2, -3, -1)
			   .addEquacao(3,  1,  2,  1)
			   .addEquacao(1,  3, -1, -2);

		SolucaoSistemaLinear resultado = new SolucaoSistemaLinear()
				.addValorDaIncongnita(2)
				.addValorDaIncongnita(-1)
				.addValorDaIncongnita(3);

		SistemaLinear sistema = builder.criar();

		SolucionadorSistemaLinear resolvedor = new PorJordanSistemaLinear();
		assertEquals(resultado, resolvedor.solucionar(sistema));
	}

	@Test(expected=EntradaException.class)
	public void calcularTriangularTest() throws Exception {
		SistemaLinearBuilder builder = new SistemaLinearBuilder();

		// termoIndependente =  a0  a1  a2
		builder.addEquacao(4,  2, -3, -1)
			   .addEquacao(1,  3, -1, -2);

		SistemaLinear sistema = builder.criar();

		SolucionadorSistemaLinear resolvedor = new PorJordanSistemaLinear();
		resolvedor.solucionar(sistema);
	}
}
