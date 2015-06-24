
public class Instancia {
	public static void main(String[] args) {
		Funcionario antonio = new Funcionario("Antonio", 52.0);
		antonio.tirarFerias();
		System.out.println();

		antonio.tirarFerias(15);
		
		System.out.println();
		System.out.println(antonio);
		
		antonio.demitir();
		
		System.out.println();
		System.out.println(antonio);
	}
}
