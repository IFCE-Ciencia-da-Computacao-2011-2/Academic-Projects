package interpolacao;

import matematica.polinomio.Polinomio;
import matematica.polinomio.Monomio;
import interpolacao.lagrange.Lagrange;
import interpolacao.newton.Newton;
import interpolacao.sistemaLinear.SistemaLinearInterpolador;
import interpolacao.util.coordenadas.Coordenadas;

public class Interpolacao {
	public static void main(String[] args) {
		double xInterpolador = 0.23;

		Coordenadas coordenadas = new Coordenadas();

		coordenadas.add(    -1,   0)
				   .add( 0.125, 0.5)
				   .add(     2,   1);

		listemaLinear(coordenadas, xInterpolador);
		lagrange(coordenadas, xInterpolador);
		newton(coordenadas, xInterpolador);
	}

	private static void listemaLinear(Coordenadas coordenadas, double xInterpolador) {
		System.out.println("====================");
		System.out.println("   Sistema Linear");
		System.out.println("====================");

		SistemaLinearInterpolador interpolador = new SistemaLinearInterpolador(coordenadas, xInterpolador);
		System.out.println(interpolador);
	}

	private static void lagrange(Coordenadas coordenadas, double xInterpolador) {
		System.out.println("====================");
		System.out.println("      Lagrange");
		System.out.println("====================");

		Lagrange lagrange = new Lagrange(coordenadas, xInterpolador);
		//System.out.println(lagrange);
	}

	private static void newton(Coordenadas coordenadas, double xInterpolador) {
		System.out.println("====================");
		System.out.println("        Newton");
		System.out.println("====================");

		Newton newton = new Newton(coordenadas, xInterpolador);
		System.out.println(newton);
	}
}
