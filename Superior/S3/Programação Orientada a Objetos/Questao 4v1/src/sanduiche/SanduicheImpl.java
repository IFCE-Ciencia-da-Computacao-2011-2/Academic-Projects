package sanduiche;

import ingrediente.Ingrediente;

import java.util.Collection;

class SanduicheImpl implements Sanduiche {

	private String nome;
	private Collection<Ingrediente> ingredientes;

	SanduicheImpl(String nome, Collection<Ingrediente> ingredientes) {
		this.nome = nome;
		this.ingredientes = ingredientes;
	}

	@Override
	public String getNome() {
		return nome;
	}

	@Override
	public Collection<Ingrediente> getIngredientes() {
		return ingredientes;
	}
}
