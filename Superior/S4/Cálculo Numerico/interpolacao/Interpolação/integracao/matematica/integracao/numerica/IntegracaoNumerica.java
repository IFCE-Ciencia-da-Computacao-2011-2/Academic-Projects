package matematica.integracao.numerica;

import matematica.geral.Intervalo;
import matematica.integracao.Funcao;
import matematica.integracao.Integracao;

public abstract class IntegracaoNumerica implements Integracao {

	protected Funcao funcao;

	public final double calcularPara(Funcao f, Intervalo intervalo, int numeroDeParticoes) {
		this.funcao = f;

		int a = intervalo.inicio();
		int b = intervalo.fim();

		double base = ((b-a) * 1.0)/numeroDeParticoes;

		double somaDosFs = somarFsPara(intervalo, numeroDeParticoes, base);

		return base/divisorBase() * somaDosFs; 
	}

	protected abstract double somarFsPara(Intervalo intervalo, int numeroDeParticoes, double base);
	
	protected abstract int divisorBase();
}
