package dominio;

public abstract class Transporte {
	private String nome = "";
	private int numeroPassageiros;
	private int velocidadeAtual;

	public Transporte(String nome, int numeroDePassageiros) {
		this.nome = nome;
		this.numeroPassageiros = numeroDePassageiros;
		this.velocidadeAtual = 0;
	}

	private boolean estaParado() {
		return velocidadeAtual == 0;
	}
	
	@Override
	public String toString() {
		String retorno = "";
		retorno += "Nome: " + nome + "\n";
		retorno += "Número de passageiros: " + numeroPassageiros + "\n";
		retorno += "Velocidade atual: " + velocidadeAtual + "\n";
		retorno += "Está parado? " + estaParado();
		
		return retorno;
	}
}
