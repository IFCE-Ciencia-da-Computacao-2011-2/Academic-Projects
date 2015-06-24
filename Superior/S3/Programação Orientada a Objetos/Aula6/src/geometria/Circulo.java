package geometria;

public class Circulo implements FormaGeometrica {

	private int raio;

	public Circulo(int raio) {
		this.raio = raio;
	}

	@Override
	public int getTotalDeLados() {
		return (int) Double.POSITIVE_INFINITY;
	}

	@Override
	public int getArea() {
		return (int) (Math.PI * raio*raio);
	}

	@Override
	public int getPerimetro() {
		return (int) (2 * Math.PI * raio);
	}

}
