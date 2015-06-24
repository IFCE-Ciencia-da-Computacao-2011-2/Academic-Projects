package dominio;

public class Carro extends TransporteTerrestre implements Motorizado, Conduzivel {
	
	private int numeroCilindrada;

	public Carro(int numeroDePassageiros, String tipo, int numeroDeCilindradas) {
		super("Carro", numeroDePassageiros, tipo);
		this.numeroCilindrada = numeroDeCilindradas;
	}

	@Override
	public void estacionar() {
		System.out.println(this.getClass().getSimpleName() + " - Desacelerar");
		System.out.println(this.getClass().getSimpleName() + " - Desligar Motor");
	}

	@Override
	public void ligarMotor() {
		System.out.println(this.getClass().getSimpleName() + " - Motor ligado!");		
	}

	@Override
	public void abastecer(int litros) {
		System.out.println(this.getClass().getSimpleName() + " - Abastecido " + litros + " litros");
	}

	@Override
	public void curvar(int angulo) {
		System.out.println(this.getClass().getSimpleName() + " vai curvar " + angulo + "°!");
	}
	
	@Override
	public String toString() {
		String retorno = super.toString();
		retorno += "\nNúmero de cilindradas: " + numeroCilindrada;
		
		return retorno;
	}
}
