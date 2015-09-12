package interpolacao.lagrange;

import interpolacao.Interpolador;
import interpolacao.lagrange.polinomios.L;
import interpolacao.lagrange.polinomios.LCalculador;
import interpolacao.lagrange.polinomios.PolinomioLagrange;

import java.util.ArrayList;
import java.util.List;

import matematica.geral.coordenadas.Coordenadas;

public class LagrangeInterpolador implements Interpolador {

	public LagrangeInterpolador(Coordenadas coordenadas, double xInterpolador) {
		List<L> resultados = calcularLs(coordenadas, xInterpolador);
		PolinomioLagrange polinomioLagrange = new PolinomioLagrange(resultados, coordenadas);

		System.out.println("Metodo de interpolação de Lagrange!");
		System.out.println(coordenadas);
		
		System.out.println();

		for (L l : resultados) {
			System.out.println(l);
			System.out.println("\n");
		}

		System.out.println(polinomioLagrange);
		System.out.println("P"+ (resultados.size()-1) + "(x) = " + polinomioLagrange.resultado().calcularFDeX(xInterpolador));
	}

	private List<L> calcularLs(Coordenadas coordenadas, double xInterpolador) {
		List<L> resultados = new ArrayList<>();

		for (int index=0; index<coordenadas.size(); index++) {
			LCalculador calculador = new LCalculador(index);
			L resultado = calculador.calcularPara(coordenadas, xInterpolador);

			resultados.add(resultado);
		}

		return resultados;
	}
}
