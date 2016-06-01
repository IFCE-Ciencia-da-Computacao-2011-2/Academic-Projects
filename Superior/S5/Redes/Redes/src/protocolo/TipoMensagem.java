package protocolo;

public enum TipoMensagem {
	/** Iniciar nova partida */
	INICIAR("iniciar"),
	
	/** Chutar um número */
	CHUTE("chute"),
	
	/** Ocorreu algum erro */
	ERRO("erro"),
	
	/** Chute foi alto */
	ALTO("alto"),
	
	/** Chute foi baixo */
	BAIXO("baixo"),

	/** Chute foi certeiro */
	IGUAL("igual");
	
	private String representacao;

	private TipoMensagem(String representacao) {
		this.representacao = representacao;
	}
	
	public String getRepresentacao() {
		return representacao;
	}

	@Override
	public String toString() {
		return this.representacao;
	}
}
