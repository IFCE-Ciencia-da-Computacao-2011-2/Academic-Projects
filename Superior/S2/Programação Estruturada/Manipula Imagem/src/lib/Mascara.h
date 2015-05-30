#ifndef _Mascara_
#define _Mascara_

#include "MatrizBidimensional.h"


/** Mascara � uma parte da imagem que come�a de (x, y)
 *   e termina em (xSize, ySize)
 *
 *  Se x+xTam for maior que matriz->totalColunas
 *   (ou o equivalente em y), a imagem vai at� o �ltimo pixel
 *   e tanto xEnd quanto yEnd s�o atualizados
 *
 * @param x: Posi��o inicial da imagem no eixo x
 * @param y: Posi��o inicial da imagem no eixo y
 * @param xEnd: Posi��o final da imagem no eixo x
 * @param yEnd: Posi��o final da imagem no eixo y
 * @param xSize: Total de colunas. x-xEnd. Usado para percorrer os pixels com um 'for'
 * @param ySize: Total de linha.   y-yEnd. Usado para percorrer os pixels com um 'for'
 *
 * @param *matriz: Endere�o da MatrizBi do qual a m�scara pertence
 *
 * A M�scara para uma MatrizBi tem a mesma rela��o
 * de uma ImagePGM para um Tile
 */
typedef struct {
	unsigned int x;
	unsigned int y;
	unsigned int xEnd;
	unsigned int yEnd;
	unsigned int xSize;
	unsigned int ySize;

	MatrizBi * matriz;
} Mascara;

static const Mascara EmptyMascara = {0, 0, 0, 0, 0, 0, NULL};

/** Sinalizar SUCESSO ou ERRO em algum tipo de Opera��o realizada nesta biblioteca
 */
#define MASK_SUCESSO 1
#define MASK_ERRO 0

extern int             mascara_constructor(Mascara * mascara, MatrizBi * const matriz, int x, int y, int xEnd, int yEnd);
extern void            mascara_destroy    (Mascara *mascara);
extern unsigned char * mascara_getPixel   (const Mascara * const mascara, int x, int y);
extern void            mascara_copiar     (Mascara * const original, Mascara * const copia);
extern unsigned int    mascara_getMedia   (const Mascara * const mascara);
extern unsigned int    mascara_isEmpty    (const Mascara * const mascara);
extern void            mascara_toString   (const Mascara * const mascara);

#endif
