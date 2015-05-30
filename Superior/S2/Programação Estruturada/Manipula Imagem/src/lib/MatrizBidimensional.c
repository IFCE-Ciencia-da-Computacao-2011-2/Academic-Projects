#include <stdio.h>
#include <stdlib.h>
#include "MatrizBidimensional.h"
#include "Mascara.h"
#include "utils/Matematica.h"
#include "utils/Get.h"

/****************************************
 * Alocação
 ****************************************/

/** Inicializa devidamente a 'matriz' de elementos MxN passada como referência
 * M = Total de linhas
 * N = Total de colunas
 * 
 * Exemplo: "Matriz de inteiros 5 por 7"
 *
 * @param matriz:
 * @param totalLinhas:  Quantidade de linhas que a matriz possui
 * @param totalColunas: Quantidade de colunas que a matriz possui
 * @param sizeElemento: Tamanho do tipo da Matriz (sizeof(char))
 */
void matriz_constructor(MatrizBi * matriz, unsigned int totalLinhas, unsigned int totalColunas, unsigned int sizeElemento) {
	matriz->sizeElemento = sizeElemento;
	matriz->totalLinhas  = totalLinhas;
	matriz->totalColunas = totalColunas;

	matriz->ponteiro = (unsigned char *) calloc(totalLinhas*totalColunas, sizeElemento);
}


/* Libera a memória da 'matriz'
 */
void matriz_destroy(MatrizBi * matriz) {
	if (matriz->ponteiro != NULL) {
		free(matriz->ponteiro);
	}
	*matriz = EmptyMatrizBi;
}


/****************************************
 * ?
 ****************************************/
unsigned char matriz_getElemento(const MatrizBi * const matriz, unsigned int linha, unsigned int coluna) {
	unsigned char * retorno = matriz_getElementoAddress(matriz, linha, coluna);
	if (retorno == NULL) {
		char msgErro[100], msgErroTemplate[] = "ACESSANDO UM ELEMENTO DE POSIÇÃO INEXISTENTE: (%d, %d)\n";
		sprintf(msgErro, msgErroTemplate, linha, coluna);
		print_error(msgErro);
		return 0;
	}
	return *retorno;
}
/** Retorna o endereço do elemento da 'matriz' com a 'linha' e 'coluna' dada
 */
unsigned char * matriz_getElementoAddress(const MatrizBi * const matriz, unsigned int linha, unsigned int coluna) {
    if (linha >= matriz->totalLinhas || coluna >= matriz->totalColunas) {
    	return NULL;
    }
    return &matriz->ponteiro[linha*matriz->totalColunas + coluna];
}

/****************************************
 * População
 ****************************************/

/** Popula a matriz com valores (INTEIROS) randômicos
 * que variam de 0 até 'numeroMaximo'
 */
void matriz_popularRandom(const MatrizBi * const matriz, int numeroMaximo) {
    int max = matriz->totalLinhas*matriz->totalColunas;
    int i;

    for (i=0; i<max; i++) {
        matriz->ponteiro[i] = getRandomNumber(numeroMaximo);
    }
}
/** Popula a matriz com valores (INTEIROS) sequencialmente. De 0 até size(matriz) */
void matriz_popularSequencialmente(const MatrizBi * const matriz) {
    int max = matriz->totalLinhas*matriz->totalColunas;
    int i;

    for (i=0; i<max; i++) {
        matriz->ponteiro[i] = i;
    }
}

/****************************************
 * Manipulacao
 ****************************************/
/** Popula a 'transposta' de tal modo que ela vira a transposta da 'matriz'
 */
void matriz_gerarTransposta(const MatrizBi * const matriz, MatrizBi * const transposta) {
	matriz_constructor(transposta, matriz->totalColunas, matriz->totalLinhas, matriz->sizeElemento);

    int i, j;

	unsigned char * elemMatriz = NULL;
	unsigned char * elemTransposta = NULL;

    for (i=0; i<matriz->totalLinhas; i++) {
        for (j=0; j<matriz->totalColunas; j++) {
            elemMatriz = matriz_getElementoAddress(matriz, i, j);
            elemTransposta = matriz_getElementoAddress(transposta, j, i);

            *elemTransposta = *elemMatriz;
        }
    }
}

// TODO - Considerar passar o algoritmo de espelhamento para outro arquivo
static void matriz_espelharMatrizNoCentro(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento);
static void matriz_espelharColunas(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento);
static void matriz_espelharColuna(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento, unsigned int colunaDaMatriz, unsigned int colunaDaEspelho);
static void matriz_espelharLinhas(MatrizBi * matrizEspelho, unsigned int sizeEspelhamento);
static void matriz_espelharLinha(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int linhaDaMatriz, unsigned int linhaDaEspelho);

/** Espelha as bordas da matriz com o tamanho 'sizeEspelhamento'
 *  dado
 *
 * @param matriz Matriz a ser espelhada
 * @param matrizEspelho O espelhamento gerado por esta função será jogado nesta matriz.
 * 						NÃO INICIALIZE matrizEspelho (matriz_constructor)
 * @param sizeEspelhamento Tamanho do espelhamento da imagem inserida nas bordas
 *
 * OBS: matrizEspelho não deve ser inicializada (inserida em matriz_constructor).
 * Esta função fará este trabalho.
 */
void matriz_gerarEspelho(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento) {
	int linhas = matriz->totalLinhas+sizeEspelhamento*2;
	int colunas = matriz->totalColunas+sizeEspelhamento*2;
	matriz_constructor(matrizEspelho, linhas, colunas, matriz->sizeElemento);

	matriz_espelharMatrizNoCentro(matriz, matrizEspelho, sizeEspelhamento);

	// Espelhar bordas
	matriz_espelharColunas(matriz, matrizEspelho, sizeEspelhamento);
	matriz_espelharLinhas(matrizEspelho, sizeEspelhamento);
}

static void matriz_espelharMatrizNoCentro(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento) {
	Mascara maskMatriz = EmptyMascara, maskEspelho = EmptyMascara;
	mascara_constructor(&maskMatriz, matriz, 0, 0, matriz->totalColunas, matriz->totalLinhas);
	mascara_constructor(&maskEspelho, matrizEspelho, sizeEspelhamento, sizeEspelhamento, matriz->totalColunas+sizeEspelhamento, matriz->totalLinhas+sizeEspelhamento);

	// Copiar matriz
	mascara_copiar(&maskMatriz, &maskEspelho);

	mascara_destroy(&maskMatriz);
	mascara_destroy(&maskEspelho);
}

static void matriz_espelharColunas(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento) {
	unsigned int colunaDaMatriz, colunaDaEspelho;
	int i;
	for (i=0; i<sizeEspelhamento; i++) {
		colunaDaMatriz = i+1;
		colunaDaEspelho = sizeEspelhamento-i-1;
		matriz_espelharColuna(matriz, matrizEspelho, sizeEspelhamento, colunaDaMatriz, colunaDaEspelho);

		colunaDaMatriz = matriz->totalColunas-2-i;
		colunaDaEspelho = matriz->totalColunas+i+sizeEspelhamento;
		matriz_espelharColuna(matriz, matrizEspelho, sizeEspelhamento, colunaDaMatriz, colunaDaEspelho);
	}
}

static void matriz_espelharColuna(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento, unsigned int colunaDaMatriz, unsigned int colunaDaEspelho) {
	Mascara maskLinha = EmptyMascara, maskLinhaEspelho = EmptyMascara;

	mascara_constructor(
		&maskLinha, matriz,
		colunaDaMatriz, 0,
		colunaDaMatriz+1, matriz->totalLinhas
	);
	mascara_constructor(
		&maskLinhaEspelho, matrizEspelho,
		colunaDaEspelho, sizeEspelhamento,
		colunaDaEspelho+1, matriz->totalLinhas+sizeEspelhamento
	);

	mascara_copiar(&maskLinha, &maskLinhaEspelho);

	mascara_destroy(&maskLinha);
	mascara_destroy(&maskLinhaEspelho);
}



static void matriz_espelharLinhas(MatrizBi * matrizEspelho, unsigned int sizeEspelhamento) {
	unsigned int linhaDaMatriz, linhaDaEspelho;
	int i;
	for (i=0; i<sizeEspelhamento; i++) {
		linhaDaMatriz = sizeEspelhamento+i+1;
		linhaDaEspelho = sizeEspelhamento-i-1;
		matriz_espelharLinha(matrizEspelho, matrizEspelho, linhaDaMatriz, linhaDaEspelho);

		linhaDaMatriz = matrizEspelho->totalLinhas-sizeEspelhamento-i-2;
		linhaDaEspelho = matrizEspelho->totalLinhas-sizeEspelhamento+i;
		matriz_espelharLinha(matrizEspelho, matrizEspelho, linhaDaMatriz, linhaDaEspelho);
	}
}

static void matriz_espelharLinha(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int linhaDaMatriz, unsigned int linhaDaEspelho) {
	Mascara maskLinha = EmptyMascara, maskLinhaEspelho = EmptyMascara;

	mascara_constructor(
		&maskLinha, matriz,
		0, linhaDaMatriz,
		matriz->totalColunas, linhaDaMatriz+1
	);
	mascara_constructor(
		&maskLinhaEspelho, matrizEspelho,
		0, linhaDaEspelho,
		matrizEspelho->totalColunas, linhaDaEspelho+1
	);

	mascara_copiar(&maskLinha, &maskLinhaEspelho);

	mascara_destroy(&maskLinha);
	mascara_destroy(&maskLinhaEspelho);
}


/****************************************
 * Verificar se está preenchida
 ****************************************/
unsigned int matriz_isEmpty(const MatrizBi * const matriz) {
	return matriz->ponteiro     == EmptyMatrizBi.ponteiro &&
		   matriz->sizeElemento == EmptyMatrizBi.sizeElemento &&
		   matriz->totalColunas == EmptyMatrizBi.totalColunas &&
		   matriz->totalLinhas  == EmptyMatrizBi.totalLinhas;
}

/****************************************
 * Utilitários
 ****************************************/
/** Imprimir matriz */
void matriz_toString(const MatrizBi * const matriz) {
    printf("Matriz %dx%d:\n", matriz->totalColunas, matriz->totalLinhas);

    int i, j;
    printf("    |");
    for (j = 0; j<matriz->totalColunas; j++) {
    	printf("% 5d", j);
    }
    printf("\n-----");
    for (j = 0; j<matriz->totalColunas; j++) {
		printf("-----");
	}
    printf("\n");

    for (i = 0; i<matriz->totalLinhas; i++) {
    	printf("%3d |", i);

	    for (j = 0; j<matriz->totalColunas; j++) {
            printf("% 5d", matriz_getElemento(matriz, i, j));
        }
        printf("\n");
    }
}
