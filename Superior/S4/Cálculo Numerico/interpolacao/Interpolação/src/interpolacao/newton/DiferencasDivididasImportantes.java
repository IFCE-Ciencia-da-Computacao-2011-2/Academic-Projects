package interpolacao.newton;

import interpolacao.newton.tabela_diferenca.Ordem;
import interpolacao.newton.tabela_diferenca.TabelaDeDiferencasDivididas;
import interpolacao.util.StringBuilderLn;
import interpolacao.util.coordenadas.Coordenadas;

import java.util.ArrayList;
import java.util.List;

public class DiferencasDivididasImportantes {
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