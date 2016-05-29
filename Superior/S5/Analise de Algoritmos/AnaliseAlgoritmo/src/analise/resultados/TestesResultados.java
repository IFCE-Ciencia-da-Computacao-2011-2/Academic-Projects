package analise.resultados;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class TestesResultados {
	private List<Long> resultados = new ArrayList<>();
	
	public void addResultado(long resultado) {
		this.resultados.add(resultado);
	}
	
	public Collection<Long> getResultados() {
		return resultados;
	}
	
	public Long getMinimo() {
		return Collections.min(resultados);
	}
	
	public Long getMaximo() {
		return Collections.max(resultados);
	}

	public Double getMedia() {
		return getTotal()/(resultados.size()*1.0);
	}
	
	public long getTotal() {
		long total = 0;
		for (Long resultado : resultados)
			total += resultado;
		
		return total;
	}
	
	public int getTotalTestes() {
		return resultados.size();
	}
	
	public long getResultado(int indice) {
		return resultados.get(indice);
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		builder.append("Total de repetições: " + resultados.size() + "\n");
		//builder.append(" - Média: " + getMedia() + "\n");
		//builder.append(" - Mínimo: " + getMinimo() + "\n");
		//builder.append(" - Máximo: " + getMaximo() + "\n");
		//builder.append(" - Total: " + getTotal() + "\n");
		//builder.append(" - Todos: \n");
		for (Long resultado : resultados)
			builder.append(resultado + "\n");
		//builder.append(" --- " + resultados.toString());

		return builder.toString();
	}
}
