package interpolacao.newton;

import java.util.ArrayList;
import java.util.List;

import matematica.geral.coordenadas.Coordenadas;
import matematica.geral.polinomio.OldTermo;
import matematica.geral.polinomio.OldPolinomio;

class GerarPolinomioDeNewton {
	public static OldPolinomio gerar(DiferencasDivididasImportantes diferencasImportantes, Coordenadas coordenadas) {
		OldPolinomio polinomio = OldPolinomio.nulo();

		for (int i = 0; i < coordenadas.size(); i++) {
			// (X - X0) * ... * (X - Xi))
			OldPolinomio resultado = gerarTermoPolinomioNewton(i, coordenadas);

			// pegar f[X0, ..., Xi] correspondente
			double diferencaDividida = diferencasImportantes.get().get(i);
			OldTermo termoDiferencaDividida = transformarEmTermo(diferencaDividida);

			// f[X0, ..., Xi] * (X - X0) * ... * (X - Xi))			
			resultado = resultado.multiplicarCom(termoDiferencaDividida);

			// Adicionando termos ao polinômio de newton
			polinomio = polinomio.mais(resultado);
		}

		return polinomio;
	}

	/**
	 * @return coeficiente * x^0
	 */
	private static OldTermo transformarEmTermo(double coeficiente) {
		return new OldTermo(coeficiente, 0);
	}
	
	/**
	 * @return (X - X0) * ... * (X - XindiceTermo)), para indiceTermo > 1
	 *         ou 1 * x^0 = 1, para indiceTermo == 0 
	 */
	private static OldPolinomio gerarTermoPolinomioNewton(int indiceDoTermo, Coordenadas coordenadas) {
		List<OldPolinomio> polinomios = new ArrayList<>();

		for (int j = 0; j < indiceDoTermo; j++) {
			double coeficiente = coordenadas.getCoordenada(j).x();

			// Para gerar xj + x
			OldPolinomio polinomio = OldPolinomio.nulo();
			polinomio.add(transformarEmTermo(-coeficiente)) //xj
					 .add(new OldTermo(1, 1)); // x

			polinomios.add(polinomio);
		}


		OldPolinomio resultado = OldPolinomio.unitario();

		for (OldPolinomio polinomio : polinomios)
			resultado = resultado.vezes(polinomio);

		return resultado;
	}
}
