package ifce.redes.servidor.tcp;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousServerSocketChannel;
import java.nio.channels.AsynchronousSocketChannel;
import java.nio.channels.CompletionHandler;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import ifce.redes.protocolo.Mensagem;
import ifce.redes.protocolo.MensagemBuilder;
import ifce.redes.protocolo.Protocolo;

public class ServidorTCP2 implements CompletionHandler<AsynchronousSocketChannel, Void> {

	private static final int PORTA = 12345;
	private final AsynchronousServerSocketChannel servidor;
	private Map<InetSocketAddress, Partida> partidas;

	public ServidorTCP2() throws IOException {
		this.partidas = new ConcurrentHashMap<>();
		this.servidor = AsynchronousServerSocketChannel.open().bind(new InetSocketAddress(PORTA));

		System.out.println("Servidor TCP iniciado");
		// Aceitar próxima conexão
		servidor.accept(null, this);
	}

	@Override
	public void completed(AsynchronousSocketChannel canal, Void attachment) {
		servidor.accept(null, this);

		System.out.println("Conexão com cliente recebida");
		Partida partida = new Partida();
		partidas.put(getEnderecoProcessoCliente(canal), partida);

		try {
			conversa(canal, partida);
		} catch (InterruptedException | ExecutionException | IOException e) {
			e.printStackTrace();
		} catch (TimeoutException e) {
			// The user exceeded the 20 second timeout, so close the connection
		}

		System.out.println("Conexão encerrada");
		try {
			if (canal.isOpen())
				canal.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	private InetSocketAddress getEnderecoProcessoCliente(AsynchronousSocketChannel canal) {
		InetSocketAddress enderecoCliente = null;
		try {
			enderecoCliente = (InetSocketAddress) canal.getRemoteAddress();
		} catch (IOException e2) {
			e2.printStackTrace();
		}
		return enderecoCliente;
	}

	private void conversa(AsynchronousSocketChannel canal, Partida partida) throws InterruptedException, ExecutionException, TimeoutException, IOException {
		ByteBuffer byteBuffer = ByteBuffer.allocate(4096);

		while (true) {
			int bytesRead = canal.read(byteBuffer).get(1, TimeUnit.DAYS);

			System.out.println( "bytes read: " + bytesRead );

			boolean linhaVazia = byteBuffer.position() <= 2;
			if (linhaVazia)
				break;

			// Make the buffer ready to read
			byteBuffer.flip();

			// Convert the buffer into a line
			byte[] linha = new byte[bytesRead];
			byteBuffer.get(linha, 0, bytesRead);

			Mensagem mensagemRecebida = MensagemBuilder.gerar(new String(linha));
			Protocolo protocolo = new Protocolo(partida);
			Mensagem mensagemAEnviar = protocolo.protocolar(mensagemRecebida);

			canal.write(ByteBuffer.wrap(mensagemAEnviar.toString().getBytes()));

			byteBuffer.clear();
		}
	}

	@Override
	public void failed(Throwable exc, Void attachment) {
		// TODO Auto-generated method stub
	}
}
