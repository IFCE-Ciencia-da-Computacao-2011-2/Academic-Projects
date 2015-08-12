package interpolacao.newton.tabela_diferenca;

import interpolacao.Coordenada;

interface FuncaoDiferenca {
	Coordenada getMaiorX();
	Coordenada getMenorX();
	
	double valor();
}
