package interpolacao.sistemaLinear.sistemaLinear;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class EquacaoLinear implements Iterable<EquacaoLinear.Termo> {
	private List<Termo> termos = new ArrayList<>();
	private double termoIndependente;

	public EquacaoLinear add(Termo termo) {
		this.termos.add(termo);

		return this;
	}

	public Termo termo(int index) {
		return termos.get(index);
	}

	public double getTermoIndependente() {
		return termoIndependente;
	}

	public void setTermoIndependente(double termo) {
		this.termoIndependente = termo;
	}


	public EquacaoLinear somarCom(EquacaoLinear equacao) {
		if (equacao.termos.size() != this.termos.size())
			throw new RuntimeException("Equações devem possuir o mesmo tamanho");

		EquacaoLinear resultado = new EquacaoLinear();

		for (int i = 0; i < termos.size(); i++)
			resultado.add(this.termo(i).somarCom(equacao.termo(i)));
		
		resultado.setTermoIndependente(this.getTermoIndependente() + equacao.getTermoIndependente());

		return resultado;
	}

	public EquacaoLinear subtrairCom(EquacaoLinear equacao) {
		if (equacao.termos.size() != this.termos.size())
			throw new RuntimeException("Equações devem possuir o mesmo tamanho");

		EquacaoLinear resultado = new EquacaoLinear();

		for (int i = 0; i < termos.size(); i++)
			resultado.add(this.termo(i).subtrairCom(equacao.termo(i)));

		resultado.setTermoIndependente(this.getTermoIndependente() - equacao.getTermoIndependente());

		return resultado;
	}

	public EquacaoLinear multiplicarPor(double multiplicador) {
		EquacaoLinear resultado = new EquacaoLinear();

		for (Termo termo : termos)
			resultado.add(termo.multiplicarPor(multiplicador));

		resultado.setTermoIndependente(this.getTermoIndependente() * multiplicador);

		return resultado;
	}

	@Override
	public Iterator<EquacaoLinear.Termo> iterator() {
		return termos.iterator();
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		int i = 0;
		for (Termo termo : termos) {
			String incognita = "a" + i;
			builder.append(termo.toString(incognita));

			i++;
		}

		builder.append(" = ");
		builder.append(getTermoIndependente());

		return builder.toString();
	}
	
	public int size() {
		return this.termos.size();
	}
	
	@Override
	public boolean equals(Object obj) {
		EquacaoLinear equacao = (EquacaoLinear) obj;

		if (this.getTermoIndependente() != equacao.getTermoIndependente())
			return false;

		if (equacao.termos.size() != this.termos.size())
			return false;
		
		for (int i = 0; i < equacao.size(); i++)
			if (!equacao.termo(i).equals(this.termo(i)))
				return false;

		return true;
	}
	
	public static class Termo {
		private double coeficiente;

		public Termo(double coeficiente) {
			this.coeficiente = coeficiente;
		}
		
		public Termo somarCom(Termo termo) {
			return new Termo(this.coeficiente() + termo.coeficiente());
		}

		/**
		 * @return this - termo
		 */
		public Termo subtrairCom(Termo termo) {
			return new Termo(this.coeficiente() - termo.coeficiente());
		}

		public Termo multiplicarPor(double coeficiente) {
			return new Termo(this.coeficiente() * coeficiente);
		}
		
		public String toString(String incognita) {
			return " " + (coeficiente() > 0 ? '+' : '-') + " " + Math.abs(coeficiente()) + incognita;
		}
		
		public double coeficiente() {
			return coeficiente;
		}

		@Override
		public boolean equals(Object obj) {
			return coeficiente() == ((Termo) obj).coeficiente();
		}
	}
}
