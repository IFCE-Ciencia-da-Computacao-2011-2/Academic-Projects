package matematica.polinomio;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Polinomio {

	private List<Monomio> termos;

	private Polinomio() {
		termos = new ArrayList<>();
	}

	public static Polinomio nulo() {
		return new Polinomio();
	}

	public static Polinomio unitario() {
		return Polinomio.nulo().add(Monomio.unitario());
	}

	public Polinomio mais(Polinomio polinomio) {
		Polinomio resultado = Polinomio.nulo();

		for (Monomio termo : this.getTermos())
			resultado.add(termo);

		for (Monomio termo : polinomio.getTermos())
			resultado.add(termo);

		return resultado;
	}

	public Polinomio add(Monomio termo) {
		Monomio termoJaComputado = getTermoComMesmoExpoenteDo(termo);

		Monomio resultado = termoJaComputado.mais(termo);

		this.termos.remove(termoJaComputado);
		this.termos.add(resultado);
		
		return this;
	}

	public Monomio getTermoComMesmoExpoenteDo(Monomio termo) {
		for (Monomio t : termos)
			if (t.expoente() == termo.expoente())
				return t;

		return new Monomio(0, termo.expoente());
	}

	public Polinomio vezes(Polinomio polinomio) {
		Polinomio resultado = new Polinomio();

		for (Monomio termo : this.getTermos()) {
			Polinomio produto = polinomio.multiplicarCom(termo);

			resultado = resultado.mais(produto);
		}

		return resultado;
	}

	public Polinomio multiplicarCom(Monomio termo) {
		Polinomio resultado = new Polinomio();
		
		for (Monomio t : termos)
			resultado.add(t.vezes(termo));

		return resultado;
	}
	
	public Polinomio dividirCom(Monomio termo) {
		Polinomio resultado = new Polinomio();
		
		for (Monomio t : termos)
			resultado.add(t.sobre(termo));

		return resultado;
	}
	
	/**
	 * Sendo o polinomio uma função f(x),
	 * @return resultado para determinado x
	 */
	public double calcularFDeX(double x) {
		double resultado = 0;
		
		for (Monomio termo : termos)
			resultado += termo.calcularResultadoPara(x);

		return resultado;
	}

	protected List<Monomio> getTermos() {
		return termos;
	}

	@Override
	public boolean equals(Object obj) {
		Polinomio polinomio = (Polinomio) obj;
		
		for (Monomio termo : termos) {
			Monomio equivalente = polinomio.getTermoComMesmoExpoenteDo(termo);
			if (termo.equals(equivalente))
				continue;

			return false;
		}

		return this.getTermos().size() == polinomio.getTermos().size();
	}

	public String toString() {
		List<Monomio> termosOrdenados = sort(getTermos());

		StringBuilder builder = new StringBuilder();
		for (Monomio termo : termosOrdenados)
			builder.append(" " + termo);
		
		return builder.toString();
	}

	private List<Monomio> sort(List<Monomio> termos) {
		List<Monomio> termosOrdenados = new ArrayList<>();

		Comparator<Monomio> byExpoente = (t1, t2) -> Integer.compare(t2.expoente(), t1.expoente());

	    termos.stream()
	    	  .sorted(byExpoente)
	          .forEach(termo -> termosOrdenados.add(termo));
	    
	    return termosOrdenados;
	}
}
