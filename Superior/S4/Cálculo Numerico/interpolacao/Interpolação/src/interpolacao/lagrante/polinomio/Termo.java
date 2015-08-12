package interpolacao.lagrante.polinomio;

public class Termo {

	private double coeficiente;
	private int expoente;

	public Termo(double coeficiente, int expoente) {
		this.coeficiente = coeficiente;
		this.expoente = expoente;
	}

	public double getCoeficiente() {
		return coeficiente;
	}

	public int getExpoente() {
		return expoente;
	}

	public Termo somarCom(Termo termo) {
		if (termo.getExpoente() != this.expoente)
			throw new RuntimeException("Termos devem ser iguais!");

		return new Termo(this.coeficiente + termo.coeficiente, expoente);
	}

	public Termo multiplicarCom(Termo termo) {
		return new Termo(
			this.getCoeficiente() * termo.getCoeficiente(),
			this.getExpoente() * termo.getExpoente()
		);
	}

	public String toString() {
		return coeficiente + "x^" + expoente;
	}

	@Override
	public boolean equals(Object obj) {
		Termo termo = (Termo) obj;

		return this.getCoeficiente() == termo.getCoeficiente()
				&& this.getExpoente() == termo.getExpoente();
	}
}