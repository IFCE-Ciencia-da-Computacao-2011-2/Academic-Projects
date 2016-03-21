package analise.resultados;

import java.util.HashMap;
import java.util.Map;

import analise.algoritmo.Ordenador;

public class ResultadosPorOrdenadores {
	private Map<Ordenador, TestesResultados> dados = new HashMap<>();
	private int totalResultados;
	private String titulo;
	
	public ResultadosPorOrdenadores(String titulo, int totalTestes) {
		this.titulo = titulo;
		this.totalResultados = totalTestes;
	}
	
	public void add(Ordenador ordenador, TestesResultados resultados) {
		dados.put(ordenador, resultados);
	}
	
	public StringBuilder getResultadoCSV() {
		StringBuilder builder = new StringBuilder();
		builder.append(" - ").append(titulo).append('\n');

		builder.append(adicionarTitulo()).append('\n');
		builder.append(adicionarResultados());
		
		return builder;
	}

	private StringBuilder adicionarTitulo() {
		StringBuilder builder = new StringBuilder();

		for (Ordenador ordenador : dados.keySet())
			builder.append(ordenador.getClass().getSimpleName()).append(';');

		return builder;
	}

	private StringBuilder adicionarResultados() {
		StringBuilder builder = new StringBuilder();

		for (int i = 0; i < totalResultados; i++) {
			for (Ordenador ordenador : dados.keySet())
				builder.append(dados.get(ordenador).getResultado(i)).append(';');
			builder.append('\n');
		}
		
		return builder;
	}
}
