package matematica.sistema_linear;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SistemaLinear implements Iterable<EquacaoLinear> {
	private List<EquacaoLinear> equacoes = new ArrayList<>();

	public SistemaLinear add(EquacaoLinear equacao) {
		this.equacoes.add(equacao);

		return this;
	}

	public List<EquacaoLinear> equacoes() {
		return equacoes;
	}
	
	public int size() {
		return this.equacoes.size();
	}

	@Override
	public Iterator<EquacaoLinear> iterator() {
		return equacoes().iterator();
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		for (EquacaoLinear equacaoLinear : equacoes)
			builder.append(equacaoLinear.toString() + "\n");

		return builder.toString();
	}
}
