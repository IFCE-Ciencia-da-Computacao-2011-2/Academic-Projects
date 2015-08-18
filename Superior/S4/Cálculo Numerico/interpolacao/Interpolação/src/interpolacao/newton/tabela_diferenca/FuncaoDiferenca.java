package interpolacao.newton.tabela_diferenca;

import interpolacao.util.coordenadas.Coordenada;

public interface FuncaoDiferenca {
	Coordenada getMaiorX();
	Coordenada getMenorX();
	
	double valor();
}
