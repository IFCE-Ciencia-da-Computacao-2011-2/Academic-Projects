package interpolacao.sistemaLinear.sistemaLinear;

public class SistemaLinearBuilder {
	private SistemaLinear sistemaLinear;

	public SistemaLinearBuilder() {
		this.sistemaLinear = new SistemaLinear();
	}

	public SistemaLinearBuilder addEquacao(double termoIndependente, double ... coeficientes) {
		this.sistemaLinear.add(EquacaoLinearBuilder.criar(termoIndependente, coeficientes));

		return this;
	}

	public SistemaLinear criar() {
		return this.sistemaLinear;
	}
}
