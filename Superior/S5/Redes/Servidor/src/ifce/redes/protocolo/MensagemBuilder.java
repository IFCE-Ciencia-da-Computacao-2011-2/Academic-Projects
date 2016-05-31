package ifce.redes.protocolo;

public class MensagemBuilder {
	public static Mensagem gerar(String mensagem) {
		String palavras[] = mensagem.split(" ");

		TipoMensagem tipo = descobrirTipo(palavras[0]);

		if (tipo == TipoMensagem.CHUTE) {
			try {
				int chute = descobrirChute(palavras[1]);				
				return new Mensagem(tipo, chute);

			} catch (RuntimeException e) {
				tipo = TipoMensagem.ERRO;
			} catch (Exception e) {
				tipo = TipoMensagem.ERRO;
			}
		}

		return new Mensagem(tipo);
	}

	private static TipoMensagem descobrirTipo(String palavra) {
		for (TipoMensagem tipo : TipoMensagem.values())
			if (tipo.getRepresentacao().equals(palavra))
				return tipo;

		return TipoMensagem.ERRO;
	}
	
	private static int descobrirChute(String palavra) throws Exception {
		try {
			return Integer.parseInt(palavra);

		} catch (RuntimeException e) {
			throw new Exception("Não é possível converter \""+palavra+"\" em um inteiro");
		}
	}
}
