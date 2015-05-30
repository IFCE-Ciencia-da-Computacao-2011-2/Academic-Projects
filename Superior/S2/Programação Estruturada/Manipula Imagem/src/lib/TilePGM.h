#ifndef _TilePGM_
#define _TilePGM_

#include "ImagemPGM.h"


/** TilePGM � uma parte da imagem que come�a de (x, y)
 *   e termina em (xSize, ySize)
 *
 *  Se x+xTam for maior que imagem->headMapaBits->biHeight
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
 * @param *image: Endere�o da imagemBMP do qual o tile pertence
 */
typedef struct {
	unsigned int x;
	unsigned int y;
	unsigned int xEnd;
	unsigned int yEnd;
	unsigned int xSize;
	unsigned int ySize;

	ImagemPGM * image;
} TilePGM;

static const TilePGM EmptyTilePGM = {0, 0, 0, 0, 0, 0, NULL};

/** Sinalizar SUCESSO ou ERRO em algum tipo de Opera��o realizada nesta biblioteca
 */
#define TILE_SUCESSO 1
#define TILE_ERRO 0

extern int             tile_constructor   (TilePGM *tile, ImagemPGM *image, int x, int y, int xEnd, int yEnd);
extern void            tile_destroy       (TilePGM *tile);

extern unsigned char * tile_getPixel      (TilePGM *tile, int x, int y);

extern void            tile_copiar        (TilePGM * const original, TilePGM * const copia);

extern void            tile_gerarImagemPGM(TilePGM *tile, ImagemPGM *image);
extern TilePGM         tile_buscarSubimagem(ImagemPGM * imagem, ImagemPGM * subimagem);

extern void            tile_marcarBorda(TilePGM * const tile);

extern unsigned int    tile_isEmpty       (const TilePGM * const tile);
extern void            tile_toString      (TilePGM * const tile);

#endif
