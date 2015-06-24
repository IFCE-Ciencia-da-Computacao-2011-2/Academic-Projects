package sanduiche;

import ingrediente.Ingrediente;
import ingrediente.IngredienteSanduiche;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class SanduicheFactory {
	private SanduicheFactory() {}
	
	public static Sanduiche XTudo() {
		return new SanduicheImpl(
			"XTudo",
			ingredientes(
				IngredienteSanduiche.Carne(),
				IngredienteSanduiche.Queijo(),
				IngredienteSanduiche.Alface(),
				IngredienteSanduiche.Tomate()
			)
		);
	}

	public static Sanduiche Vegan() {
		return new SanduicheImpl(
			"Vegan",
			ingredientes(
				IngredienteSanduiche.Queijo(),
				IngredienteSanduiche.Alface(),
				IngredienteSanduiche.Tomate(),
				IngredienteSanduiche.Picles(),
				IngredienteSanduiche.Soja()
			)
		);
	}
	
	/**
	 * Empacota os ingredientes em uma coleção
	 */
	private static Collection<Ingrediente> ingredientes(Ingrediente ... ingredientes) {
		List<Ingrediente> retorno = new ArrayList<>();
		
		for (Ingrediente ingrediente : ingredientes)
			retorno.add(ingrediente);
		
		return retorno;
	}
}
