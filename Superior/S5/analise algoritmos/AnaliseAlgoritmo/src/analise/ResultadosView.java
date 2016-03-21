package analise;

import java.util.List;
import java.util.Map;

import analise.resultados.ResultadosPorOrdenadores;

public class ResultadosView {
	private Map<String, List<ResultadosPorOrdenadores>> resultados;

	public ResultadosView(Map<String, List<ResultadosPorOrdenadores>> resultados) {
		this.resultados = resultados;
	}
	
	public void imprimir() {
		for (String chave : resultados.keySet()) {
			System.out.println("Caso " + chave);
			for (ResultadosPorOrdenadores res : resultados.get(chave))
				System.out.println(res.getResultadoCSV());
		}
	}
}
