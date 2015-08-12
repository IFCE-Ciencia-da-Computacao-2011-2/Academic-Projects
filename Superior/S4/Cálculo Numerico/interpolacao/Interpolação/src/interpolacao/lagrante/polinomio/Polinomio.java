package interpolacao.lagrante.polinomio;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Polinomio {

	private List<Termo> termos;

	public Polinomio() {
		termos = new ArrayList<>();
	}

	public Polinomio somarCom(Polinomio polinomio) {
		Polinomio resultado = new Polinomio();

		for (Termo termo : this.getTermos())
			resultado.add(termo);

		for (Termo termo : polinomio.getTermos())
			resultado.add(termo);

		return resultado;
	}

	public Polinomio add(Termo termo) {
		Termo termoJaComputado = getTermoComMesmoExpoenteDo(termo);

		Termo resultado = termoJaComputado.somarCom(termo);

		this.termos.remove(termoJaComputado);
		this.termos.add(resultado);
		
		return this;
	}

	public Termo getTermoComMesmoExpoenteDo(Termo termo) {
		for (Termo t : termos)
			if (t.getExpoente() == termo.getExpoente())
				return t;

		return new Termo(0, termo.getExpoente());
	}


	protected List<Termo> getTermos() {
		return termos;
	}

	@Override
	public boolean equals(Object obj) {
		Polinomio polinomio = (Polinomio) obj;
		
		for (Termo termo : termos) {
			Termo equivalente = polinomio.getTermoComMesmoExpoenteDo(termo);
			if (termo.equals(equivalente))
				continue;

			return false;
		}

		return this.getTermos().size() == polinomio.getTermos().size();
	}

	public String toString() {
		List<Termo> termosOrdenados = sort(getTermos());

		StringBuilder builder = new StringBuilder();
		for (Termo termo : termosOrdenados)
			builder.append(" " + termo);
		
		return builder.toString();
	}
	
	private List<Termo> sort(List<Termo> termos) {
		List<Termo> termosOrdenados = new ArrayList<>();

		Comparator<Termo> byExpoente = (t1, t2) -> Integer.compare(t2.getExpoente(), t1.getExpoente());

	    termos.stream()
	    	  .sorted(byExpoente)
	          .forEach(termo -> termosOrdenados.add(termo));
	    
	    return termosOrdenados;
	}

	public Polinomio multiplicarCom(Polinomio polinomio) {
		Polinomio resultado = new Polinomio();

		for (Termo termo : this.getTermos()) {
			Polinomio produto = polinomio.multiplicarCom(termo);

			resultado = resultado.somarCom(produto);
		}

		return resultado;
	}

	public Polinomio multiplicarCom(Termo termo) {
		Polinomio resultado = new Polinomio();
		
		for (Termo t : termos)
			resultado.add(t.multiplicarCom(termo));

		return resultado;
	}
}
