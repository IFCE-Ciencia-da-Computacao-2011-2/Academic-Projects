package ifce.padrao;

public class Cliente {
	private SomadorEsperado somador;
	private Cliente(SomadorEsperado somador) {
		this.somador = somador;
	}
	
	public void executar() {
		int[] vetor = new int[] {1,2,3,4,5,6,7,8,9,10};
		int soma = somador.somaVetor(vetor);
		System.out.println("Resultado: " + soma);
	}

	public static void main(String[] args) {
		Cliente cliente = new Cliente(new SomadorAdapter());
		cliente.executar();
	}
}
