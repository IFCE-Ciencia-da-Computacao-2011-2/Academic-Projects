package matematica.sistema_linear;

import matematica.sistema_linear.EquacaoLinear.Coeficiente;

public class SistemaLinearBuilder {
	private SistemaLinear sistemaLinear;

	public SistemaLinearBuilder() {
		this.sistemaLinear = new SistemaLinear();
	}

	public SistemaLinearBuilder addEquacao(double termoIndependente, double ... coeficientes) {
		EquacaoLinearBuilder builder = new EquacaoLinearBuilder();

		for (double coeficiente : coeficientes)
			builder.mais(new Coeficiente(coeficiente));

		builder.igualA(termoIndependente);

		this.sistemaLinear.add(builder.build());

		return this;
	}

	public SistemaLinear criar() {
		return this.sistemaLinear;
	}
}
