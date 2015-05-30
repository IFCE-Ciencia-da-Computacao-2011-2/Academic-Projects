#include "TilePGM.h"
#include "TilePGMTest.h"
#include "tests/tests_utils.h"
#include "tests/thc.h"

/****************************************
 * Testes relacionados a TilePGM.h
 ****************************************/

extern void tile_constructorTest() {
	cabecalho("tile_constructorTest()");

	int x = 2, y = 4, xEnd = 10, yEnd = 8;
	ImagemPGM imagem = EmptyImagemPGM;
	imagem_constructor(&imagem, "P2", 15, 10, 255, NULL);
	matriz_popularSequencialmente(&imagem.pixels);
	imagem_toString(&imagem);

	TilePGM tile = EmptyTilePGM;
	int tileDadosErrados  = tile_constructor(&tile, &imagem, 1000, 1000, 1001, 1001);
	int tileDadosErrados2 = tile_constructor(&tile, &imagem, 10, 10, 0, 0);
	int tileDadosCorretos = tile_constructor(&tile, &imagem, x, y, xEnd, yEnd);

	tile_toString(&tile);

	printf("Matriz da ImagemPGM populada sequencialmente\n");
	ENSURE(!tile_isEmpty(&tile));
	ENSURE(tile.x == x);
	ENSURE(tile.y == y);
	ENSURE(tile.xEnd == xEnd);
	ENSURE(tile.yEnd == yEnd);
	ENSURE(tile.xSize = xEnd-x);
	ENSURE(tile.ySize = yEnd-y);

	ENSURE(imagem_getPixel(&imagem, x, y) == tile_getPixel(&tile, 0, 0));
	ENSURE(tileDadosCorretos == TILE_SUCESSO);
	ENSURE(tileDadosErrados == TILE_ERRO);
	ENSURE(tileDadosErrados2 == TILE_ERRO);

	tile_destroy(&tile);
	imagem_destroy(&imagem);
}


extern void tile_destroyTest() {
	cabecalho("tile_destroyTest()");

	ImagemPGM imagem = EmptyImagemPGM;
	TilePGM tile = EmptyTilePGM;

	imagem_constructor(&imagem, "P2", 15, 10, 255, NULL);

	tile_constructor(&tile, &imagem, 5, 9, 15, 10);
	printf("Tile criado\n");
	ENSURE(!tile_isEmpty(&tile));
	printf("Tile destruído\n");
	tile_destroy(&tile);

	ENSURE(tile_isEmpty(&tile));

	imagem_destroy(&imagem);
}

/****************************************
 * Acesso
****************************************/
extern void tile_getPixelTest() {
	cabecalho("tile_getPixelTest()");

	int x = 2, y = 4, xEnd = 10, yEnd = 8;
	ImagemPGM imagem = EmptyImagemPGM;
	TilePGM tile = EmptyTilePGM;

	imagem_constructor(&imagem, "P2", 15, 10, 255, NULL);
	matriz_popularSequencialmente(&imagem.pixels);

	tile_constructor(&tile, &imagem, x, y, xEnd, yEnd);

	printf("Obs: Matriz da ImagemPGM populada sequencialmente\n");
	printf("Pixel da imagem corresponde ao pixel do tile\n");
	ENSURE(imagem_getPixel(&imagem, x, y) == tile_getPixel(&tile, 0, 0));
	ENSURE(imagem_getPixel(&imagem, x+2, y+2) == tile_getPixel(&tile, 0+2, 0+2));
	printf("Píxel dentro do tile\n");
	ENSURE(tile_getPixel(&tile, 0, 0) != NULL);
	printf("Píxel fora do tile, mas ainda dentro da matriz\n");
	ENSURE(tile_getPixel(&tile, -1, -1) != NULL);
	printf("Píxel fora da matriz no qual o tile aponta\n");
	ENSURE(tile_getPixel(&tile, -100, -100) == NULL);
	ENSURE(tile_getPixel(&tile, 100, 100) == NULL);

	matriz_destroy(&imagem.pixels);

	printf("Mesmos testes anteriores, mas a matriz foi destruida\n");
	ENSURE(tile_getPixel(&tile, 0, 0) == NULL);
	ENSURE(tile_getPixel(&tile, -1, -1) == NULL);
	ENSURE(tile_getPixel(&tile, -100, -100) == NULL);
	ENSURE(tile_getPixel(&tile, 100, 100) == NULL);

	tile_destroy(&tile);
	imagem_destroy(&imagem);
}

// FIXME - Fazer
extern void tile_copiarTest() {

}
/****************************************
 * Salvar
****************************************/
extern void tile_gerarImagemPGMTest() {
	cabecalho("tile_gerarImagemPGMTest()");

	int x = 10, y = 10, xEnd = 20, yEnd = 20;
	ImagemPGM imagem = EmptyImagemPGM;
	imagem_constructor(&imagem, "P2", 50, 50, 255, NULL);
	matriz_popularSequencialmente(&imagem.pixels);

	TilePGM tile = EmptyTilePGM;
	tile_constructor(&tile, &imagem, x, y, xEnd, yEnd);

	ImagemPGM imagemTile = EmptyImagemPGM;
	tile_gerarImagemPGM(&tile, &imagemTile);

	int pixelTile;
	int pixelImagemTile;

	int i, j;
	for (i = 0; i < xEnd-x; i++) {
		for (j = 0; j < yEnd-y; j++) {
			pixelTile = *tile_getPixel(&tile, i, j);
			pixelImagemTile = *imagem_getPixel(&imagemTile, i, j);
			ENSURE(pixelTile == pixelImagemTile);
		}
	}

	tile_destroy(&tile);
	imagem_destroy(&imagem);
	imagem_destroy(&imagemTile);
}

/****************************************
 * Verificar se está preenchida
 ****************************************/
extern void tile_isEmptyTest() {
	cabecalho("tile_isEmptyTest()");

	int x = 2, y = 4, xEnd = 10, yEnd = 8;
	ImagemPGM imagem = EmptyImagemPGM;
	imagem_constructor(&imagem, "P2", 15, 10, 255, NULL);
	matriz_popularSequencialmente(&imagem.pixels);

	TilePGM tile;
	printf("Tile está vazio?\n");
	ENSURE(!tile_isEmpty(&tile));

	tile = EmptyTilePGM;
	printf("Tile setado como EmptyTileTest agora está vazio?\n");
	ENSURE(tile_isEmpty(&tile));

	printf("Tile criado agora está vazio?\n");
	tile_constructor(&tile, &imagem, x, y, xEnd, yEnd);
	ENSURE(!tile_isEmpty(&tile));

	printf("Tile destruído está vazio?\n");
	tile_destroy(&tile);

	ENSURE(tile_isEmpty(&tile));

	imagem_destroy(&imagem);
}

/****************************************
 * Main - Para fins de teste
 ****************************************/
//void tile_toStringTest() {

void tile_test() {
	thc_addtest(tile_constructorTest);
	thc_addtest(tile_destroyTest);
	thc_addtest(tile_getPixelTest);
	thc_addtest(tile_copiarTest);
	thc_addtest(tile_gerarImagemPGMTest);
	thc_addtest(tile_isEmptyTest);
}
