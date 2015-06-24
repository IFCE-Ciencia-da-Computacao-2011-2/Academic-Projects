package geometria;

public class Retangulo implements FormaGeometrica {

	private int base;
	private int altura;

	public Retangulo(int base, int altura) {
		this.base = base;
		this.altura = altura;
	}

	@Override
	public int getTotalDeLados() {
		return 4;
	}

	@Override
	public int getArea() {
		return base*altura;
	}

	@Override
	public int getPerimetro() {
		return base*2 + altura*2;
	}
}