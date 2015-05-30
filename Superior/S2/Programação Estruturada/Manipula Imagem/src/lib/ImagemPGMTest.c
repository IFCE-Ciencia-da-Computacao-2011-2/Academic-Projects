#include <stdio.h>
#include <stdlib.h>
#include "ImagemPGMTest.h"
#include "tests/tests_utils.h"
#include "tests/thc.h"

/****************************************
 * Alocação
 ****************************************/

static void imagem_constructorTest() {

}

/* Desloca da memória a paleta
 */
static void imagem_destroyTest() {

}


/****************************************
 * Processamento da imagem
 ****************************************/
static void imagem_readTest() {

}

/****************************************
 * Processamento da imagem - Salvar
 **************************************** /
// TODO - Implementar
//static void salvarImagemTest() {

}


/ ****************************************
 * Processamento da imagem - Obtendo dados
 ****************************************/
static void imagem_getPixelTest() {

}


/****************************************
 * Main
 ****************************************/

void imagem_test() {

	thc_addtest(imagem_constructorTest);
	thc_addtest(imagem_destroyTest);
	thc_addtest(imagem_readTest);

	//thc_addtest(salvarImagemTest);
	thc_addtest(imagem_getPixelTest);
}
