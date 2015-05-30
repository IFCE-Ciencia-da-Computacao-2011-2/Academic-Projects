#include <stdio.h>
#include "MatrizBidimensional.h"
#include "tests/tests_utils.h"
#include "tests/thc.h"

/** Testes relacionados a MatrizBidimensional.h
 */

/****************************************
 * Alocação
 ****************************************/
static void matriz_constructorTest() {
	cabecalho("matriz_constructorTest()");

	MatrizBi matriz = EmptyMatrizBi;
	matriz_constructor(&matriz, 100, 10, sizeof(char));
	ENSURE(!matriz_isEmpty(&matriz));
	ENSURE(matriz.ponteiro != NULL);
	ENSURE(matriz.sizeElemento == sizeof(char));
	ENSURE(matriz.totalColunas == 10);
	ENSURE(matriz.totalLinhas == 100);
}

static void matriz_destroyTest() {
	cabecalho("matriz_destroyTest()");

	MatrizBi matriz = EmptyMatrizBi;
	matriz_destroy(&matriz);
	ENSURE(matriz_isEmpty(&matriz));

	matriz_constructor(&matriz, 100, 10, sizeof(char));
	matriz_destroy(&matriz);
	ENSURE(matriz_isEmpty(&matriz));
}


/****************************************
 * ?
 ****************************************/
static void matriz_getElementoTest() {
	cabecalho("matriz_getElementoTest()");

	MatrizBi matriz = EmptyMatrizBi;
	matriz_constructor(&matriz, 10, 10, sizeof(char));

	ENSURE(matriz_getElemento(&matriz, 0, 0) == 0);
	ENSURE(matriz_getElemento(&matriz, 5, 3) == 0);
	ENSURE(matriz_getElemento(&matriz, 11, 11) == 0);
	ENSURE(matriz_getElemento(&matriz, -1, -1) == 0);
	ENSURE(matriz_getElemento(&matriz, -11, -11) == 0);
}

static void matriz_getElementoAddressTest() {
	cabecalho("matriz_getElementoAddressTest()");

	MatrizBi matriz = EmptyMatrizBi;
	matriz_constructor(&matriz, 10, 10, sizeof(char));

	ENSURE(matriz_getElementoAddress(&matriz, 0, 0) != NULL);
	ENSURE(matriz_getElementoAddress(&matriz, 5, 3) != NULL);
	ENSURE(matriz_getElementoAddress(&matriz, 0, 10) == NULL);
	ENSURE(matriz_getElementoAddress(&matriz, 10, 10) == NULL);
	ENSURE(matriz_getElementoAddress(&matriz, 11, 11) == NULL);
	ENSURE(matriz_getElementoAddress(&matriz, -1, -1) == NULL);
	ENSURE(matriz_getElementoAddress(&matriz, -11, -11) == NULL);
}

/****************************************
 * População
 ****************************************/
static void matriz_popularRandomTest() {
	cabecalho("matriz_popularRandomTest()");

	unsigned int numeroMaximo = 99;
	MatrizBi matriz = EmptyMatrizBi;
	matriz_constructor(&matriz, 1000, 1000, sizeof(char));
	matriz_popularRandom(&matriz, numeroMaximo);

	int numElementosDiferenteDeZero = 0;
	int algumNumeroMaximo = 0;
	int algumNumeroSuperiorAoMaximo = 0;
	int algumNumeroInferiorAZezo = 0;

	int i, j;
	for (i = 0; i < matriz.totalLinhas; i++) {
		for (j = 0; i < matriz.totalLinhas; i++) {
			if (matriz_getElemento(&matriz, i, j) != 0) {
				numElementosDiferenteDeZero++;
			}
			if (matriz_getElemento(&matriz, i, j) == numeroMaximo) {
				algumNumeroMaximo++;
			}
			if (matriz_getElemento(&matriz, i, j) > numeroMaximo) {
				algumNumeroSuperiorAoMaximo++;
			}
			if (matriz_getElemento(&matriz, i, j) > numeroMaximo) {
				algumNumeroInferiorAZezo++;
			}
		}
	}

	ENSURE(numElementosDiferenteDeZero > 0);
	ENSURE(algumNumeroMaximo > 0);
	ENSURE(algumNumeroSuperiorAoMaximo == 0);
	ENSURE(algumNumeroInferiorAZezo == 0);
}

static void matriz_popularSequencialmenteTest() {
	cabecalho("matriz_popularSequencialmenteTest()");

	MatrizBi matriz = EmptyMatrizBi;
	matriz_constructor(&matriz, 10, 10, sizeof(char));
	matriz_popularSequencialmente(&matriz);

	int contador = 0;
	int populadoSequencialmente = 1;

	int i, j;
	for (i = 0; i < matriz.totalLinhas; i++) {
		for (j = 0; j < matriz.totalLinhas; j++) {
			if (matriz_getElemento(&matriz, i, j) != contador) {
				populadoSequencialmente = 0;
				break;
			}
			contador++;
		}
		if (!populadoSequencialmente) {
			break;
		}
	}
	ENSURE(populadoSequencialmente);
}


/****************************************
 * Manipulacao
 ****************************************/
static void matriz_gerarTranspostaTest() {
	cabecalho("matriz_gerarTranspostaTest()");

	MatrizBi matriz = EmptyMatrizBi, transposta = EmptyMatrizBi;
	int linha = 4;
	int coluna = 6;

	matriz_constructor(&matriz, linha, coluna, sizeof(char));
	matriz_popularSequencialmente(&matriz);
	matriz_toString(&matriz);

	matriz_gerarTransposta(&matriz, &transposta);
	matriz_toString(&transposta);

	ENSURE(matriz_getElemento(&matriz, 0, 0) == matriz_getElemento(&transposta, 0, 0));
	ENSURE(matriz_getElemento(&matriz, 3, 5) == matriz_getElemento(&transposta, 5, 3));
	ENSURE(matriz_getElemento(&matriz, 2, 5) == matriz_getElemento(&transposta, 5, 2));

	matriz_destroy(&matriz);
}

static void matriz_gerarEspelhoTest() {
	cabecalho("matriz_gerarEspelhoTest()");

	MatrizBi matriz = EmptyMatrizBi, espelho = EmptyMatrizBi;
	int linha = 4;
	int coluna = 6;
	int sizeEspelho = 2;

	matriz_constructor(&matriz, linha, coluna, sizeof(char));
	matriz_popularSequencialmente(&matriz);
	matriz_toString(&matriz);

	printf("Espelhamento com sizeEspelhamento = %d\n", sizeEspelho);
	matriz_gerarEspelho(&matriz, &espelho, sizeEspelho);
	matriz_toString(&espelho);

	ENSURE(matriz_getElemento(&matriz, 0, 0) == matriz_getElemento(&espelho, sizeEspelho, sizeEspelho));
	ENSURE(matriz_getElemento(&matriz, 1, 1) == matriz_getElemento(&espelho, sizeEspelho+1, sizeEspelho-1));
	ENSURE(matriz_getElemento(&matriz, 1, 1) == matriz_getElemento(&espelho, sizeEspelho-1, sizeEspelho-1));
}

/****************************************
 * Verificar se está preenchida
 ****************************************/
static void matriz_isEmptyTest() {
	cabecalho("matriz_isEmptyTest()");

	MatrizBi matriz;

	printf("Matriz instanciada agora está vazia?\n");
	ENSURE(!matriz_isEmpty(&matriz));

	printf("Matriz criada agora está vazia?\n");
	matriz_constructor(&matriz, 5, 5, sizeof(char));
	ENSURE(!matriz_isEmpty(&matriz));

	printf("Matriz destruída está vazia?\n");
	matriz_destroy(&matriz);
	ENSURE(matriz_isEmpty(&matriz));
}

/****************************************
 * Utilitários
 ****************************************/
/** Imprimir matriz */
//void matriz_toStringTest(MatrizBi const * const matriz) {

void matriz_test() {
	//cabecalho("matriz_test()");

	thc_addtest(matriz_constructorTest);

	thc_addtest(matriz_destroyTest);
	thc_addtest(matriz_getElementoTest);
	thc_addtest(matriz_getElementoAddressTest);

	thc_addtest(matriz_popularRandomTest);
	thc_addtest(matriz_popularSequencialmenteTest);

	thc_addtest(matriz_gerarTranspostaTest);
	thc_addtest(matriz_gerarEspelhoTest);

	thc_addtest(matriz_isEmptyTest);
}
