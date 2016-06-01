package ifce.redes.servidor.udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;

//https://systembash.com/a-simple-java-udp-server-and-udp-client/#sthash.mi5kCNmy.dpuf
public class ClienteUDP {
	private final InetAddress ip;
	private final int porta;
	
	public ClienteUDP() throws UnknownHostException {
		ip = InetAddress.getByName("localhost");
		porta = 54321;
	}
	
	public ClienteUDP(String ip, int porta) throws UnknownHostException {
		this.ip = InetAddress.getByName(ip);
		this.porta = porta;
	}

	public int requestNumeroSorteado(int minimo, int maximo) throws IOException {
		int numero = 0;

		DatagramSocket cliente = new DatagramSocket();
		request(cliente, minimo, maximo);
		numero = response(cliente);
		cliente.close();
		
		return numero;
	}

	private void request(DatagramSocket cliente, int minimo, int maximo) throws IOException {
		String dados = minimo + " " + maximo + " ";

		byte[] bytes = dados.getBytes();

		DatagramPacket sendPacket = new DatagramPacket(bytes, bytes.length, ip, porta);
		cliente.send(sendPacket);
	}

	private int response(DatagramSocket cliente) throws IOException {
		byte buffer[] = new byte[1024];

		DatagramPacket receivePacket = new DatagramPacket(buffer, buffer.length);    
		cliente.receive(receivePacket);

		String retorno = new String(receivePacket.getData());
		String[] dados = retorno.split("\0");
		
		return Integer.parseInt(dados[0]);
	}
}