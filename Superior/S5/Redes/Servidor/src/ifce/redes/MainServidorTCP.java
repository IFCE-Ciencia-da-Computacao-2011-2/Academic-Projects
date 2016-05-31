package ifce.redes;

import java.io.IOException;

import ifce.redes.servidor.tcp.ServidorTCP2;

public class MainServidorTCP {
	public static void main(String[] args) throws IOException, InterruptedException {
		ServidorTCP2 server = new ServidorTCP2();

		while (true) {
			Thread.sleep(60000);
		}
	}
}
