package ifce.redes.protocolo;

public class Mensagem {
	final TipoMensagem tipo;
	final Integer valor;
	
	public Mensagem(TipoMensagem tipo) {
		this(tipo, null);
	}

	public Mensagem(TipoMensagem tipo, Integer valor) {
		this.tipo = tipo;
		this.valor = valor;
	}
	
	@Override
	public String toString() {
		StringBuilder mensagem = new StringBuilder();

		mensagem.append(tipo);

		if (tipo != null) {
			mensagem.append(" ");
			mensagem.append(valor);
		}

		mensagem.append(" ");

		return mensagem.toString();
	}
}
