package br.edu.ifce.estrutura.arvore;

import java.util.Iterator;

import br.edu.ifce.estrutura.arvore.Visitador.TipoVisita;

public class ArvoreBinaria<E> {

	private No<E> raiz;

	public void inserir(int chave, E valor) {
		No<E> aInserir = new No<>(chave, valor);
		
		if (raiz == null) {
			raiz = aInserir;
			return;
		}

		No<E> no = raiz;
		No<E> anterior = null;

		do {
			boolean chaveJaExistente = no.chave == aInserir.chave; 
			if (chaveJaExistente) {
				no.valor = aInserir.valor;
				return;
			}

			anterior = no;
			no = no.chave < aInserir.chave ? no.direita : no.esquerda;

		} while (no != null);


		aInserir.pai = anterior;
		if (anterior.chave < chave)
			anterior.direita = aInserir;
		else 
			anterior.esquerda = aInserir;
	}
	
	public void remover(int chave) {
		No<E> no = buscar(chave, raiz);
		if (no == null)
			return;

		remover(no);
	}

	private void remover(No<E> no) {
		if (no.isFolha())
			removerNoFolha(no);
		
		else if (no.hasUnicoFilho())
			removerNoComUmFilho(no);
		
		else {
			No<E> sucessor = no.direita.min();

			if (no.direita == sucessor)
				removerNoComSucessorADireita(no);
			else
				removerNoComSucessorNaoADireita(no, sucessor);
		}
	}

	private void removerNoFolha(No<E> no) {
		transplantar(no, null);
	}

	private void transplantar(No<E> aSerSubstituido, No<E> substituidor) {
		if (aSerSubstituido.isRaiz())
			this.raiz = substituidor;

		else if (aSerSubstituido.isFilhoADireita())
			aSerSubstituido.pai.direita = substituidor;
		else
			aSerSubstituido.pai.esquerda = substituidor;

		if (substituidor != null)
			substituidor.pai = aSerSubstituido.pai;
	}

	private void removerNoComUmFilho(No<E> no) {
		No<E> noFilho = no.esquerda != null ? no.esquerda : no.direita;
		transplantar(no, noFilho);
	}
	
	private void removerNoComSucessorADireita(No<E> no) {
		No<E> sucessor = no.direita;

		transplantar(no, sucessor);
		sucessor.esquerda = no.esquerda;
	}

	private void removerNoComSucessorNaoADireita(No<E> no, No<E> sucessor) {
		remover(sucessor);
		substituir(no, sucessor);
	}

	private void substituir(No<E> aSerSubstituido, No<E> substituidor) {
		if (aSerSubstituido.isRaiz())
			this.raiz = substituidor;
		else {
			substituidor.pai = aSerSubstituido.pai;
			aSerSubstituido.pai.direita = substituidor;
		}

		substituidor.direita = aSerSubstituido.direita;
		substituidor.esquerda = aSerSubstituido.esquerda;
	}

	public E buscar(int chave) {
		No<E> no = buscar(chave, raiz);
		
		return no == null ? null : no.valor;
	}

	private No<E> buscar(int chave, No<E> no) {
		if (no == null || chave == no.chave)
			return no;

		no = chave > no.chave ? no.direita : no.esquerda;

		return buscar(chave, no);
	}

	public E min() {
		if (raiz == null)
			return null;

		No<E> menor = raiz.min();
		return menor.valor;
	}

	public E max() {
		if (raiz == null)
			return null;

		No<E> maior = raiz.max();
		return maior.valor;
	}

	public E sucessor(int chave) {
		No<E> no = buscar(chave, raiz);
		if (no == null)
			return null;

		No<E> sucessor = no.sucessor();
		return sucessor == null ? null : sucessor.valor;
	}

	public E antecessor(int chave) {
		No<E> no = buscar(chave, raiz);
		if (no == null)
			return null;

		No<E> antecessor = no.antecessor();
		return antecessor == null ? null : antecessor.valor;
	}
	
	public Iterator<E> preOrder() {
		return visitar(Visitador.PreOrder);
	}

	public Iterator<E> posOrder() {
		return visitar(Visitador.PosOrder);
	}
	
	public Iterator<E> inOrder() {
		return visitar(Visitador.InOrder);
	}

	private Iterator<E> visitar(TipoVisita tipoVisitar) {
		Visitador<E> visitador = new Visitador<>(tipoVisitar);
		return visitador.visitar(raiz);
	}
}