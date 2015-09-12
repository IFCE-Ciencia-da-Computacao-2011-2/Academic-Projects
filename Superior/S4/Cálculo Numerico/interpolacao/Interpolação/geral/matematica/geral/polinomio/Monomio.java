package matematica.geral.polinomio;

import matematica.geral.Incognita;


public class Monomio implements Comparable<Monomio> {

	private final double coeficiente;
	private final ParteLiteral parteLiteral;


	public static Monomio nulo() {
		return new Monomio(0);
	}

	public static Monomio unitario() {
		return new Monomio(1);
	}

	public Monomio(double coeficiente) {
		this(coeficiente, ParteLiteral.com());
	}

	public Monomio(double coeficiente, ParteLiteral parteLiteral) {
		this.coeficiente = coeficiente;
		this.parteLiteral = parteLiteral;
	}

	public Monomio mais(Monomio monomio) {
		if (this.parteLiteral().equals(monomio.parteLiteral()))
			return new Monomio(
				this.coeficiente() + monomio.coeficiente(),
				this.parteLiteral()
			);

		throw new OperacaoMonomioException("Monômios devem possuir mesma parte literal"); 
	}

	public Monomio menos(Monomio monomio) {
		return mais(monomio.vezes(-1)); 
	}

	public Monomio vezes(double coeficiente) {
		return vezes(new Monomio(coeficiente));
	}

	public Monomio vezes(Incognita z) {
		return vezes(new Monomio(1, ParteLiteral.com(z)));
	}

	public Monomio vezes(Monomio termo) {
		return new Monomio(
			this.coeficiente() * termo.coeficiente(),
			parteLiteral.vezes(termo.parteLiteral())
		);
	}


	public double coeficiente() {
		return coeficiente;
	}

	public ParteLiteral parteLiteral() {
		return parteLiteral;
	}


	public boolean isTermoIndependente() {
		return this.parteLiteral().size() == 0;
	}

	@Override
	public boolean equals(Object obj) {
		Monomio monomio = (Monomio) obj;

		return this.coeficiente() == monomio.coeficiente()
				&& this.parteLiteral().equals(monomio.parteLiteral());
	}

	@Override
	public String toString() {
		StringBuilder retorno = new StringBuilder();
		retorno.append(coeficiente > 0 ? " + " : " - ");
		retorno.append(Math.abs(coeficiente));

		for (Incognita incognita : parteLiteral)
			retorno.append(incognita);

		return retorno.toString();
	}

	@Override
	public int compareTo(Monomio monomio) {
		if (this.parteLiteral().size() != 0 && monomio.parteLiteral().size() == 0)
			return 1;
		else if (this.parteLiteral().size() == 0 && monomio.parteLiteral().size() != 0)
			return -1;

		else
			return this.parteLiteral().compareTo(monomio.parteLiteral());
	}
}