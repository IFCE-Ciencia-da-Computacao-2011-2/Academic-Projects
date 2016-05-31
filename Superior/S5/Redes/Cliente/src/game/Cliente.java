package game;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import javax.swing.JOptionPane;

public class Cliente {

	// Tentativa de Conexão com Servidor;
	public void conecta(String ip, int porta) throws IOException,
			ClassNotFoundException {
		Socket cliente;
		try {

			cliente = new Socket(ip, porta);
			System.out.println("O cliente se conectou ao servidor!");
			// Obtendo Valor Gerado pelo Servidor
			ObjectInputStream entrada = new ObjectInputStream(
					cliente.getInputStream());
			int valorEscondido = (Integer) entrada.readObject();

			entrada.close();
			cliente.close();
			// Startando o game
			game(valorEscondido);
		} catch (UnknownHostException e) {
			System.out.println("Erro: " + e.getMessage());
		}

	}

	/* Metodos para Game */
	public void game(int valorEscondido) {
		boolean chuteCerto = false;
		while (chuteCerto == false) {
			if (chute(valorEscondido)) {
				chuteCerto = true;
			}
		}

	}

	// Recebe o Valor Gerado pelo Servidor e Testa se o Chute é igual ao valor;
	public boolean chute(int valorEscondido) {

		int chute = Integer.parseInt(JOptionPane
				.showInputDialog("Digite seu chute: "));

		if (valorEscondido == chute) {
			JOptionPane.showMessageDialog(null,
					"Acertôô Mizeravi ! \n Jogo Finalizado! ");
			return true;
		} else if (valorEscondido < chute) {
			JOptionPane.showMessageDialog(null,
					"Chute um valor mais baixo, Noob! ");
		} else {
			JOptionPane.showMessageDialog(null,
					"Chute um valor mais alto!, Noob! ");
		}
		return false;
	}

}
