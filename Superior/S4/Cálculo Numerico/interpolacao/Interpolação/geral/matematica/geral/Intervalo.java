package matematica.geral;

public class Intervalo {
	private final int a;
	private final int b;
	
	public Intervalo(int a, int b) {
		this.a = a;
		this.b = b;
	}
	
	public int inicio() {
		return a;
	}

	public int fim() {
		return b;
	}
}