package interpolacao.sistemaLinear.sistemaLinear;

import java.util.List;

import interpolacao.util.Mat;
import interpolacao.util.StringBuilderLn;

public class ResolvedorSistemaLinearPorTriangulacao implements ResolvedorSistemaLinear {
	
	private StringBuilderLn builder = new StringBuilderLn();
	
	@Override
	public SolucaoSistemaLinear resolver(SistemaLinear sistema) {
		if (sistema.equacoes().size() != sistema.equacoes().get(0).size())
			throw new RuntimeException("Número de equações deve ser igual ao de incógnitas");

		builder.appendLn("Original");
		builder.appendLn(sistema);
		builder.appendLn();

		zerarColunas(sistema);
		
		SolucaoSistemaLinear solucao = gerarResultado(sistema);

		builder.appendLn("Solução");
		builder.appendLn(solucao);

		return solucao;
	}

	private void zerarColunas(SistemaLinear sistema) {
		for (int linhaBase = 0; linhaBase < sistema.equacoes().size() - 1; linhaBase++) {
			for (int linhaASerAfetada = linhaBase+1; linhaASerAfetada < sistema.size(); linhaASerAfetada++) {
				int coluna = linhaBase;

				EquacaoLinear equacaoComColunaZerada = zerarColunaDaLinha(sistema.equacoes(), coluna, linhaASerAfetada, linhaBase);
				sistema.equacoes().set(linhaASerAfetada, equacaoComColunaZerada);

				builder.appendLn(sistema);
			}
		}

		for (int linhaBase = sistema.equacoes().size()-1; linhaBase > 0; linhaBase--) {
			for (int linhaASerAfetada = linhaBase-1; linhaASerAfetada >= 0; linhaASerAfetada--) {
				int coluna = linhaBase;

				EquacaoLinear equacaoComColunaZerada = zerarColunaDaLinha(sistema.equacoes(), coluna, linhaASerAfetada, linhaBase);
				sistema.equacoes().set(linhaASerAfetada, equacaoComColunaZerada);

				builder.appendLn(sistema);
			}
		}
	}

	private EquacaoLinear zerarColunaDaLinha(List<EquacaoLinear> equacoes, int coluna, int linha, int linhaBase) {
		EquacaoLinear equacao = equacoes.get(linha);
		EquacaoLinear base    = equacoes.get(linhaBase);

		double a1 = equacao.termo(coluna).coeficiente();
		double a2 = base.termo(coluna).coeficiente();

		double mmc = Mat.mmc(a1, a2);

		builder.appendLn("L" + linha + " <- " + "L" + linha + " * " + mmc/a1 + " - L" + linhaBase + " * " + mmc/a2);
		
		return equacao.multiplicarPor(mmc / a1)
					  .subtrairCom(base.multiplicarPor(mmc / a2));
	}
	
	private SolucaoSistemaLinear gerarResultado(SistemaLinear sistema) {
		SolucaoSistemaLinear solucao = new SolucaoSistemaLinear(this.toString());

		int i = 0;
		for (EquacaoLinear equacao : sistema) {
			double coeficiente = equacao.termo(i).coeficiente();
			double termoIndependente = equacao.getTermoIndependente();

			solucao.addValorDaIncongnita(termoIndependente / coeficiente);
			i++;
		}

		return solucao;
	}
	
	@Override
	public String toString() {
		return builder.toString();
	}
}
