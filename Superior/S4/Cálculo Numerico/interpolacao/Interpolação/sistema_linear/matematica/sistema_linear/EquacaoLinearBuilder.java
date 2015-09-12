package matematica.sistema_linear;

import matematica.geral.Incognita;
import matematica.geral.polinomio.Monomio;
import matematica.geral.polinomio.ParteLiteral;
import matematica.geral.polinomio.Polinomio;
import matematica.sistema_linear.EquacaoLinear.Coeficiente;

public class EquacaoLinearBuilder {

	private Polinomio polinomio = Polinomio.nulo();
	public double termoIndependente;

	public EquacaoLinearBuilder mais(Coeficiente coeficiente) {
		Incognita incognita = new Incognita((char) ('a' + polinomio.size()));

		Monomio monomio = new Monomio(coeficiente.get(), ParteLiteral.com(incognita));
		this.polinomio = polinomio.mais(monomio);

		return this;
	}

	public EquacaoLinearBuilder igualA(double coeficiente) {
		this.termoIndependente = coeficiente;

		return this;
	}

	public EquacaoLinear build() {
		this.polinomio = this.polinomio.menos(new Monomio(termoIndependente));
		EquacaoLinear equacao = new EquacaoLinear(this.polinomio);

		return equacao;
	}
}
