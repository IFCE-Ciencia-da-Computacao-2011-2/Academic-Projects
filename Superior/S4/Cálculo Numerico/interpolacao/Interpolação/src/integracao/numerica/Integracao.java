package integracao.numerica;

public interface Integracao {
	double calcularPara(Funcao f, Intervalo intervalo, int numeroDeParticoes);
}
