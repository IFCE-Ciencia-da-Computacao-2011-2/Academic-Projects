package interpolacao.util;

public class Mat {
	public static double mmc(double num1, double num2) {
		double a = num1;
		double b = num2;

		Double resto = -1.0;
		while (resto != 0) {
			resto = a % b;
			a  = b;
			b  = resto;
		}

		return (num1 * num2) / a;
	}

	public static double mdc(double a, double b){
		Double resto;

		while(b != 0){
			resto = a % b;
			a = b;
			b = resto;
		}

		return a;
	} 
}
