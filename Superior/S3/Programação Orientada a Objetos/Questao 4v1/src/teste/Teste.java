package teste;

import sanduiche.SanduicheFactory;
import cardapio.Cardapio;
import cardapio.CardapioBuilder;

public class Teste {

	public static void main(String[] args) {
		new Teste();
	}

	public Teste() {
		CardapioBuilder builder = new CardapioBuilder();

		builder.addSanduiche(SanduicheFactory.XTudo());
		builder.addSanduiche(SanduicheFactory.Vegan());
		
		Cardapio cardapio = builder.prepare();
		System.out.println(cardapio);
	}
}
