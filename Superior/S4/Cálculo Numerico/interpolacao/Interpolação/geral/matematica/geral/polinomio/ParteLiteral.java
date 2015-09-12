package matematica.geral.polinomio;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.SortedMap;
import java.util.TreeMap;

import matematica.geral.Incognita;

public class ParteLiteral implements Iterable<Incognita>, Comparable<ParteLiteral> {
	private final SortedMap<Character, Incognita> incognitas;

	public static ParteLiteral com(Incognita... incognitas) {
		ParteLiteral parteLiteral = new ParteLiteral();
		
		for (Incognita incognita : incognitas)
			parteLiteral = parteLiteral.vezes(incognita);

		return parteLiteral;
	}

	private ParteLiteral() {
		this(new TreeMap<>());
	}

	private ParteLiteral(SortedMap<Character, Incognita> incognitas) {
		this.incognitas = incognitas;
	}


	/**
	 * @return new ParteLiteral
	 */
	public ParteLiteral vezes(ParteLiteral parteLiteral) {
		List<Incognita> incognitas = new LinkedList<>();
		incognitas.addAll(this.incognitas());
		incognitas.addAll(parteLiteral.incognitas());

		ParteLiteral resultado = ParteLiteral.com();
		for (Incognita incognita : incognitas)
			resultado = resultado.vezes(incognita);

		return resultado;
	}

	/**
	 * @return new ParteLiteral
	 */
	public ParteLiteral vezes(Incognita incognita) {
		Incognita thisIncognita = this.incognitaEquivalenteA(incognita);
		Incognita incognitaResultado = thisIncognita.vezes(incognita);

		ParteLiteral resultado = this.inserirOuSubstituir(incognitaResultado);

		return resultado;
	}

	private Incognita incognitaEquivalenteA(Incognita incognita) {
		Optional<Incognita> equivalente = optionalIncognitaEquivalenteA(incognita);
		
		if (equivalente.isPresent())
			return equivalente.get();

		else
			return new Incognita(incognita.representacao(), 0);
	}


	
	private ParteLiteral copia() {
		return new ParteLiteral(new TreeMap<>(this.incognitas));
	}

	private ParteLiteral inserirOuSubstituir(Incognita incognita) {
		ParteLiteral resultado = this.copia();
		resultado.incognitas.put(incognita.representacao(), incognita);

		return resultado;
	}

	private ParteLiteral remover(Incognita incognita) {
		ParteLiteral resultado = this.copia();
		resultado.incognitas.remove(incognita.representacao());

		return resultado;
	}

	private Optional<Incognita> optionalIncognitaEquivalenteA(Incognita incognita) {
		if (incognitas.containsKey(incognita.representacao()))
			return Optional.of(incognitas.get(incognita.representacao()));

		else
			return Optional.empty();
	}

	public Collection<Incognita> incognitas() {
		return incognitas.values();
	}

	public int size() {
		return incognitas.size();
	}

	/**
	 * @return this possui as mesmas incógnitas de @param parteLiteral?
	 */
	public boolean isEquivalente(ParteLiteral parteLiteral) {
		if (this.incognitas().size() != parteLiteral.incognitas().size())
			return false;

		for (Incognita incognita : parteLiteral) {
			Optional<Incognita> equivalente = this.optionalIncognitaEquivalenteA(incognita);
			if (!equivalente.isPresent())
				return false;
		}

		return true;
	}

	@Override
	public boolean equals(Object obj) {
		ParteLiteral parteLiteral = (ParteLiteral) obj;

		if (this.incognitas().size() != parteLiteral.incognitas().size())
			return false;

		for (Incognita incognita : parteLiteral) {
			Optional<Incognita> equivalente = this.optionalIncognitaEquivalenteA(incognita);
			if (!equivalente.isPresent() ||
				 equivalente.isPresent() && !equivalente.get().equals(incognita))
				return false;
		}

		return true;
	}

	@Override
	public Iterator<Incognita> iterator() {
		return incognitas.values().iterator();
	}

	@Override
	public String toString() {
		StringBuilder retorno = new StringBuilder();
		for (Incognita incognita : this)
			retorno.append(incognita);

		return retorno.toString();
	}

	@Override
	public int compareTo(ParteLiteral parteLiteral) {
		if (this.size() == 0 && parteLiteral.size() == 0)
			return 0;
		else if (this.size() == 0)
			return 1;
		else if (parteLiteral.size() == 0)
			return -1;

		Character thisPrimeiraIncognita = this.incognitas.firstKey();
		Character otherPrimeiraIncognita = parteLiteral.incognitas.firstKey();

		if (thisPrimeiraIncognita == otherPrimeiraIncognita)
			return Double.compare(this.incognitas.get(thisPrimeiraIncognita).expoente(), parteLiteral.incognitas.get(otherPrimeiraIncognita).expoente());
		else
			return Character.compare(thisPrimeiraIncognita, otherPrimeiraIncognita);
	}
}