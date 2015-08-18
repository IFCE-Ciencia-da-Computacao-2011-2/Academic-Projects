package integracao.numerica;

public class Intervalo {
	private final int a;
	private final int b;
	
	public Intervalo(int a, int b) {
		this.a = a;
		this.b = b;
	}
	
	public int a() {
		return a;
	}

	public int b() {
		return b;
	}
}