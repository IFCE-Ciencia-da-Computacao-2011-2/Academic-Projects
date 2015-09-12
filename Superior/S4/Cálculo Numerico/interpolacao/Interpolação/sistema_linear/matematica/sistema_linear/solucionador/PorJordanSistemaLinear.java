package matematica.sistema_linear.solucionador;

import java.util.List;

import utilitarios.StringBuilderLn;
import matematica.geral.Util;
import matematica.sistema_linear.EquacaoLinear;
import matematica.sistema_linear.SistemaLinear;
import matematica.sistema_linear.SolucaoSistemaLinear;
import matematica.sistema_linear.exception.EntradaException;

public class PorJordanSistemaLinear implements SolucionadorSistemaLinear {
	
	private StringBuilderLn builder = new StringBuilderLn();

	@Override
	public SolucaoSistemaLinear solucionar(SistemaLinear sistema) throws EntradaException {
		if (sistema.equacoes().size() != sistema.equacoes().get(0).size() - 1)
			throw new EntradaException("Número de equações deve ser igual ao de incógnitas");

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

		double a1 = equacao.termos().get(coluna).coeficiente();
		double a2 = base.termos().get(coluna).coeficiente();

		double mmc = Util.mmc(a1, a2);

		builder.appendLn("L" + linha + " <- " + "L" + linha + " * " + mmc/a1 + " - L" + linhaBase + " * " + mmc/a2);
		
		return equacao.vezes(mmc / a1)
					  .menos(base.vezes(mmc / a2));
	}
	
	private SolucaoSistemaLinear gerarResultado(SistemaLinear sistema) {
		SolucaoSistemaLinear solucao = new SolucaoSistemaLinear(this.toString());

		int i = 0;
		for (EquacaoLinear equacao : sistema) {
			double coeficiente = equacao.termos().get(i).coeficiente();
			double termoIndependente = equacao.termoIndependente();

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
