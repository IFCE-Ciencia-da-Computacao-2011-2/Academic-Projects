package matematica.integracao.numerica;

import matematica.geral.Intervalo;
import matematica.integracao.Funcao;
import matematica.integracao.Integracao;

public class Main {
	public static void main(String[] args) {
		Funcao funcao         = (x) -> 1/(x*x);
		Intervalo intervalo   = new Intervalo(1, 7);
		int numeroDeParticoes = 10;

		Integracao integracao;
		double resultado;

		integracao = new PorTrapezioIntegracao();
		resultado = integracao.calcularPara(funcao, intervalo, numeroDeParticoes);
		System.out.println("Trapézio: " + resultado);

		integracao = new PorSimpsonIntegracao();
		resultado = integracao.calcularPara(funcao, intervalo, numeroDeParticoes);
		System.out.println("Simpson: " + resultado);
	}
}