package game;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;


public class Servidor {
   public static void main(String[] args) throws IOException {
     ServerSocket servidor = new ServerSocket(12345);
     System.out.println("Porta 12345 aberta!");
     
     Socket cliente = servidor.accept();
     System.out.println("Nova conexão com o cliente " +   
       cliente.getInetAddress().getHostAddress()
     );
     int valor = 10;	
     
     ObjectOutputStream saida = new ObjectOutputStream(cliente.getOutputStream());
     
     saida.flush();
     saida.writeObject(valor);
     saida.close();
     cliente.close();
     servidor.close();
 
   }
 }