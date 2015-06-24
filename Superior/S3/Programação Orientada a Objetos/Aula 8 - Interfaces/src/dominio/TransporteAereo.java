package dominio;

public class TransporteAereo extends Transporte {
	
	private int altitudeAtual;

	public TransporteAereo(String nome, int numeroDePassageiros) {
		super(nome, numeroDePassageiros);
		this.altitudeAtual = 0;
	}

	public void subir(int metros) {
		this.altitudeAtual += metros;
	}
	
	public void descer(int metros) {
		this.altitudeAtual += metros;
		if (altitudeAtual < 0)
			altitudeAtual = 0;
	}
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nAltitude atual: " + altitudeAtual;
		
		return retorno;
	}
}
