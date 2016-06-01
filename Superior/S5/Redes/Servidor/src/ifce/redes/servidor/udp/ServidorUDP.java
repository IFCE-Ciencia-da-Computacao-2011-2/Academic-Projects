package ifce.redes.servidor.udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.concurrent.ThreadLocalRandom;

//https://systembash.com/a-simple-java-udp-server-and-udp-client/#sthash.mi5kCNmy.dpuf
public class ServidorUDP {

	private DatagramSocket servidor;

	public ServidorUDP() throws IOException {
		this.servidor = new DatagramSocket(54321);
		System.out.println("Servidor UDP iniciado");

		while (true) {
			DatagramPacket pduRecebida = getDatagrama();

			int numero = 0;
			String dados = new String(pduRecebida.getData());
			String[] valores = dados.split(" ");

			if (valores.length >= 2) {
				try {
					int minimo = Integer.parseInt(valores[0]);
					int maximo = Integer.parseInt(valores[1]);
				
					numero = sortearNumero(minimo, maximo);
				} catch (RuntimeException e) {
					// Os dois valores dados não são inteiros
					numero = 0;
				}
			}

			enviarDatagrama("" + numero, pduRecebida.getAddress(), pduRecebida.getPort());
		} 
	}

	private DatagramPacket getDatagrama() throws IOException {
		byte[] receiveData = new byte[1024];

		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		servidor.receive(receivePacket);
		return receivePacket;
	}
	
	private int sortearNumero(int minimo, int maximo) {
		return ThreadLocalRandom.current().nextInt(minimo, maximo + 1);
	}

	private void enviarDatagrama(String mensagem, InetAddress ip, int porta) throws IOException {
		byte[] sendData = mensagem.getBytes();

		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, ip, porta);
		servidor.send(sendPacket);
	}
}