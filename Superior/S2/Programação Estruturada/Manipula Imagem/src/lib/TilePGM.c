#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "ImagemPGM.h"
#include "TilePGM.h"
#include "utils/Matematica.h"

static float tile_coeficienteDeDiferenca(TilePGM * tile1, TilePGM * tile2);
static float tile_coeficienteDeDiferencaSlow(TilePGM * tile1, TilePGM * tile2);
static int tile_mesmasDimensoes(TilePGM * tile1, TilePGM * tile2);

/****************************************
 * Gerenciamento de memória
****************************************/
/** TilePGM é uma parte da imagem que começa de (x, y)
 *   e termina em (xSize, ySize)
 *
 *  Se x+xTam for maior que imagem->headMapaBits->biHeight
 *   (ou o equivalente em y), a imagem vai até o último pixel
 *   e tanto xEnd quanto yEnd são atualizados
 *
 * @param *tile: Endereço do tile que será inicializado
 * @param *image: Endereço da imagemBMP do qual o tile pertence
 *
 * @param x: Posição inicial da imagem no eixo x
 * @param y: Posição inicial da imagem no eixo y
 * @param xEnd: Posição final da imagem no eixo x
 * @param yEnd: Posição final da imagem no eixo y
 *
 * @return TILE_ERRO, caso algum dado tenha sido dado errado
 * 		   TILE_SUCESSO, caso o processo tenha sido bem sucedidos
 *
 * FIXME - Caso os tamanhos (nEnd) tenhas transpassado a imagem,
 * será considerado o final. Isto está certo?
 */
int tile_constructor(TilePGM *tile, ImagemPGM *image, int x, int y, int xEnd, int yEnd) {
	if (x >= image->headArquivo.width ||
		y >= image->headArquivo.height ||
		//xEnd >= image->headArquivo.width ||
		//yEnd >= image->headArquivo.height ||
		x >= xEnd ||
		y >= yEnd) {

		return TILE_ERRO;
	}

	if (xEnd > image->headArquivo.width) {
		xEnd = image->headArquivo.width;
	}
	if (yEnd > image->headArquivo.height) {
		yEnd = image->headArquivo.height;
	}

	tile->x = x;
	tile->y = y;

	tile->xEnd = xEnd;
	tile->yEnd = yEnd;

	tile->xSize = xEnd-x;
	tile->ySize = yEnd-y;

	tile->image = image;

	return TILE_SUCESSO;
}


void tile_destroy(TilePGM *tile) {
	*tile = EmptyTilePGM;
}


/****************************************
 * Acesso
****************************************/

/* Retorna o endereço do pixel requisitado
 *
 * @param img Imagem a ser pego o pixel
 * @param x (coluna) Posição x no plano cartesiano
 * @param y (linha)  Posição y no plano cartesiano
 *
 * @return Endereço do pixel com a posição dada
 */
unsigned char * tile_getPixel(TilePGM *tile, int x, int y) {
	int xReal, yReal;

	// Calcular x e y real
	xReal = tile->x + x;
	yReal = tile->y + y;

	// Retornar endereço
	return imagem_getPixel(&*tile->image, xReal, yReal);
}

/** Copia os pixels de 'original' para a 'copia'
 */
void tile_copiar(TilePGM * const original, TilePGM * const copia) {
	int xEnd = menor(original->xEnd, copia->xEnd);
	int yEnd = menor(original->yEnd, copia->yEnd);

	int x, y;
	for (y = 0; y < yEnd; y++) {
		for (x = 0; x < xEnd; x++) {
			*tile_getPixel(copia, x, y) = *tile_getPixel(original, x, y);
		}
	}
}

/****************************************
 * Salvar
****************************************/

/* Gera uma ImagemPGM a partir do tile dado
 *
 * @param tile Tile
 * @parm
 */
void tile_gerarImagemPGM(TilePGM *tile, ImagemPGM *imagem) {
	// CABEÇALHO
	imagem->headArquivo = EmptyHeadArquivo;

	int altura = tile->ySize;
	int largura = tile->xSize;

	imagem->headArquivo.magicalNumber[0] = tile->image->headArquivo.magicalNumber[0];
	imagem->headArquivo.magicalNumber[1] = tile->image->headArquivo.magicalNumber[1];
	imagem->headArquivo.levelsOfGray = tile->image->headArquivo.levelsOfGray;

	imagem->headArquivo.width = largura;
	imagem->headArquivo.height = altura;
	imagem->headArquivo.sizePixel = sizeof(char);

	// CONTEÚDO
	matriz_constructor(&imagem->pixels, altura, largura, sizeof(int));

	int x, y;
	for (x = 0; x < tile->xSize; x++)
		for (y = 0; y < tile->ySize; y++)
			*imagem_getPixel(imagem, x, y) = *tile_getPixel(tile, x, y);
}


/****************************************
 * Manipulação
 ****************************************/

/**
 * Busca na 'imagem' o que mais se o que mais se assemelha
 * com a 'subimagem'.
 *
 * O resultado da busca é inserida em resultado
 *
 * Se alguma dimensão de 'subimagem' for maior que a 'imagem',
 * resultado == EmptyTilePGM.
 * Verifique então se o retorno == tile_isEmpty();
 *
 * @param imagem     Imagem base
 * @param subimagem  Imagem buscada
 * @param resultado  Parâmetro de retorno:
 * 					 Ocorrência que mais
 */
TilePGM tile_buscarSubimagem(ImagemPGM * imagem, ImagemPGM * subimagem) {
	TilePGM resultado = EmptyTilePGM;

	int xMax = imagem->headArquivo.width - subimagem->headArquivo.width;
	int yMax = imagem->headArquivo.height - subimagem->headArquivo.height;

	if (xMax < 0 || yMax < 0) {
		return resultado;
	}

	unsigned int menorCoeficiente = -1;


	TilePGM tileDaBase = EmptyTilePGM;
	TilePGM tileDoBuscado = EmptyTilePGM;
	tile_constructor(&tileDoBuscado, subimagem, 0, 0, subimagem->headArquivo.width, subimagem->headArquivo.height);

	printf("Realizando busca\n");
	int percentagemAtual = 0, novaPercentagem = 0;
	float percentagemMaxima = 1.0*xMax*yMax;
	int posicaoAtual;

	int x, y=0;
	float coeficiente;
	for (y = 0; y < yMax; y++) {
		for (x = 0; x < xMax; x++) {
			// Busca
			tile_constructor(&tileDaBase, imagem, x, y, x+subimagem->headArquivo.width, y+subimagem->headArquivo.height);
			coeficiente = tile_coeficienteDeDiferenca(&tileDaBase, &tileDoBuscado);

			if (coeficiente < menorCoeficiente) {
				menorCoeficiente = coeficiente;
				resultado = tileDaBase;
			}

			// Percentagem
			posicaoAtual = y*xMax + x;
			novaPercentagem = (int) ((posicaoAtual/percentagemMaxima)*100);

			if (novaPercentagem > percentagemAtual) {
				percentagemAtual = novaPercentagem;
				printf("%d de 100\n", percentagemAtual);
			}
		}
	}

	printf("100 de 100\n");

	tile_destroy(&tileDaBase);
	tile_destroy(&tileDoBuscado);

	return resultado;
}


/**
 * Calcula o coeficiente de diferença entre o 'tile1' e o 'tile2'
 *
 * Observe que tanto o 'tile1' quanto o 'tile2' devem possuir
 * o mesmo tamanho (xSize e ySize).
 * Caso isto não ocorra, será retorna do o maior valor possível
 * para um unsigend int.
 */
static float tile_coeficienteDeDiferenca(TilePGM * tile1, TilePGM * tile2) {
	if (!tile_mesmasDimensoes(tile1, tile2))
		return -1;

	register unsigned int somatorio;

	register int x = 0, y;
	register unsigned char *pixelTile1, *pixelTile2;
	for (y = 0; y<tile1->ySize; y++) {
		pixelTile1 = tile_getPixel(tile1, x, y);
		pixelTile2 = tile_getPixel(tile2, x, y);

		for (x=0; x<tile1->xSize; x++) {
			somatorio += abs(*pixelTile1 - *pixelTile2);
			//somatorio += pow(*pixelTile1 - *pixelTile2, 2);
			pixelTile1++;
			pixelTile2++;
		}
		x=0;
	}

	return (somatorio*1.0)/(tile1->xSize*tile1->ySize);
}

static int tile_mesmasDimensoes(TilePGM * tile1, TilePGM * tile2) {
	return tile1->xSize == tile2->xSize &&
		   tile1->ySize == tile2->ySize;
}


/**
 * FORMA MAIS LENTA
 * Calcula o coeficiente de diferença entre o 'tile1' e o 'tile2'
 *
 * Observe que tanto o 'tile1' quanto o 'tile2' devem possuir
 * o mesmo tamanho (xSize e ySize).
 * Caso isto não ocorra, será retorna do o maior valor possível
 * para um unsigend int.
 */
static float tile_coeficienteDeDiferencaSlow(TilePGM * tile1, TilePGM * tile2) {
	if (!tile_mesmasDimensoes(tile1, tile2))
		return -1;

	unsigned int somatorio = 0;

	register int x, y;
	for (y = 0; y<tile1->ySize; y++)
		for (x=0; x<tile1->xSize; x++)
			somatorio += abs(*tile_getPixel(tile1, x, y) - *tile_getPixel(tile2, x, y));

	return (somatorio*1.0)/(tile1->xSize*tile1->ySize);
}

/****************************************
 * Manipulação
 ****************************************/
void tile_marcarBorda(TilePGM * const tile) {
	int i;
	int corBorda = tile->image->headArquivo.levelsOfGray;

	// Cima e baixo
	for (i = 0; i < tile->xSize; i++) {
		*tile_getPixel(tile, i, 0) = corBorda;
	}
	for (i = 0; i < tile->xSize; i++) {
		*tile_getPixel(tile, i, tile->ySize-1) = corBorda;
	}

	// Esquerda e direita
	for (i = 0; i < tile->ySize; i++) {
		*tile_getPixel(tile, 0, i) = corBorda;
	}
	for (i = 0; i < tile->ySize; i++) {
		*tile_getPixel(tile, tile->xSize-1, i) = corBorda;
	}
}

/****************************************
 * Verificar se está preenchida
 ****************************************/
unsigned int tile_isEmpty(const TilePGM * const tile) {
	return tile->image == EmptyTilePGM.image &&
		   tile->x     == EmptyTilePGM.x &&
		   tile->xEnd  == EmptyTilePGM.xEnd &&
		   tile->xSize == EmptyTilePGM.xSize &&
		   tile->y     == EmptyTilePGM.y &&
		   tile->yEnd  == EmptyTilePGM.yEnd &&
		   tile->ySize == EmptyTilePGM.ySize;
}

/****************************************
 * Main - Para fins de teste
 ****************************************/
void tile_toString(TilePGM * const tile) {
	printf("\n");
	printf("+------------------------------+\n");
	printf("|      Informações do tile     |\n");
	printf("+------------------------------+\n\n");

	if (tile_isEmpty(tile)) {
		printf("Tile está vazio\n");
		return;
	}

	printf("x: %u\n", tile->x);
	printf("y: %u\n", tile->y);
	printf("xEnd: %u\n", tile->xEnd);
	printf("yEnd: %u\n", tile->yEnd);
	printf("xSize: %u\n", tile->xSize);
	printf("ySize: %u\n", tile->ySize);

	printf("\n");
	printf("Representação visual:\n");

    int i, j;
    printf("    |");
    for (j = 0; j<tile->xSize; j++) {
    	printf("% 5d", j+tile->x);
    }
    printf("\n-----");
    for (j = 0; j<tile->xSize; j++) {
		printf("-----");
	}
    printf("\n");

	for (j=0; j<tile->ySize; j++) {
    	printf("%3d |", j+tile->y);

		for (i=0; i<tile->xSize; i++) {
			printf("%5d", *tile_getPixel(tile, i, j));
		}
		printf("\n");
	}
}
