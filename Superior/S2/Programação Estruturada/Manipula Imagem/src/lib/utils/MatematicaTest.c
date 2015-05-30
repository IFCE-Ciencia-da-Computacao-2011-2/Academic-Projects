#include "../tests/tests_utils.h"
#include "../tests/thc.h"
#include "MatematicaTest.h"
#include "Matematica.h"

static void menorTest() {
	cabecalho("menorTest()");
	ENSURE(menor(1, 2) == 1);
	ENSURE(menor(2, 1) == 1);
	ENSURE(menor(-1, 5) == -1);
	ENSURE(menor(5, -1) == -1);
	ENSURE(menor(5, 5) == 5);
}

static void getRandomNumberTest() {
	cabecalho("getRandomNumberTest()");

	int i;
	int numSorteado;

	int algumNumeroSorteado = 0;
	int algumNumeroSorteadoAlemDoLimite = 0;

	for (i=0; i<1000; i++) {
		numSorteado = getRandomNumber(100);
		if (numSorteado != 0) {
			algumNumeroSorteado++;
		}
		if (numSorteado > 100) {
			algumNumeroSorteadoAlemDoLimite++;
		}
	}

	ENSURE(algumNumeroSorteado >= 0);
	ENSURE(algumNumeroSorteadoAlemDoLimite == 0);
}

static void getRandomNumberMinMaxTest() {
	cabecalho("getRandomNumberMinMaxTest()");

	int i;
	int numSorteado;
	int limiteMin = 10, limiteMax = 100;

	int algumNumeroSorteado = 0;
	int algumNumeroSorteadoAlemDoLimiteMaximo = 0;
	int algumNumeroSorteadoAntesDoLimiteMinimo = 0;

	for (i=0; i<1000; i++) {
		numSorteado = getRandomNumberMinMax(limiteMin, limiteMax);

		if (numSorteado != 0) {
			algumNumeroSorteado++;
		}
		if (numSorteado > limiteMax) {
			algumNumeroSorteadoAlemDoLimiteMaximo++;
		}
		if (numSorteado < limiteMin) {
			algumNumeroSorteadoAntesDoLimiteMinimo++;
		}
	}

	ENSURE(algumNumeroSorteado >= 0);
	ENSURE(algumNumeroSorteadoAlemDoLimiteMaximo == 0);
	ENSURE(algumNumeroSorteadoAntesDoLimiteMinimo == 0);
}

void matematica_test() {

	matematica_inicializeLib();

	thc_addtest(menorTest);
	thc_addtest(getRandomNumberTest);
	thc_addtest(getRandomNumberMinMaxTest);
}
