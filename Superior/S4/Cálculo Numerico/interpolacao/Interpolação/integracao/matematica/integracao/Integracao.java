package matematica.integracao;

import matematica.geral.Intervalo;

public interface Integracao {
	double calcularPara(Funcao f, Intervalo intervalo, int numeroDeParticoes);
}
