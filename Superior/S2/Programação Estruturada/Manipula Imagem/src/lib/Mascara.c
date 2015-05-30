#include <stdio.h>
#include <stdlib.h>
#include "MatrizBidimensional.h"
#include "Mascara.h"
#include "utils/Matematica.h"

/****************************************
 * Gerenciamento de memória
****************************************/
/** Mascara é uma parte de uma MatrizBi que começa de (x, y)
 *   e termina em (xSize, ySize)
 *
 *  Se x+xTam for maior que matriz->totalColunas
 *   (ou o equivalente em y), a imagem vai até o último pixel
 *   e tanto xEnd quanto yEnd são atualizados
 *
 * @param *mascara: Endereço da máscara que será inicializada
 * @param *matriz: Endereço da matriz que será inicializada
 *
 * @param x: Posição inicial da imagem no eixo x
 * @param y: Posição inicial da imagem no eixo y
 * @param xEnd: Posição final da imagem no eixo x
 * @param yEnd: Posição final da imagem no eixo y
 *
 * @return MASK_ERRO, caso algum dado tenha sido dado errado
 * 		   MASK_SUCESSO, caso o processo tenha sido bem sucedidos
 *
 * FIXME - Caso os tamanhos (nEnd) tenhas transpassado a imagem,
 * será considerado o final. Isto está certo?
 */
int mascara_constructor(Mascara * mascara, MatrizBi * const matriz, int x, int y, int xEnd, int yEnd) {
	if (x >= matriz->totalColunas ||
		y >= matriz->totalLinhas ||
		//xEnd >= matriz->totalColunas ||
		//yEnd >= matriz->totalLinhas ||
		x >= xEnd ||
		y >= yEnd) {

		return MASK_ERRO;
	}

	if (xEnd > matriz->totalColunas) {
		xEnd = matriz->totalColunas;
	}
	if (yEnd > matriz->totalLinhas) {
		yEnd = matriz->totalLinhas;
	}

	mascara->x = x;
	mascara->y = y;

	mascara->xEnd = xEnd;
	mascara->yEnd = yEnd;

	mascara->xSize = xEnd-x;
	mascara->ySize = yEnd-y;

	mascara->matriz = matriz;

	return MASK_SUCESSO;
}


void mascara_destroy(Mascara *mascara) {
	*mascara = EmptyMascara;
}


/****************************************
 * Acesso
****************************************/

/* Retorna o endereço de um elemento da matriz requisitado
 *
 * @param mascara Mascara a ser pego o pixel
 * @param x (coluna) Posição x no plano cartesiano
 * @param y (linha)  Posição y no plano cartesiano
 *
 * @return Endereço do pixel com a posição dada
 */
unsigned char * mascara_getPixel(const Mascara * const mascara, int x, int y) {
	// Calcular x e y real
	int xReal = mascara->x + x;
	int yReal = mascara->y + y;

	// Retornar endereço
	return matriz_getElementoAddress(&*mascara->matriz, yReal, xReal);
}


/** Copia os pixels de 'original' para a 'copia'
 */
void mascara_copiar(Mascara * const original, Mascara * const copia) {
	int xSize = menor(original->xSize, copia->xSize);
	int ySize = menor(original->ySize, copia->ySize);

	int x, y;
	for (y = 0; y < ySize; y++) {
		for (x = 0; x < xSize; x++) {
			*mascara_getPixel(copia, x, y) = *mascara_getPixel(original, x, y);
		}
	}
}

/** Retorna a média dos elementos da 'mascara'
 */
// FIXME - Adicionar teste
unsigned int mascara_getMedia(const Mascara * const mascara) {
	unsigned int total = 0;

	unsigned int x, y;
	for (x=0; x<mascara->xSize; x++) {
		for (y=0; y<mascara->ySize; y++) {
			total += *mascara_getPixel(mascara, x, y);
		}
	}

	return total / (mascara->xSize * mascara->ySize);
}
/****************************************
 * Salvar
****************************************/

/****************************************
 * Verificar se está preenchida
 ****************************************/
unsigned int mascara_isEmpty(const Mascara * const mascara) {
	return mascara->matriz == EmptyMascara.matriz &&
		   mascara->x      == EmptyMascara.x &&
		   mascara->xEnd   == EmptyMascara.xEnd &&
		   mascara->xSize  == EmptyMascara.xSize &&
		   mascara->y      == EmptyMascara.y &&
		   mascara->yEnd   == EmptyMascara.yEnd &&
		   mascara->ySize  == EmptyMascara.ySize;
}

/****************************************
 * Main - Para fins de teste
 ****************************************/
void mascara_toString(const Mascara * const mascara) {
	printf("\n");
	printf("+------------------------------+\n");
	printf("|   Informações da máscara     |\n");
	printf("+------------------------------+\n\n");

	if (mascara_isEmpty(mascara)) {
		printf("Máscara está vazia\n");
		return;
	}

	printf("x: %u\n", mascara->x);
	printf("y: %u\n", mascara->y);
	printf("xEnd: %u\n", mascara->xEnd);
	printf("yEnd: %u\n", mascara->yEnd);
	printf("xSize: %u\n", mascara->xSize);
	printf("ySize: %u\n", mascara->ySize);

	printf("\n");
	printf("Representação visual:\n");

    int i, j;
    printf("    |");
    for (j = 0; j<mascara->xSize; j++) {
    	printf("% 5d", j+mascara->x);
    }
    printf("\n-----");
    for (j = 0; j<mascara->xSize; j++) {
		printf("-----");
	}
    printf("\n");

	for (j=0; j<mascara->ySize; j++) {
    	printf("%3d |", j+mascara->y);

		for (i=0; i<mascara->xSize; i++) {
			printf("%5d", *mascara_getPixel(mascara, i, j));
		}
		printf("\n");
	}
}
