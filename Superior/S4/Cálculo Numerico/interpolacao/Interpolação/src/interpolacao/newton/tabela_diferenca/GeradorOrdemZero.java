package interpolacao.newton.tabela_diferenca;

import java.util.ArrayList;
import java.util.List;

import interpolacao.util.coordenadas.Coordenada;
import interpolacao.util.coordenadas.Coordenadas;

class GeradorOrdemZero {
	static Ordem gerarPara(Coordenadas coordenadas) {
		List<FuncaoDiferenca> funcoes = new ArrayList<>();

		for (Coordenada coordenada : coordenadas)
			funcoes.add(new FuncaoDiferencaBase(coordenada));

		return new Ordem(funcoes);
	}
}
