package matematica.geral.polinomio;

@Deprecated
public class OldTermo {

	private double coeficiente;
	private int expoente;

	public static OldTermo unitario() {
		return new OldTermo(1, 0);
	}

	public OldTermo(double coeficiente, int expoente) {
		this.coeficiente = coeficiente;
		this.expoente = expoente;
	}

	public double coeficiente() {
		return coeficiente;
	}

	public int expoente() {
		return expoente;
	}

	public OldTermo mais(OldTermo termo) {
		if (termo.expoente() != this.expoente)
			throw new RuntimeException("Termos devem ser iguais!");

		return new OldTermo(this.coeficiente + termo.coeficiente, expoente);
	}

	public OldTermo sobre(OldTermo termo) {
		return new OldTermo(
			this.coeficiente() / termo.coeficiente(),
			this.expoente() - termo.expoente()
		);
	}

	public OldTermo vezes(OldTermo termo) {
		return new OldTermo(
			this.coeficiente() * termo.coeficiente(),
			this.expoente() + termo.expoente()
		);
	}

	public double calcularResultadoPara(double x) {
		return coeficiente() * (Math.pow(x, expoente()));
	}

	@Override
	public boolean equals(Object obj) {
		OldTermo termo = (OldTermo) obj;

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