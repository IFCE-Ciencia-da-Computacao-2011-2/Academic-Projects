package grafo;

public class Aresta {
	private Vertice a;
	private Vertice b;
	private int peso;

	public Aresta(Vertice a, Vertice b) {
		this(a, b, 0);
	}
	
	public Aresta(Vertice a, Vertice b, int peso) {
		this.a = a;
		this.b = b;
		this.peso = peso;
	}
	
	@Override
	public String toString() {
		return a.toString() + " <-> " + b.toString() + " ("+peso+")";
	}
}
