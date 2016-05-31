package game;

import java.io.IOException;
import javax.swing.JOptionPane;

public class Principal {
	public static void main(String[] args) throws ClassNotFoundException,
			IOException {
		String ip = JOptionPane.showInputDialog("Digite IP do servidor");
		int porta = Integer.parseInt(JOptionPane
				.showInputDialog("Digite Numero de Porta"));
		
		Cliente c = new Cliente();

		try {
			c.conecta(ip, porta);

		} catch (IOException e) {
			JOptionPane.showMessageDialog(null,
					"Erro ao se conectar ao servidor! Verifique IP e Porta! ");

		}

	}
}
