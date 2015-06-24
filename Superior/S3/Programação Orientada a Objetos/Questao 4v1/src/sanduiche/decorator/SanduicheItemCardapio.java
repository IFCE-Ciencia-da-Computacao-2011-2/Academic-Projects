package sanduiche.decorator;

import configuracao.Configuracao;
import ingrediente.Ingrediente;
import cardapio.ItemCardapio;

public class SanduicheItemCardapio implements ItemCardapio {

	private SanduicheCompravel sanduiche;

	public SanduicheItemCardapio(SanduicheCompravel sanduiche) {
		this.sanduiche = sanduiche;
	}

	@Override
	public String getTitulo() {
		return this.sanduiche.getNome();
	}

	@Override
	public String getDescricao() {
		String descricao = "Ingredientes: ";

		for (Ingrediente ingrediente : sanduiche.getIngredientes()) {
			descricao += ingrediente.toString() + " ";
		}

		return descricao;
	}

	@Override
	public double getValor() {
		double gasto = sanduiche.custoManufatura() + Configuracao.TAXA;
		return gasto + gasto * Configuracao.LUCRO; 
	}
}
