package teste;

import java.util.ArrayList;
import java.util.List;

import dominio.Aviao;
import dominio.Balao;
import dominio.Bicicleta;
import dominio.Carro;
import dominio.Conduzivel;
import dominio.Motorizado;
import dominio.Transporte;

public class Teste {
	public static void main(String[] args) {
		new Teste();
	}
	
	public Teste() {
		List<Transporte> transportes = new ArrayList<>();
		Aviao aviao = new Aviao(500, 4);
		Balao balao = new Balao(3, 3*100);
		Carro carro = new Carro(5, "Hilux", 250);
		Bicicleta bicicleta = new Bicicleta(2, "Com cestinha", 247);

		transportes.add(aviao);
		transportes.add(balao);
		transportes.add(carro);
		transportes.add(bicicleta);
		
		infomacoesDos(transportes);
		System.out.println("\n\n\n");

		testarO((Conduzivel) carro);
		testarO((Conduzivel) aviao);
		testarO(bicicleta);

		testarO((Motorizado) carro);
		testarO((Motorizado) aviao);
	}

	private void infomacoesDos(List<Transporte> transportes) {
		for (Transporte transporte : transportes)
			System.out.println(transporte.toString() + "\n");
	}

	void testarO(Conduzivel conduzivel) {
		conduzivel.curvar(90);
	}
	
	void testarO(Motorizado motorizado) {
		motorizado.ligarMotor();
		motorizado.abastecer(80);
	}
}
