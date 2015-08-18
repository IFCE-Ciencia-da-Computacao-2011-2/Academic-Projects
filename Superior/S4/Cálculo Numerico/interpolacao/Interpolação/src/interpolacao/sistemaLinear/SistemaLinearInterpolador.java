package interpolacao.sistemaLinear;

import matematica.polinomio.Polinomio;
import matematica.polinomio.Monomio;
import interpolacao.sistemaLinear.sistemaLinear.ResolvedorSistemaLinear;
import interpolacao.sistemaLinear.sistemaLinear.ResolvedorSistemaLinearPorTriangulacao;
import interpolacao.sistemaLinear.sistemaLinear.SistemaLinear;
import interpolacao.sistemaLinear.sistemaLinear.SistemaLinearBuilder;
import interpolacao.sistemaLinear.sistemaLinear.SolucaoSistemaLinear;
import interpolacao.util.StringBuilderLn;
import interpolacao.util.coordenadas.Coordenada;
import interpolacao.util.coordenadas.Coordenadas;

public class SistemaLinearInterpolador {

	private double xInterpolador;

	private Coordenadas coordenadas;
	private Polinomio polinomioInterpolador;

	private SistemaLinear sistema;
	private SolucaoSistemaLinear solucaoSistemaLinear;

	public SistemaLinearInterpolador(Coordenadas coordenadas, double xInterpolador) {
		this.xInterpolador = xInterpolador;

		this.coordenadas = coordenadas;

		this.sistema = gerarSistemaLinearPara(coordenadas);

		ResolvedorSistemaLinear resolvedor = new ResolvedorSistemaLinearPorTriangulacao();
		this.solucaoSistemaLinear = resolvedor.resolver(sistema);

		this.polinomioInterpolador = gerarPolinomioResultado(solucaoSistemaLinear);
	}

	private Polinomio gerarPolinomioResultado(SolucaoSistemaLinear solucaoLinear) {
		Polinomio polinomioInterpolador = Polinomio.nulo();
		int expoente = 0;
		for (Double solucao : solucaoLinear) {
			polinomioInterpolador.add(new Monomio(solucao, expoente));
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
