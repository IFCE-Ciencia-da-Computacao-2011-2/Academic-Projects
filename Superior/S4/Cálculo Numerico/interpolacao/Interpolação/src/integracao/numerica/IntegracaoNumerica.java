package integracao.numerica;

public abstract class IntegracaoNumerica implements Integracao {

	protected Funcao funcao;

	public final double calcularPara(Funcao f, Intervalo intervalo, int numeroDeParticoes) {
		this.funcao = f;

		int a = intervalo.a();
		int b = intervalo.b();

		double base = ((b-a) * 1.0)/numeroDeParticoes;

		double somaDosFs = somarFsPara(intervalo, numeroDeParticoes, base);

		return base/divisorBase() * somaDosFs; 
	}

	protected abstract double somarFsPara(Intervalo intervalo, int numeroDeParticoes, double base);
	
	protected abstract int divisorBase();
}
