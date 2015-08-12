package interpolacao.newton.tabela_diferenca;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

class Ordem {
	private int ordem;
	private List<FuncaoDiferenca> funcoes;

	public Ordem(List<FuncaoDiferenca> funcoes) {
		this.funcoes = funcoes;
	}

	private Ordem(int numero, List<FuncaoDiferenca> funcoes) {
		this.ordem = numero;
		this.funcoes = funcoes;
	}

	public Optional<Ordem> gerarOrdem() {
		if (isUltimaOrdem()) 
			return Optional.empty();

		List<FuncaoDiferenca> funcoesNovaOrdem = gerarFuncoesDeNovaOrdem();
		Ordem gerada = new Ordem(this.ordem + 1, funcoesNovaOrdem);

		return Optional.of(gerada);
	}

	private List<FuncaoDiferenca> gerarFuncoesDeNovaOrdem() {
		List<FuncaoDiferenca> funcoesNovaOrdem = new ArrayList<>();

		FuncaoDiferencaFilha filha;
		for (int i = 0; i < funcoes.size()-1; i++) {
			FuncaoDiferenca funcaoIPlus1 = funcoes.get(i+1);
			FuncaoDiferenca funcaoI = funcoes.get(i);

			filha = new FuncaoDiferencaFilha(funcaoI, funcaoIPlus1);

			funcoesNovaOrdem.add(filha);
		}
		
		return funcoesNovaOrdem; 
	}

	private boolean isUltimaOrdem() {
		return funcoes.size() == 1;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Ordem: " + this.ordem + " ");
		
		for (FuncaoDiferenca funcao : funcoes)	
			builder.append(funcao.valor() + "     |");

		return builder.toString();
	}
}