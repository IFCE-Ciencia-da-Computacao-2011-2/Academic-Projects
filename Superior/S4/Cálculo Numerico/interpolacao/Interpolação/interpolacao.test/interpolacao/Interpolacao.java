package interpolacao;

import interpolacao.lagrange.LagrangeInterpolador;
import interpolacao.newton.NewtonInterpolador;
import interpolacao.sistema_linear.SistemaLinearInterpolador;
import matematica.geral.coordenadas.Coordenadas;
import matematica.sistema_linear.exception.EntradaException;

public class Interpolacao {
	public static void main(String[] args) throws EntradaException {
		double xInterpolador = 0.23;

		Coordenadas coordenadas = new Coordenadas();

		coordenadas.add(    -1,   0)
				   .add( 0.125, 0.5)
				   .add(     2,   1);

		//listemaLinear(coordenadas, xInterpolador);
		lagrange(coordenadas, xInterpolador);
		newton(coordenadas, xInterpolador);
	}

	private static void listemaLinear(Coordenadas coordenadas, double xInterpolador) throws EntradaException {
		System.out.println("====================");
		System.out.println("   Sistema Linear");
		System.out.println("====================");

		Interpolador interpolador = new SistemaLinearInterpolador(coordenadas, xInterpolador);
		System.out.println(interpolador);
	}

	private static void lagrange(Coordenadas coordenadas, double xInterpolador) {
		System.out.println("====================");
		System.out.println("      Lagrange");
		System.out.println("====================");

		Interpolador lagrange = new LagrangeInterpolador(coordenadas, xInterpolador);
		//System.out.println(lagrange);
	}

	private static void newton(Coordenadas coordenadas, double xInterpolador) {
		System.out.println("====================");
		System.out.println("        Newton");
		System.out.println("====================");

		Interpolador newton = new NewtonInterpolador(coordenadas, xInterpolador);
		System.out.println(newton);
	}
}
