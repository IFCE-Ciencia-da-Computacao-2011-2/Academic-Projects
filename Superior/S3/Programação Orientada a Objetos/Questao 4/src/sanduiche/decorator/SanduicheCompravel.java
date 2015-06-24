package sanduiche.decorator;

import java.util.Collection;

import sanduiche.Sanduiche;
import ingrediente.Ingrediente;

/**
 * Decorator de sanduíche
 * 
 * O Cliente recebe um sanduíche,
 * A cozinha sabe fazer sanduíche
 * O setor financeiro e o caixa trabalham com sanduiche comprável
 * para poder exibir  
 */
public class SanduicheCompravel implements Sanduiche {

	private Sanduiche sanduiche;

	public SanduicheCompravel(Sanduiche sanduiche) {
		this.sanduiche = sanduiche;
	}

	public double custoManufatura() {
		double custo = 0;
		for (Ingrediente ingrediente : getIngredientes())
			custo += ingrediente.getValor();

		return custo;
	}

	@Override
	public Collection<Ingrediente> getIngredientes() {
		return sanduiche.getIngredientes();
	}

	@Override
	public String getNome() {
		return sanduiche.getNome();
	}
}
