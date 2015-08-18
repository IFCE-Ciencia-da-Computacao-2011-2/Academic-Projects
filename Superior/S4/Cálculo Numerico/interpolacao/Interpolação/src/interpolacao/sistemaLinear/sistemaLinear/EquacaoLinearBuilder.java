package interpolacao.sistemaLinear.sistemaLinear;

import interpolacao.sistemaLinear.sistemaLinear.EquacaoLinear.Termo;

public class EquacaoLinearBuilder {
	
	public static EquacaoLinear criar(double termoIndependente, double ... elementos) {
		EquacaoLinear equacao = new EquacaoLinear();

		for (double elemento : elementos)
			equacao.add(new Termo(elemento));

		equacao.setTermoIndependente(termoIndependente);

		return equacao;
	}
}
