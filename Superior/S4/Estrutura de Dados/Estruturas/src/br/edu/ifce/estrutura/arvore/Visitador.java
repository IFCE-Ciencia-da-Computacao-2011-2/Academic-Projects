package br.edu.ifce.estrutura.arvore;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;

@SuppressWarnings("rawtypes")
class Visitador<E> {
	static abstract class TipoVisita {
		private Queue fila;

		Queue getFila() {
			return fila;
		}

		void setFila(Queue fila) {
			this.fila = fila;
		}

		abstract void visitar(No<?> no);
	}

	private TipoVisita tipo;

	public Visitador(TipoVisita tipo) {
		this.tipo = tipo;
		this.tipo.setFila(new LinkedList<E>());
	}

	@SuppressWarnings("unchecked")
	public Iterator<E> visitar(No<E> raiz) {
		tipo.visitar(raiz);
		return tipo.fila.iterator();
	}

	@SuppressWarnings("unchecked")
	public static final TipoVisita PreOrder = new TipoVisita() {
		@Override
		public void visitar(No<?> no) {
			if (no == null)
				return;

			visitar(no.esquerda);
			getFila().add(no.valor);
			visitar(no.direita);
		}
	};
	
	@SuppressWarnings("unchecked")
	public final static TipoVisita PosOrder = new TipoVisita() {
		@Override
		public void visitar(No<?> no) {
			if (no == null)
				return;

			visitar(no.direita);
			getFila().add(no.valor);
			visitar(no.esquerda);
		}
	};

	@SuppressWarnings("unchecked")
	public final static TipoVisita InOrder = new TipoVisita() {
		@Override
		public void visitar(No<?> no) {
			if (no == null)
				return;

			getFila().add(no.valor);
			visitar(no.esquerda);
			visitar(no.direita);
		}
	};
}
