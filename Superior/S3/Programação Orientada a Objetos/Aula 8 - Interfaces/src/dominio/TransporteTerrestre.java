package dominio;

public abstract class TransporteTerrestre extends Transporte {

	private String tipo;

	public TransporteTerrestre(String nome, int numeroDePassageiros, String tipo) {
		super(nome, numeroDePassageiros);
		this.tipo = tipo;
	}

	public abstract void estacionar();
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nTipo: " + tipo;
		
		return retorno;
	}
}
