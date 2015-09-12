package interpolacao.newton;

import interpolacao.newton.tabela_diferenca.Ordem;
import interpolacao.newton.tabela_diferenca.TabelaDeDiferencasDivididas;

import java.util.ArrayList;
import java.util.List;

import utilitarios.StringBuilderLn;
import matematica.geral.coordenadas.Coordenadas;

class DiferencasDivididasImportantes {
	private List<Double> importantes;
	private Coordenadas coordenadas;

	public DiferencasDivididasImportantes(TabelaDeDiferencasDivididas tabela, Coordenadas coordenadas) {
		this.coordenadas = coordenadas;

		this.importantes = new ArrayList<>();
		for (Ordem ordem : tabela.ordens())
			importantes.add(ordem.funcoes().get(0).valor());
	}
	
	public List<Double> get() {
		return importantes;
	}

	@Override
	public String toString() {
		StringBuilderLn builder = new StringBuilderLn();

		for (int i = 0; i < coordenadas.size(); i++) {
			builder.append("f[");

			for (int j = 0; j < i+1; j++)
				builder.append("x"+j+",");

			builder.append("] = ");
			builder.appendLn(importantes.get(i));
		}

		return builder.toString();
	}
}