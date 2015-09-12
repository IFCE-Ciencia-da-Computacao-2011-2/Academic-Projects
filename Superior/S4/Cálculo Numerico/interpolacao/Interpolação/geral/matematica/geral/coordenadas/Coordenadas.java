package matematica.geral.coordenadas;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Coordenadas implements Iterable<Coordenada> {

	private List<Coordenada> coordenadas;

	public Coordenadas() {
		this.coordenadas = new ArrayList<Coordenada>();
	}

	public Coordenadas add(double fDeX, double x) {
		this.coordenadas.add(new Coordenada(x, fDeX));
		return this;
	}

	public Coordenada getCoordenada(int posicao) {
		return coordenadas.get(posicao);
	}
	
	@Override
	public Iterator<Coordenada> iterator() {
		return coordenadas.iterator();
	}
	
	/**
	 * @return Total de coodenadas
	 */
	public int size() {
		return coordenadas.size();
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();

		builder.append(" x   |"); 
		for (Coordenada coordenada : coordenadas)
			builder.append(coordenada.x() + " ");
		builder.append("\n");

		builder.append("f(x) |"); 
		for (Coordenada coordenada : coordenadas)
			builder.append(coordenada.y() + " ");

		return builder.toString();
	}
}
