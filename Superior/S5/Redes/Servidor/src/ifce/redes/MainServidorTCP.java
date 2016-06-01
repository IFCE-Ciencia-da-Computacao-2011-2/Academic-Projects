package ifce.redes;

import java.io.IOException;

import ifce.redes.servidor.tcp.ServidorTCP;

public class MainServidorTCP {
	public static void main(String[] args) throws IOException, InterruptedException {
		new ServidorTCP();

		while (true)
			Thread.sleep(60000);
	}
}
