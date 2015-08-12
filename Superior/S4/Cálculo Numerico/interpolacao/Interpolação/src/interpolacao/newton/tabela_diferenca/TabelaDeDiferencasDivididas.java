package interpolacao.newton.tabela_diferenca;

import interpolacao.Coordenadas;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

public class TabelaDeDiferencasDivididas {
	private Coordenadas coordenadas;
	private List<Ordem> ordens;

	public TabelaDeDiferencasDivididas(Coordenadas coordenadas) {
		this.coordenadas = coordenadas;

		Ordem ordem0 = GeradorOrdemZero.gerarPara(coordenadas);
		this.ordens = gerarOrdensAPartirDe(ordem0);
	}

	private List<Ordem> gerarOrdensAPartirDe(Ordem ordem0) {
		Optional<Ordem> ordemPonteiro = Optional.of(ordem0);

		List<Ordem> ordens = new LinkedList<>();

		while (ordemPonteiro.isPresent()) {
			ordens.add(ordemPonteiro.get());
			ordemPonteiro = ordemPonteiro.get().gerarOrdem();
		}

		return ordens;
	}
	
	List<Ordem> ordens() {
		return ordens;
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		// Cabe�alho
		for (int i = 0; i < coordenadas.size(); i++)
			builder.append("____x"+ i +"____|");
		builder.append("\n");

		// Ordens
		for (Ordem ordem : ordens) {			
			builder.append(ordem);
			builder.append("\n");
		}

		return builder.toString();
	}
}
