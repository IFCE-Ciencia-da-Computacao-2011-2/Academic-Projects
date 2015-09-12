package interpolacao.lagrange.polinomios;

import java.util.List;

import matematica.geral.coordenadas.Coordenadas;
import matematica.geral.polinomio.OldTermo;
import matematica.geral.polinomio.OldPolinomio;

public class PolinomioLagrange {

	private List<L> resultados;
	private Coordenadas coordenadas;

	public PolinomioLagrange(List<L> resultados, Coordenadas coordenadas) {
		this.resultados = resultados;
		this.coordenadas = coordenadas;
	}
	
	public OldPolinomio resultado() {
		OldPolinomio resultado = OldPolinomio.nulo();

		int index = 0;
		for (L l : resultados) {
			OldTermo yi = new OldTermo(coordenadas.getCoordenada(index).y(), 0);
			resultado = resultado.mais(l.resultado().multiplicarCom(yi));
			index++;
		}

		return resultado;
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		String PnX = "P"+ (resultados.size()-1) + "(x) = ";

		builder.append(PnX);

		for (int index = 0; index < resultados.size(); index++)
			builder.append(" + Y" + index + "*L"+ index +"(x)");
		builder.append("\n");
		
		builder.append("\n");


		builder.append(PnX);
		int index = 0;
		for (L l : resultados) {
			double yi = coordenadas.getCoordenada(index).y();
			builder.append(" + " + yi + "*("+ l.resultado() +")");
			index++;
		}
		builder.append("\n");


		index = 0;
		builder.append(PnX);
		for (L l : resultados) {
			OldTermo yi = new OldTermo(coordenadas.getCoordenada(index).y(), 0);
			builder.append(l.resultado().multiplicarCom(yi));
			index++;
		}
		builder.append("\n");


		builder.append(PnX);
		builder.append(resultado());

		/*
		builder.append(PnX);
		for (int index = 0; index < resultados.size(); index++) {
			double y = coordenadas.getCoordenada(index).y();
			double l = resultados.get(index).resultado();

			builder.append(" + " + y + " * "+ l);
		}
		builder.append("\n");
		
		builder.append(PnX);
		for (int index = 0; index < resultados.size(); index++) {
			double y = coordenadas.getCoordenada(index).y();
			double l = resultados.get(index).resultado();

			builder.append(" + " + y * l);
		}
		builder.append("\n");

		builder.append(PnX);
		builder.append(resultado());
		*/

		return builder.toString();
	}
}