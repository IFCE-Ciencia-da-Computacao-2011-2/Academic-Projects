package game;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.PrintStream;
import java.net.Socket;
import java.net.UnknownHostException;

import javax.swing.JOptionPane;

import protocolo.Mensagem;
import protocolo.TipoMensagem;


public class Cliente {
	// Tentativa de Conexão com Servidor;

	public void conecta(String ip, int porta) throws IOException, ClassNotFoundException {
		Socket conexao;

		try {
			conexao = new Socket(ip, porta);
			System.out.println("O cliente se conectou ao servidor!");
			JOptionPane.showMessageDialog(null, " Clique em Ok para iniciar");

			PrintStream streamOut = new PrintStream(conexao.getOutputStream());
			streamOut.print(new Mensagem(TipoMensagem.INICIAR));

			BufferedReader streamIn = new BufferedReader(new InputStreamReader(conexao.getInputStream()));
			String resposta = getMensagemDoServidor(streamIn);
			System.out.println(resposta);

			boolean fim = false;

			if (!resposta.equals("iniciar")) {
				conexao.close();
				return;
			}

			while (!fim) {
				int valorChute = Integer.parseInt(JOptionPane.showInputDialog("Chute: "));
				streamOut.print(new Mensagem(TipoMensagem.CHUTE, valorChute));

				resposta = getMensagemDoServidor(streamIn);

				String mensagemUsuario = "";

				if (resposta.equals("alto")){
					mensagemUsuario = "Digite um valor mais baixo, Nooob!";

				} else if (resposta.equals("baixo")){
					mensagemUsuario = "Digite um valor mais alto, Noob!";

				} else if (resposta.equals("igual")){
					mensagemUsuario = "Acertô Mizeravi ^^ ";
					fim = true;

				} else {
					mensagemUsuario = "Algo deu errado :V ";
				}

				JOptionPane.showMessageDialog(null, mensagemUsuario);
			}
			conexao.close();

		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
	}

	private String getMensagemDoServidor(BufferedReader streamIn) throws IOException {
		String resposta = "";

		char caractere = (char) streamIn.read();
		do {
			resposta += caractere;
			caractere = (char) streamIn.read();
		} while (caractere != ' ');

		return resposta;
	}
}