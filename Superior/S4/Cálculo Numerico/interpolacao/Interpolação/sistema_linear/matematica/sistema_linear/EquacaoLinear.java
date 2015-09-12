package matematica.sistema_linear;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import matematica.geral.polinomio.Monomio;
import matematica.geral.polinomio.Polinomio;
import matematica.sistema_linear.exception.OperacaoEquacaoLinearException;

/**
 * Equação Linear é um polinômio cujas incógnitas possuem grau um
 */
public class EquacaoLinear implements Iterable<Monomio> {
	private Polinomio polinomio;

	public EquacaoLinear() {
		this(Polinomio.nulo());
	}

	public EquacaoLinear(Polinomio termos) {
		this.polinomio = termos;
	}

	public double termoIndependente() {
		return polinomio.termoIndependente().coeficiente() * -1;
	}

	public EquacaoLinear mais(EquacaoLinear equacao) {
		if (!this.polinomio.isEquivalente(equacao.polinomio))
			throw new OperacaoEquacaoLinearException("Equações devem possuir o mesmo tamanho");

		EquacaoLinear resultado = new EquacaoLinear();

		resultado.polinomio = this.polinomio.mais(equacao.polinomio);
		
		return resultado;
	}

	public EquacaoLinear menos(EquacaoLinear equacao) {
		if (equacao.polinomio.size() != this.polinomio.size())
			throw new OperacaoEquacaoLinearException("Equações devem possuir o mesmo tamanho");

		EquacaoLinear resultado = new EquacaoLinear();

		resultado.polinomio = this.polinomio.menos(equacao.polinomio);

		return resultado;
	}

	public EquacaoLinear vezes(double multiplicador) {
		EquacaoLinear resultado = new EquacaoLinear();

		resultado.polinomio = this.polinomio.vezes(new Monomio(multiplicador));

		return resultado;
	}

	public List<Monomio> termos() {
		List<Monomio> termos = new ArrayList<>();

		for (Monomio termo : polinomio) {
			if (termo.isTermoIndependente())
				continue;

			termos.add(termo);
		}

		return termos;
	}

	@Override
	public Iterator<Monomio> iterator() {
		return polinomio.iterator();
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();

		int i = 0;
		for (Monomio termo : termos()) {
			String incognita = "a" + i;
			builder.append(termo.coeficiente() > 0 ? " + " : " - ");
			builder.append(termo.coeficiente() + incognita);

			i++;
		}

		builder.append(" = ");
		builder.append(termoIndependente());

		return builder.toString();
	}

	/**
	 * @return termos.size() + 1 (do termo independente)
	 */
	public int size() {
		return this.polinomio.size();
	}

	public Polinomio representacaoPolinomial() {
		return polinomio;
	}

	@Override
	public boolean equals(Object obj) {
		EquacaoLinear equacao = (EquacaoLinear) obj;

		return this.polinomio.equals(equacao.polinomio);
	}

	public static class Coeficiente {
		private double coeficiente;

		public Coeficiente(double coeficiente) {
			this.coeficiente = coeficiente;
		}
		
		public double get() {
			return coeficiente;
		}

		@Override
		public boolean equals(Object obj) {
			return get() == ((Coeficiente) obj).get();
		}
		
		@Override
		public String toString() {
			return coeficiente + "";
		}
	}
}
