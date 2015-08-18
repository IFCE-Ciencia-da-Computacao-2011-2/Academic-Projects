package interpolacao.newton;

import java.util.ArrayList;
import java.util.List;

import matematica.polinomio.Polinomio;
import matematica.polinomio.Monomio;
import interpolacao.util.coordenadas.Coordenadas;

public class GerarPolinomioDeNewton {
	public static Polinomio gerar(DiferencasDivididasImportantes diferencasImportantes, Coordenadas coordenadas) {
		Polinomio polinomio = Polinomio.nulo();

		for (int i = 0; i < coordenadas.size(); i++) {
			// (X - X0) * ... * (X - Xi))
			Polinomio resultado = gerarTermoPolinomioNewton(i, coordenadas);

			// pegar f[X0, ..., Xi] correspondente
			double diferencaDividida = diferencasImportantes.get().get(i);
			Monomio termoDiferencaDividida = transformarEmTermo(diferencaDividida);

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
	private static Monomio transformarEmTermo(double coeficiente) {
		return new Monomio(coeficiente, 0);
	}
	
	/**
	 * @return (X - X0) * ... * (X - XindiceTermo)), para indiceTermo > 1
	 *         ou 1 * x^0 = 1, para indiceTermo == 0 
	 */
	private static Polinomio gerarTermoPolinomioNewton(int indiceDoTermo, Coordenadas coordenadas) {
		List<Polinomio> polinomios = new ArrayList<>();

		for (int j = 0; j < indiceDoTermo; j++) {
			double coeficiente = coordenadas.getCoordenada(j).x();

			// Para gerar xj + x
			Polinomio polinomio = Polinomio.nulo();
			polinomio.add(transformarEmTermo(-coeficiente)) //xj
					 .add(new Monomio(1, 1)); // x

			polinomios.add(polinomio);
		}


		Polinomio resultado = Polinomio.unitario();

		for (Polinomio polinomio : polinomios)
			resultado = resultado.vezes(polinomio);

		return resultado;
	}
}
