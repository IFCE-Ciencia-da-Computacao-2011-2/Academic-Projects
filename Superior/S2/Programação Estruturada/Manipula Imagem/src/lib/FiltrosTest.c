#include "tests/tests_utils.h"
#include "tests/thc.h"
#include "Filtros.h"
#include "MatrizBidimensional.h"
#include "ImagemPGM.h"
#include "FiltrosTest.h"


static void filtro_matrizByMediaTest() {
	cabecalho("filtro_imagemByMediaTest()");

	MatrizBi matriz = EmptyMatrizBi, filtrada = EmptyMatrizBi;
	int linha = 4;
	int coluna = 6;
	int sizeBorda = 1;

	matriz_constructor(&matriz, linha, coluna, sizeof(char));
	matriz_popularSequencialmente(&matriz);
	printf("Matriz\n");
	matriz_toString(&matriz);

	printf("Filtro Média com janela = %d\n", sizeBorda*2+1);
	filtro_matrizByMedia(&matriz, &filtrada, sizeBorda);
	printf("Matriz Filtrada\n");
	matriz_toString(&filtrada);

	int media = (7+6+7 + 1+0+1 + 7+6+7)/9;
	ENSURE(matriz_getElemento(&filtrada, 0, 0) == media);
	media = (8+9+10 + 14+15+16 + 20+21+22)/9;
	ENSURE(matriz_getElemento(&filtrada, 2, 3) == media);
	media = (12+13+14 + 18+19+20 + 12+13+14)/9;
	ENSURE(matriz_getElemento(&filtrada, 3, 1) == media);
	media = (16+17+16 + 22+23+22 + 16+17+16)/9;
	ENSURE(matriz_getElemento(&filtrada, 3, 5) == media);
}

/****************************************
 * Main - Para fins de teste
 ****************************************/
//void tile_toStringTest() {

void filtros_test() {
	thc_addtest(filtro_matrizByMediaTest);
}
