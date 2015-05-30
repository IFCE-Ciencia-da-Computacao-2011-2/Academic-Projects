#ifndef _MatrizBi_
#define _MatrizBi_

#include <stdlib.h>

/**Métodos para manipulação de Matrizes Bidimensionais
 * de inteiros. 
 */

/** MatrizBidimensional
 *
 * Para mais detalhes, ver javadoc do matriz_constructor()
 * 
 * @param ponteiro: Ponteiro para a matriz mesmo
 * @param sizeElemento: Tamanho (em bytes) do ponteiro
 * @param totalLinhas: Total de linhas da Matriz
 * @param totalColunas: Total de colunas da Matriz
 */
typedef struct {
    unsigned char * ponteiro;
	unsigned int sizeElemento;
	unsigned int totalLinhas;
	unsigned int totalColunas;
} MatrizBi;

static const MatrizBi EmptyMatrizBi = {NULL, 0, 0, 0};

extern void    matriz_constructor(MatrizBi * matriz, unsigned int totalLinhas, unsigned int totalColunas, unsigned int sizeElemento);
extern void    matriz_destroy(MatrizBi * matriz);

extern void    matriz_popularRandom(const MatrizBi * const matriz, int numeroMaximo);
extern void    matriz_popularSequencialmente(const MatrizBi * const matriz);

extern void    matriz_gerarTransposta(const MatrizBi * const matriz, MatrizBi * const transposta);
extern void    matriz_gerarEspelho(MatrizBi * const matriz, MatrizBi * matrizEspelho, unsigned int sizeEspelhamento);
extern void    matriz_gerarByFiltroMedia(MatrizBi * const matriz, MatrizBi * const matrizFiltrada, unsigned int tamanhoBorda);

extern unsigned char     matriz_getElemento(const MatrizBi * const matriz, unsigned int linha, unsigned int coluna);
extern unsigned char *   matriz_getElementoAddress(const MatrizBi * const matriz, unsigned int linha, unsigned int coluna);

extern unsigned int matriz_isEmpty(const MatrizBi * const matriz);

extern void    matriz_toString(const MatrizBi * const matriz);

#endif
