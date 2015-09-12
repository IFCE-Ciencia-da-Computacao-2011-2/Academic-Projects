package matematica.sistema_linear.solucionador;

import matematica.sistema_linear.SistemaLinear;
import matematica.sistema_linear.SolucaoSistemaLinear;
import matematica.sistema_linear.exception.EntradaException;

public interface SolucionadorSistemaLinear {
	SolucaoSistemaLinear solucionar(SistemaLinear sistema) throws EntradaException;
}
