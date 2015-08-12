package interpolacao.newton;

import interpolacao.Coordenadas;

public class Main {
	public static void main(String[] args) {
		Coordenadas coordenadas = new Coordenadas();
		coordenadas.add( 4, -1)
			  	   .add( 1,  0)
			  	   .add(-1,  2);

		Newton newton = new Newton(coordenadas);
		System.out.println(newton);
	}
}
