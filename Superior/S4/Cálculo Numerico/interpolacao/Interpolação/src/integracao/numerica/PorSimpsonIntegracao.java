package integracao.numerica;

public class PorSimpsonIntegracao extends IntegracaoNumerica {

	@Override
	protected int divisorBase() {
		return 3;
	}

	protected double somarFsPara(Intervalo intervalo, int numeroDeParticoes, double base) {
		int a = intervalo.a();
		int b = intervalo.b();

		double somaDosFs = 0;

		double xi = a;

		somaDosFs += funcao.f(xi);

		for (int i = 1; i < numeroDeParticoes; i++) {
			xi += base;

			boolean isImpar = i % 2 != 0; 
			int fator = isImpar ? 4 : 2;

			somaDosFs += fator * funcao.f(xi);
		}

		somaDosFs += funcao.f(b);

		return somaDosFs;
	}
}
