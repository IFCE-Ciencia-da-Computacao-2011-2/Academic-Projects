import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Optional;


public class Funcionario {
	private String nome;
	private double salario;
	private Date dataDeAdmissao;
	private Optional<Date> dataDeDemissao = Optional.empty();
	
	private boolean estaDeFerias = false; 

	public Funcionario(String nome, double salario) {
		this.nome = nome;
		this.salario = salario;
		this.dataDeAdmissao = new Date();
	}

	public void tirarFerias() {
		this.tirarFerias(30);
	}

	public void tirarFerias(int dias) {
		if (estaDeFerias)
			System.out.println("Meu filho, você já está de férias. Acabe antes de pedir de novo ¬¬'");

		else {
			System.out.println("Caro(a) " + nome + ",");
			System.out.println("Boas férias! :D");
			System.out.println("Total de dias que serão tirados: " + dias);
			estaDeFerias = true;
		}
	}

	public void demitir() {
		dataDeDemissao = Optional.of(Calendar.getInstance().getTime());
	}

	@Override
	public String toString() {
		SimpleDateFormat dataFormatter = new SimpleDateFormat("dd/MM/yyyy");

		String retorno = "";
		retorno += "Nome: " + nome + "\n";
		retorno += "Salario: " + salario + "\n";

		retorno += "Data de Admissão: ";
		retorno += dataFormatter.format(dataDeAdmissao);
		retorno += "\n";

		if (dataDeDemissao.isPresent()) {
			retorno += "Data de Demissão: ";
			retorno += dataFormatter.format(dataDeDemissao.get());
		}

		return retorno;
	}
}
