package interpolacao.lagrange.polinomios;

import matematica.geral.polinomio.OldTermo;
import matematica.geral.polinomio.OldPolinomio;

public class L {

	private int index;

	private OldPolinomio numerador;
	private double denominador;

	private String concatenaNumerador;
	private String concatenaDenominador;

	public L(int index, OldPolinomio numerador, double denominador, String concatenaNumerador, String concatenaDenominador) {
		this.index = index;

		this.numerador = numerador;
		this.denominador = denominador;
		
		this.concatenaNumerador = concatenaNumerador;
		this.concatenaDenominador = concatenaDenominador;
	}
	
	public OldPolinomio numerador() {
		return numerador;
	}
	
	public double denominador() {
		return denominador;
	}
	
	public OldPolinomio resultado() {
		OldTermo denominador = new OldTermo(denominador(), 0);

		return numerador().dividirCom(denominador);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();

		builder.append(gerarNumerador());

		builder.append("L"+index+"(x)" + " = ");
		builder.append(gerarBarraDivididoPor(concatenaNumerador, concatenaDenominador));
		builder.append("\n");
		
		builder.append(gerarDenominador());
		builder.append("\n");

		builder.append("L"+index+"(x)" + " = ");
		builder.append(resultado());

		return builder.toString();
	}

	private StringBuilder gerarNumerador() {
		return gerar(concatenaNumerador, concatenaDenominador);
	}

	private StringBuilder gerarDenominador() {
		return gerar(concatenaDenominador, concatenaNumerador);
	}

	private StringBuilder gerar(String a, String b) {
		String[] parcelasNumerador   = a.split(" = ");
		String[] parcelasDenominador = b.split(" = ");

		StringBuilder builder = new StringBuilder();
		builder.append("\t");

		for (int i = 0; i < parcelasNumerador.length; i++) {
			builder.append(parcelasNumerador[i]);

			if (parcelasNumerador[i].length() < parcelasDenominador[i].length())
				builder.append(
					espacos(parcelasDenominador[i].length() - parcelasNumerador[i].length())
				);
			builder.append(" = ");
		}

		builder.append("\n");
		return builder;
	}


	private StringBuilder gerarBarraDivididoPor(String concatenaNumerador, String concatenaDenominador) {
		StringBuilder builder = new StringBuilder();

		String[] parcelas = 
			(concatenaNumerador.length() > concatenaDenominador.length()
			? concatenaNumerador : concatenaDenominador).split(" = ");

		for (String parcela : parcelas) {
			builder.append(divididoPor(parcela.length()));
			builder.append(" = ");
		}

		return builder;
	}
	
	private StringBuilder espacos(int tamanho) {
		return repetir(tamanho, ' ');
	}

	private StringBuilder divididoPor(int tamanho) {
		return repetir(tamanho, '_');
	}
	
	private StringBuilder repetir(int tamanho, char caractere) {
		StringBuilder builder = new StringBuilder();
		
		for (int i = 0; i < tamanho; i++)
			builder.append(caractere);
		
		return builder;
	}
}
