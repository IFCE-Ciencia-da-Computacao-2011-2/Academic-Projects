package matematica.geral;


public class Incognita implements Comparable<Incognita> {
	private char representacao;
	private double expoente;

	public Incognita(char representacao) {
		this(representacao, 1);
	}

	public Incognita(char representacao, double expoente) {
		this.representacao = representacao;
		this.expoente = expoente;
	}

	public char representacao() {
		return representacao;
	}

	public double expoente() {
		return expoente;
	}
	
	
	public Incognita vezes(Incognita incognita) {
		if (!this.isEquivalent(incognita))
			throw new RuntimeException("Inc�gnitas devem possuir mesma representa��o! Para multiplicar inc�gnitas distintas, multiplique Mon�mios");

		double expoente = this.expoente() + incognita.expoente();
		return new Incognita(representacao(), expoente);
	}

	/**
	 * @return Seu expoente � 0?
	 */
	public boolean isUnitaria() {
		return this.expoente() == 0;
	}
	
	/**
	 * @return this possui a mesma representa��o de @param inc�gnita
	 */
	public boolean isEquivalent(Incognita incognita) {
		return this.representacao() == incognita.representacao();
	}

	@Override
	public boolean equals(Object obj) {
		Incognita incognita = (Incognita) obj;

		return this.isEquivalent(incognita)
			&& this.expoente() == incognita.expoente();
	}

	@Override
	public int hashCode() {
		return super.hashCode();
	}

	@Override
	public String toString() {
		return representacao + "^" + expoente;
	}

	@Override
	public int compareTo(Incognita incognita) {
		return Character.compare(this.representacao(), incognita.representacao());
	}
}