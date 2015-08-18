package matematica.polinomio;


public class Monomio {

	private double coeficiente;
	private int expoente;

	public static Monomio unitario() {
		return new Monomio(1, 0);
	}

	public Monomio(double coeficiente, int expoente) {
		this.coeficiente = coeficiente;
		this.expoente = expoente;
	}

	public double coeficiente() {
		return coeficiente;
	}

	public int expoente() {
		return expoente;
	}

	public Monomio mais(Monomio termo) {
		if (termo.expoente() != this.expoente)
			throw new RuntimeException("Termos devem ser iguais!");

		return new Monomio(this.coeficiente + termo.coeficiente, expoente);
	}

	public Monomio sobre(Monomio termo) {
		return new Monomio(
			this.coeficiente() / termo.coeficiente(),
			this.expoente() - termo.expoente()
		);
	}

	public Monomio vezes(Monomio termo) {
		return new Monomio(
			this.coeficiente() * termo.coeficiente(),
			this.expoente() + termo.expoente()
		);
	}

	public double calcularResultadoPara(double x) {
		return coeficiente() * (Math.pow(x, expoente()));
	}

	@Override
	public boolean equals(Object obj) {
		Monomio termo = (Monomio) obj;

		return this.coeficiente() == termo.coeficiente()
				&& this.expoente() == termo.expoente();
	}

	public String toString() {
		String retorno = (coeficiente > 0 ? " + " : " - ") + Math.abs(coeficiente);
		if (expoente > 0)
			retorno += "x^" + expoente;

		return retorno;
	}
}