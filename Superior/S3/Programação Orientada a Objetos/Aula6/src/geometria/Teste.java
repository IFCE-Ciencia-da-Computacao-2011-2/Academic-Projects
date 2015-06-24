package geometria;

public class Teste {
	public static void main(String[] args) {
		Quadrado quadrado = new Quadrado(5);
		imprimir(quadrado);
		
		Retangulo retangulo = new Retangulo(3, 6);
		imprimir(retangulo);
		
		Circulo circulo = new Circulo(3);
		imprimir(circulo);
	}

	public static void imprimir(FormaGeometrica forma) {
		System.out.println(forma.getClass().getCanonicalName());
		System.out.println("Lados: " + forma.getTotalDeLados());
		System.out.println("Área: " + forma.getArea());
		System.out.println("Perímetro: " + forma.getPerimetro());
	}
}
