package matematica.geral.polinomio;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class Polinomio implements Iterable<Monomio> {

	private List<Monomio> termos;

	private Polinomio() {
		this(new ArrayList<>());
	}

	private Polinomio(List<Monomio> termos) {
		this.termos = termos;
	}

	public static Polinomio nulo() {
		return new Polinomio();
	}

	public static Polinomio unitario() {
		return Polinomio.nulo().mais(Monomio.unitario());
	}

	public Monomio termoIndependente() {
		for (Monomio monomio : this)
			if (monomio.isTermoIndependente()) 
				return monomio;
		
		return Monomio.nulo();
	}

	public Polinomio mais(Polinomio polinomio) {
		Polinomio resultado = Polinomio.nulo();

		for (Monomio termo : this)
			resultado = resultado.mais(termo);

		for (Monomio termo : polinomio)
			resultado = resultado.mais(termo);

		return resultado;
	}

	public Polinomio mais(Monomio termo) {
		Optional<Monomio> termoJaComputado = getTermoComMesmaParteLiteralDo(termo);

		Monomio resultado = termoJaComputado.isPresent() ? termoJaComputado.get().mais(termo) : termo;

		Polinomio copia = copia();
		if (termoJaComputado.isPresent())
			copia.termos.remove(termoJaComputado.get());
		copia.termos.add(resultado);

		return copia;
	}

	public Polinomio menos(Polinomio termo) {
		return mais(termo.vezes(new Monomio(-1)));
	}

	public Polinomio menos(Monomio termo) {
		return mais(termo.vezes(-1));
	}

	private Polinomio copia() {
		return new Polinomio(new ArrayList<>(this.termos));
	}

	private Optional<Monomio> getTermoComMesmaParteLiteralDo(Monomio termo) {
		 return termos.stream()
		 	 		  .filter(t -> t.parteLiteral().equals(termo.parteLiteral()))
		 	 		  .findAny();
	}

	public Polinomio vezes(Polinomio polinomio) {
		Polinomio resultado = Polinomio.nulo();

		for (Monomio termo : this) {
			Polinomio produto = polinomio.vezes(termo);

			resultado = resultado.mais(produto);
		}

		return resultado;
	}

	public Polinomio vezes(Monomio termo) {
		Polinomio resultado = new Polinomio();

		for (Monomio t : termos)
			resultado = resultado.mais(t.vezes(termo));

		return resultado;
	}

	/**
	 * @return Total de termos
	 */
	public int size() {
		return this.termos.size();
	}

	/**
	 * @return this e @param polinomio possuem as mesmas incógnitas?
	 */
	public boolean isEquivalente(Polinomio polinomio) {
		for (Monomio termo : this) {
			Optional<Monomio> equivalente = polinomio.getTermoComMesmaParteLiteralDo(termo);
			if (!equivalente.isPresent())
				return false;
		}
		
		for (Monomio termo : polinomio) {
			Optional<Monomio> equivalente = this.getTermoComMesmaParteLiteralDo(termo);
			if (!equivalente.isPresent())
				return false;
		}

		return true;
	}

	@Override
	public boolean equals(Object obj) {
		Polinomio polinomio = (Polinomio) obj;
		
		if (this.size() != polinomio.size())
			return false;

		for (Monomio termo : termos) {
			Optional<Monomio> equivalente = polinomio.getTermoComMesmaParteLiteralDo(termo);
			if (equivalente.isPresent() && termo.equals(equivalente.get()))
				continue;

			return false;
		}

		return true;
	}

	public String toString() {
		StringBuilder builder = new StringBuilder();
		Iterator<Monomio> iterator = this.termos.stream()
			.sorted(Monomio::compareTo)
			.collect(Collectors.toCollection(LinkedList::new))
			.descendingIterator();
		
		while (iterator.hasNext())
			builder.append(" " + iterator.next());

		return builder.toString();
	}

	@Override
	public Iterator<Monomio> iterator() {
		return termos.iterator();
	}
}
