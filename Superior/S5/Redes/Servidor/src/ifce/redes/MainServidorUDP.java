package ifce.redes;

import java.io.IOException;

import ifce.redes.servidor.udp.ServidorUDP;

public class MainServidorUDP {
	public static void main(String[] args) throws IOException, InterruptedException {
		new ServidorUDP();
		
		while (true)
			Thread.sleep(60000);
	}
}
