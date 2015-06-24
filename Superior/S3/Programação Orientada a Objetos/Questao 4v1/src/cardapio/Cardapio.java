package cardapio;

import java.util.ArrayList;
import java.util.List;

public class Cardapio {
	List<ItemCardapio> itens = new ArrayList<>();

	public void add(ItemCardapio item) {
		itens.add(item);
	}
	
	public List<ItemCardapio> getItens() {
		return itens;
	}
	
	@Override
	public String toString() {
		StringBuilder retorno = new StringBuilder();
		for (ItemCardapio item : itens) {
			retorno.append("Item: ");
			retorno.append(item.getTitulo());
			retorno.append("\n");
			retorno.append(item.getDescricao());
			retorno.append("\n");
			retorno.append("R$: ");
			retorno.append(item.getValor());
			retorno.append("\n");
			retorno.append("-----------------------------");
			retorno.append("\n");
		}

		return retorno.toString();
	}
}
