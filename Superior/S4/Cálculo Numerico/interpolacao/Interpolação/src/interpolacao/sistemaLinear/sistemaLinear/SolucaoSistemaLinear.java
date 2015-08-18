package interpolacao.sistemaLinear.sistemaLinear;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SolucaoSistemaLinear implements Iterable<Double> {

	private List<Double> incognitas = new ArrayList<>();
	private String passos;

	public SolucaoSistemaLinear() {
		this("");
	}

	public SolucaoSistemaLinear(String passos) {
		this.passos = passos;
	}

	public SolucaoSistemaLinear addValorDaIncongnita(double incognita) {
		incognitas.add(incognita);

		return this;
	}
	
	public double getValorDaIncongnita(int indice) {
		return incognitas.get(indice);
	}
	
	public int size() {
		return incognitas.size();
	}
	
	@Override
	public boolean equals(Object obj) {
		SolucaoSistemaLinear solucao = (SolucaoSistemaLinear) obj;

		if (this.size() != solucao.size())
			return false;

		for (int i = 0; i < solucao.size(); i++)
			if (this.getValorDaIncongnita(i) != solucao.getValorDaIncongnita(i))
				return false;
		
		return true;
	}

	public String getPassos() {
		return passos;
	}

	@Override
	public Iterator<Double> iterator() {
		return incognitas.iterator();
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		int i = 0;
		for (Double incognita : incognitas) {
			builder.append("a"+i);
			builder.append(" = ");
			builder.append(incognita);
			builder.append("\n");

			i++;
		}

		return builder.toString();
	}
}
