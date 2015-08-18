package integracao.numerica;

public class PorTrapezioIntegracao extends IntegracaoNumerica {

	@Override
	protected int divisorBase() {
		return 2;
	}

	protected double somarFsPara(Intervalo intervalo, int numeroDeParticoes, double base) {
		int a = intervalo.a();
		int b = intervalo.b();

		double somaDosFs = 0;

		double xi = a;

		somaDosFs += funcao.f(xi);

		for (int i = 1; i < numeroDeParticoes; i++) {
			xi += base;
			somaDosFs += 2 * funcao.f(xi);
		}

		somaDosFs += funcao.f(b);

		return somaDosFs;
	}
}
