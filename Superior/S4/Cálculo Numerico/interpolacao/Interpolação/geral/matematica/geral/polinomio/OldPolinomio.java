package matematica.geral.polinomio;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Deprecated
public class OldPolinomio {

	private List<OldTermo> termos;

	private OldPolinomio() {
		termos = new ArrayList<>();
	}

	public static OldPolinomio nulo() {
		return new OldPolinomio();
	}

	public static OldPolinomio unitario() {
		return OldPolinomio.nulo().add(OldTermo.unitario());
	}

	public OldPolinomio mais(OldPolinomio polinomio) {
		OldPolinomio resultado = OldPolinomio.nulo();

		for (OldTermo termo : this.getTermos())
			resultado.add(termo);

		for (OldTermo termo : polinomio.getTermos())
			resultado.add(termo);

		return resultado;
	}

	public OldPolinomio add(OldTermo termo) {
		OldTermo termoJaComputado = getTermoComMesmoExpoenteDo(termo);

		OldTermo resultado = termoJaComputado.mais(termo);

		this.termos.remove(termoJaComputado);
		this.termos.add(resultado);
		
		return this;
	}

	public OldTermo getTermoComMesmoExpoenteDo(OldTermo termo) {
		for (OldTermo t : termos)
			if (t.expoente() == termo.expoente())
				return t;

		return new OldTermo(0, termo.expoente());
	}

	public OldPolinomio vezes(OldPolinomio polinomio) {
		OldPolinomio resultado = new OldPolinomio();

		for (OldTermo termo : this.getTermos()) {
			OldPolinomio produto = polinomio.multiplicarCom(termo);

			resultado = resultado.mais(produto);
		}

		return resultado;
	}

	public OldPolinomio multiplicarCom(OldTermo termo) {
		OldPolinomio resultado = new OldPolinomio();
		
		for (OldTermo t : termos)
			resultado.add(t.vezes(termo));

		return resultado;
	}
	
	public OldPolinomio dividirCom(OldTermo termo) {
		OldPolinomio resultado = new OldPolinomio();
		
		for (OldTermo t : termos)
			resultado.add(t.sobre(termo));

		return resultado;
	}
	
	/**
	 * Sendo o polinomio uma função f(x),
	 * @return resultado para determinado x
	 */
	public double calcularFDeX(double x) {
		double resultado = 0;
		
		for (OldTermo termo : termos)
			resultado += termo.calcularResultadoPara(x);

		return resultado;
	}

	protected List<OldTermo> getTermos() {
		return termos;
	}

	@Override
	public boolean equals(Object obj) {
		OldPolinomio polinomio = (OldPolinomio) obj;
		
		for (OldTermo termo : termos) {
			OldTermo equivalente = polinomio.getTermoComMesmoExpoenteDo(termo);
			if (termo.equals(equivalente))
				continue;

			return false;
		}

		return this.getTermos().size() == polinomio.getTermos().size();
	}

	public String toString() {
		List<OldTermo> termosOrdenados = sort(getTermos());

		StringBuilder builder = new StringBuilder();
		for (OldTermo termo : termosOrdenados)
			builder.append(" " + termo);
		
		return builder.toString();
	}

	private List<OldTermo> sort(List<OldTermo> termos) {
		List<OldTermo> termosOrdenados = new ArrayList<>();

		Comparator<OldTermo> byExpoente = (t1, t2) -> Integer.compare(t2.expoente(), t1.expoente());

	    termos.stream()
	    	  .sorted(byExpoente)
	          .forEach(termo -> termosOrdenados.add(termo));
	    
	    return termosOrdenados;
	}
}
