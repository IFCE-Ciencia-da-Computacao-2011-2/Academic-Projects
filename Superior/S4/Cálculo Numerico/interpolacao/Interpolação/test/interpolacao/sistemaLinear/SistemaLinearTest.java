package interpolacao.sistemaLinear;

import static org.junit.Assert.*;

import org.junit.Test;

import interpolacao.sistemaLinear.sistemaLinear.ResolvedorSistemaLinear;
import interpolacao.sistemaLinear.sistemaLinear.ResolvedorSistemaLinearPorTriangulacao;
import interpolacao.sistemaLinear.sistemaLinear.SistemaLinear;
import interpolacao.sistemaLinear.sistemaLinear.SistemaLinearBuilder;
import interpolacao.sistemaLinear.sistemaLinear.SolucaoSistemaLinear;

public class SistemaLinearTest {

	@Test
	public void calcularTriangularTest() {
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

		ResolvedorSistemaLinear resolvedor = new ResolvedorSistemaLinearPorTriangulacao();
		assertEquals(resultado, resolvedor.resolver(sistema));
	}
}
