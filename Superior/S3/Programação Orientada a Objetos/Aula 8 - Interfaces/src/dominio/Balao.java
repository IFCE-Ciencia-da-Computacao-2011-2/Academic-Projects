package dominio;

public class Balao extends TransporteAereo {
	private int pesoLargada;
	private float temperaturaAr;

	public Balao(int numeroDePassageiros, int pesoDaLargada) {
		super("Balão", numeroDePassageiros);
		pesoLargada = pesoDaLargada;
		temperaturaAr = 0;
	}
	
	public void largarPeso(float peso) {
		pesoLargada -= peso;
	}
	
	public void aquecerAr(float temperatura) {
		temperaturaAr += temperatura;
	}
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nPeso da largada: " + pesoLargada;
		retorno += "\nTemperatura do Ar dentro do balão: " + temperaturaAr;
		
		return retorno;
	}
}
