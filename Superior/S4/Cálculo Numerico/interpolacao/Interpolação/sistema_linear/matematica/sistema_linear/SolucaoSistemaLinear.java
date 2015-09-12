package matematica.sistema_linear;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import matematica.sistema_linear.EquacaoLinear.Coeficiente;

public class SolucaoSistemaLinear implements Iterable<Coeficiente> {

	private List<Coeficiente> incognitas = new ArrayList<>();
	
	@Deprecated
	private String passos;

	public SolucaoSistemaLinear() {
		this("");
	}

	public SolucaoSistemaLinear(@Deprecated String passos) {
		this.passos = passos;
	}

	public SolucaoSistemaLinear addValorDaIncongnita(double incognita) {
		incognitas.add(new Coeficiente(incognita));

		return this;
	}
	
	public List<Coeficiente> getIncognitas() {
		return incognitas;
	}
	
	@Override
	public boolean equals(Object obj) {
		SolucaoSistemaLinear solucao = (SolucaoSistemaLinear) obj;

		return this.getIncognitas().equals(solucao.getIncognitas());
	}

	/**
	 * @deprecated Se quiser injetar os passos, criar uma classe que extends
	 * ou que decore SolucaoSistemaLinear para solucionar tal
	 * problema
	 */
	@Deprecated public String getPassos() {
		return passos;
	}

	@Override
	public Iterator<Coeficiente> iterator() {
		return incognitas.iterator();
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		int i = 0;
		for (Coeficiente incognita : this) {
			builder.append("a"+i);
			builder.append(" = ");
			builder.append(incognita);
			builder.append("\n");

			i++;
		}

		return builder.toString();
	}
}
