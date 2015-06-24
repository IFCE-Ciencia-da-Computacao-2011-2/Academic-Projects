package ingrediente;

public class IngredienteSanduiche implements Ingrediente {
	private String nome;
	private double valor;

	private IngredienteSanduiche(String nome, double valor) {
		this.nome = nome;
		this.valor = valor;
	}

	@Override
	public String getNome() {
		return nome;
	}

	@Override
	public double getValor() {
		return valor;
	}
	
	@Override
	public String toString() {
		return nome;
	}
	
	/////////////////////////////////////////////////
	
	public static Ingrediente Queijo() {
		return new IngredienteSanduiche("Queijo", 2.00);
	}

	public static Ingrediente Alface() {
		return new IngredienteSanduiche("Alface", 1.50);
	}

	public static Ingrediente Picles() {
		return new IngredienteSanduiche("Picles", 0.50);
	}

	public static Ingrediente Tomate() {
		return new IngredienteSanduiche("Tomate", 9.50);
	}
	
	public static Ingrediente Carne() {
		return new IngredienteSanduiche("Carne", 5.00);
	}
	
	public static Ingrediente Soja() {
		return new IngredienteSanduiche("Soja", 2.50);
	}
}
