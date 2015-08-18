package integracao.numerica;

public class Main {
	public static void main(String[] args) {
		Funcao funcao         = (double x) -> Math.pow(Math.E, x);
		Intervalo intervalo   = new Intervalo(0, 1);
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