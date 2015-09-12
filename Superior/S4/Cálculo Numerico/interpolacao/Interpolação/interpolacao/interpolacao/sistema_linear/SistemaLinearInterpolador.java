package interpolacao.sistema_linear;

import interpolacao.Interpolador;
import utilitarios.StringBuilderLn;
import matematica.geral.coordenadas.Coordenada;
import matematica.geral.coordenadas.Coordenadas;
import matematica.geral.polinomio.OldTermo;
import matematica.geral.polinomio.OldPolinomio;
import matematica.sistema_linear.exception.EntradaException;
import matematica.sistema_linear.solucionador.PorJordanSistemaLinear;
import matematica.sistema_linear.solucionador.SolucionadorSistemaLinear;
import matematica.sistema_linear.EquacaoLinear.Coeficiente;
import matematica.sistema_linear.SistemaLinear;
import matematica.sistema_linear.SistemaLinearBuilder;
import matematica.sistema_linear.SolucaoSistemaLinear;

public class SistemaLinearInterpolador implements Interpolador {

	private double xInterpolador;

	private Coordenadas coordenadas;
	private OldPolinomio polinomioInterpolador;

	private SistemaLinear sistema;
	private SolucaoSistemaLinear solucaoSistemaLinear;

	public SistemaLinearInterpolador(Coordenadas coordenadas, double xInterpolador) throws EntradaException {
		this.xInterpolador = xInterpolador;

		this.coordenadas = coordenadas;

		this.sistema = gerarSistemaLinearPara(coordenadas);

		SolucionadorSistemaLinear resolvedor = new PorJordanSistemaLinear();
		this.solucaoSistemaLinear = resolvedor.solucionar(sistema);

		this.polinomioInterpolador = gerarPolinomioResultado(solucaoSistemaLinear);
	}

	private OldPolinomio gerarPolinomioResultado(SolucaoSistemaLinear solucaoLinear) {
		OldPolinomio polinomioInterpolador = OldPolinomio.nulo();
		int expoente = 0;
		for (Coeficiente solucao : solucaoLinear) {
			polinomioInterpolador.add(new OldTermo(solucao.get(), expoente));
			expoente++;
		}

		return polinomioInterpolador;
	}

	private SistemaLinear gerarSistemaLinearPara(Coordenadas coordenadas) {
		SistemaLinearBuilder builder = new SistemaLinearBuilder();

		int index = 0;
		for (Coordenada coordenada : coordenadas) {
			double[] xElevados = gerarXElevados(index, coordenadas);
			builder.addEquacao(coordenada.y(), xElevados);
			index++;
		}

		return builder.criar();
	}

	private double[] gerarXElevados(int index, Coordenadas coordenadas) {
		double[] xElevados = new double[coordenadas.size()];

		double x = coordenadas.getCoordenada(index).x();

		for (int i = 0; i < coordenadas.size(); i++)
			xElevados[i] = Math.pow(x, i);

		return xElevados;
	}
	
	@Override
	public String toString() {
		StringBuilderLn builder = new StringBuilderLn();
		builder.appendLn(coordenadas);
		builder.appendLn();

		builder.appendLn("Polinômio desejado");
		builder.append("P"+(coordenadas.size()-1)+"(x) = ");
		for (int i = 0; i < coordenadas.size(); i++)
			builder.append(" +a"+i+"x^"+i);
		builder.appendLn();
		builder.appendLn();
		
		builder.appendLn("Calcular a0 ... an:");
		builder.appendLn(solucaoSistemaLinear.getPassos());
		builder.appendLn();
		builder.appendLn("Resultado:");
		builder.appendLn(solucaoSistemaLinear);
		
		builder.append("P"+(coordenadas.size()-1)+"(x) = ");
		builder.appendLn(polinomioInterpolador);
		builder.append("P"+(coordenadas.size()-1)+"(x) = ");
		builder.append(polinomioInterpolador.calcularFDeX(this.xInterpolador));

		return builder.toString();
	}
}
