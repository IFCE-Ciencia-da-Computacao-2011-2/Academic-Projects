package interpolacao.newton.tabela_diferenca;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import matematica.geral.coordenadas.Coordenadas;

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
	
	public List<Ordem> ordens() {
		return ordens;
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		// Cabeçalho
		builder.append("N° Ordem |");
		for (int i = 0; i < coordenadas.size(); i++)
			builder.append("___x"+ i +"___|");
		builder.append("\n");

		// Ordens
		for (Ordem ordem : ordens) {			
			builder.append(ordem);
			builder.append("\n");
		}

		return builder.toString();
	}
}
