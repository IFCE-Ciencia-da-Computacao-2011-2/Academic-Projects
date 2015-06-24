package dominio;

public class Aviao extends TransporteAereo implements Motorizado, Conduzivel {

	private int numeroMotores;
	
	private boolean motorLigado = false;

	private int litrosNoTanque = 0;

	public Aviao(int numeroDePassageiros, int numeroDeMotores) {
		super("Avião", numeroDePassageiros);
		this.numeroMotores = numeroDeMotores;
		this.motorLigado = false;
		this.litrosNoTanque = 0;
	}
	
	@Override
	public void curvar(int angulo) {
		curvar((float) angulo);
	}
	
	public void curvar(float angulo) {
		System.out.println(this.getClass().getSimpleName() + " vai curvar " + angulo + "°!");
	}
	
	@Override
	public void abastecer(int litros) {
		litrosNoTanque += litros;
	}

	@Override
	public void ligarMotor() {
		motorLigado = !(litrosNoTanque == 0);		
	}
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nNúmero de motores: " + numeroMotores;
		retorno += "\nLitros no tanque: " + motorLigado;
		retorno += "\nEstá ligado? " + motorLigado;

		return retorno;
	}
}