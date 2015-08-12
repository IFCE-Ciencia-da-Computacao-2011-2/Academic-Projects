package interpolacao.newton;

import interpolacao.Coordenadas;
import interpolacao.newton.tabela_diferenca.TabelaDeDiferencasDivididas;

public class Newton {

	private Coordenadas coordenadas;
	private TabelaDeDiferencasDivididas tabela;

	public Newton(Coordenadas coordenadas) {
		this.coordenadas = coordenadas;
		this.tabela = new TabelaDeDiferencasDivididas(coordenadas);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append(coordenadas.toString());
		builder.append("\n\n");
		builder.append(tabela.toString());

		return builder.toString();
	}
}
