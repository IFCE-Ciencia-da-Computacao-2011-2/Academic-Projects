package interpolacao.newton.tabela_diferenca;

import matematica.geral.coordenadas.Coordenada;

class FuncaoDiferencaFilha implements FuncaoDiferenca {

	private FuncaoDiferenca paiMenor;
	private FuncaoDiferenca paiMaior;

	public FuncaoDiferencaFilha(FuncaoDiferenca paiMenor, FuncaoDiferenca paiMaior) {
		this.paiMenor = paiMenor;
		this.paiMaior = paiMaior;
	}

	@Override
	public Coordenada getMaiorX() {
		return paiMaior.getMaiorX();
	}

	@Override
	public Coordenada getMenorX() {
		return paiMenor.getMenorX();
	}

	public double valor() {
		return (this.paiMaior.valor() - paiMenor.valor()) / (this.getMaiorX().x() - this.getMenorX().x());
	}
}
