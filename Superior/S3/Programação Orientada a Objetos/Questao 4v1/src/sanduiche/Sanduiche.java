package sanduiche;

import ingrediente.Ingrediente;

import java.util.Collection;

public interface Sanduiche {
	String getNome();
	Collection<Ingrediente> getIngredientes();	
}
