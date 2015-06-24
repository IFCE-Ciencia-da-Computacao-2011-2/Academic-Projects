package cardapio;

import sanduiche.Sanduiche;
import sanduiche.decorator.SanduicheCompravel;
import sanduiche.decorator.SanduicheItemCardapio;

public class CardapioBuilder {

	private Cardapio cardapio;

	public CardapioBuilder() {
		this.cardapio = new Cardapio();
	}
	
	public void addSanduiche(Sanduiche sanduiche) {
		SanduicheCompravel compravel = new SanduicheCompravel(sanduiche);
		SanduicheItemCardapio itemCardapio = new SanduicheItemCardapio(compravel);

		cardapio.add(itemCardapio);
	}

	public Cardapio prepare() {
		return cardapio;
	}
}
