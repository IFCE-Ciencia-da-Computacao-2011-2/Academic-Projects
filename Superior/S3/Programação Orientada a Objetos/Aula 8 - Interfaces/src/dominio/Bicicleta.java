package dominio;

public class Bicicleta extends TransporteTerrestre implements Conduzivel {
	private int numeroRaios;	

	public Bicicleta(int numeroDePassageiros, String tipo, int numeroDeRaios) {
		super("Bicicleta", numeroDePassageiros, tipo);
		this.numeroRaios = numeroDeRaios;
	}

	@Override
	public void estacionar() {
		System.out.println(this.getClass().getSimpleName() + " - Freiar");
		System.out.println(this.getClass().getSimpleName() + " - Colocar na calçada");
	}

	@Override
	public void curvar(int angulo) {
		System.out.println(this.getClass().getSimpleName() + " vai curvar " + angulo + "°!");
	}
	
	public void pedalar() {
		System.out.println(this.getClass().getSimpleName() + " - pedalar");
	}
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nNúmero de raios: " + numeroRaios;
		
		return retorno;
	}
}
