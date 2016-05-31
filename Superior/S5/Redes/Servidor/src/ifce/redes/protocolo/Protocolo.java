package ifce.redes.protocolo;

import java.io.IOException;
import java.net.UnknownHostException;

import ifce.redes.servidor.tcp.Partida;
import ifce.redes.servidor.udp.ClienteUDP;

public class Protocolo {
	private Partida partida;

	public Protocolo(Partida partida) {
		this.partida = partida;
	}

	public Mensagem protocolar(Mensagem mensagem) throws IOException {
		if (mensagem.tipo == TipoMensagem.INICIAR)
			return processarMensagemIniciar();
		if (mensagem.tipo == TipoMensagem.CHUTE)
			return processarMensagemChute(mensagem);
		
		return new Mensagem(TipoMensagem.ERRO);
	}

	private Mensagem processarMensagemIniciar() throws UnknownHostException, IOException {
		ClienteUDP cliente = new ClienteUDP();
		int numero = cliente.requestNumeroSorteado(Partida.MINIMO, Partida.MAXIMO);
		partida.setNumeroADescrobrir(numero);

		return new Mensagem(TipoMensagem.INICIAR);
	}

	private Mensagem processarMensagemChute(Mensagem mensagem) {
		if (mensagem.valor > partida.getNumeroADescrobrir())
			return new Mensagem(TipoMensagem.ALTO);
		else if (mensagem.valor < partida.getNumeroADescrobrir())
			return new Mensagem(TipoMensagem.BAIXO);
		else
			return new Mensagem(TipoMensagem.IGUAL);
	}
}
