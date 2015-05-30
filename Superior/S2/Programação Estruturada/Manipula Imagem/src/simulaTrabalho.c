#include <stdio.h>
#include <stdlib.h>
#include "lib/Filtros.h"
#include "lib/ImagemPGM.h"
#include "lib/TilePGM.h"
#include "lib/utils/Get.h"
#include "lib/utils/ViewUtils.h"
#include <time.h>

#define TAM_BORDA 5

static double tempoExecucao(clock_t begin, clock_t end) {
	return (double) (end - begin) / CLOCKS_PER_SEC;
}

/*************************************
 * Requisitos do sistema
 *************************************/
static void copia(ImagemPGM * const original, char * const endereco) {
	imagem_save(original, endereco);
}

static void recorte(ImagemPGM * const original, ImagemPGM * const recorte, char * const endereco, unsigned int x, unsigned int y, unsigned int xEnd, unsigned int yEnd) {
	TilePGM tileRecorte = EmptyTilePGM;
	tile_constructor(&tileRecorte, original, x, y, xEnd, yEnd);

	tile_gerarImagemPGM(&tileRecorte, recorte);
	imagem_save(recorte, endereco);

	tile_destroy(&tileRecorte);
}

static void borrar(ImagemPGM * const imagem, ImagemPGM * const imagemBorrada, unsigned int tamanhoDaBorda, char * const endereco) {
	filtro_imagemByMedia(imagem, imagemBorrada, tamanhoDaBorda);
	imagem_save(imagemBorrada, endereco);
}

static void busca(ImagemPGM * const imagem, ImagemPGM * const subimagem, char * const endereco) {
	clock_t timeBegin = clock();

	ImagemPGM resultado = EmptyImagemPGM;
	imagem_copy(imagem, &resultado);

	TilePGM resultadoTile = tile_buscarSubimagem(&resultado, subimagem);
	tile_marcarBorda(&resultadoTile);

	imagem_save(&resultado, endereco);

	tile_destroy(&resultadoTile);
	imagem_destroy(&resultado);

	clock_t timeEnd = clock();
	printf("Imagem localizada em: %lf segundos (Tempo de uso da CPU)\n", tempoExecucao(timeBegin, timeEnd));
}

/*************************************
 * PRINCIPAL
 *************************************/
/** Simula todos os processos que deverão ser
 *  realiados no trabalho
 */
void simulaTrabalho() {
	ImagemPGM original = EmptyImagemPGM;

	ImagemPGM recorte1 = EmptyImagemPGM;
	ImagemPGM recorte2 = EmptyImagemPGM;
	ImagemPGM recorte3 = EmptyImagemPGM;

	ImagemPGM borrado1 = EmptyImagemPGM;
	ImagemPGM borrado2 = EmptyImagemPGM;
	ImagemPGM borrado3 = EmptyImagemPGM;

	ImagemPGM originalBorrado1 = EmptyImagemPGM;
	ImagemPGM originalBorrado2 = EmptyImagemPGM;
	ImagemPGM originalBorrado3 = EmptyImagemPGM;

	printf("PRESSIONE ENTER PARA CONTINUAR . . .");
	carregarImagemPGM(&original, "Digite a imagem na qual serão realizados os testes (*.pgm): ");

	printf("\nExecutando testes:\n");

	copia(&original, "testes/CopiaImagemMesmoFormato.pgm");
	print_sucess("[x] Entrada e Saída com arquivos - MESMO FORMATO");

	original.headArquivo.magicalNumber[1] = '2';
	copia(&original, "testes/CopiaImagemAscii.pgm");
	print_sucess("[x] Entrada e Saída com arquivos - TEXTO");

	original.headArquivo.magicalNumber[1] = '5';
	copia(&original, "testes/CopiaImagemBinario.pgm");
	print_sucess("[x] Entrada e Saída com arquivos - BINÁRIO");

	recorte(&original, &recorte1, "testes/recorte1.pgm", 0, 0, 50, 50);
	recorte(&original, &recorte2, "testes/recorte2.pgm", 0, 0, 100, 50);
	recorte(&original, &recorte3, "testes/recorte3.pgm", 50, 30, 100, 145);
	// Recortes mais fáceis de serem localizados
	recorte(&original, &recorte2, "testes/recorte2.pgm", 100, 100, 200, 150);
	recorte(&original, &recorte3, "testes/recorte3.pgm", 150, 130, 200, 245);
	print_sucess("[x] Algoritmo de recorte");

	borrar(&original, &originalBorrado1, 1, "testes/originalJanela3Borrado.pgm");
	borrar(&original, &originalBorrado2, 2, "testes/originalJanela5Borrado.pgm");
	borrar(&original, &originalBorrado3, 3, "testes/originalJanela7Borrado.pgm");
	print_sucess("[x] Filtro da média - Imagem original");

	borrar(&recorte1, &borrado1, TAM_BORDA, "testes/recorte1Borrado.pgm");
	borrar(&recorte2, &borrado2, TAM_BORDA, "testes/recorte2Borrado.pgm");
	borrar(&recorte3, &borrado3, TAM_BORDA, "testes/recorte3Borrado.pgm");
	print_sucess("[x] Filtro da média");

	busca(&original, &recorte1, "testes/buscaDoRecorte1.pgm");
	busca(&original, &recorte2, "testes/buscaDoRecorte2.pgm");
	busca(&original, &recorte3, "testes/buscaDoRecorte3.pgm");
	print_sucess("[x] Identiﬁcação da subimagem na imagem original - Imagem ORIGINAL");

	busca(&original, &borrado1, "testes/buscaDoRecorte1Borrado.pgm");
	busca(&original, &borrado2, "testes/buscaDoRecorte2Borrado.pgm");
	busca(&original, &borrado3, "testes/buscaDoRecorte3Borrado.pgm");
	print_sucess("[x] Identiﬁcação da subimagem na imagem original - Imagem BORRADA");

	printf("\n\n");
	print_sucess("Testes realizados com sucesso!");

	printf("\nNão houve erro de pilha, isto é um bom sinal!\n");
	printf("Entretanto, verifique os seguintes arquivos para verificar se o processamento está funcionando devidamente\n");

	printf(" - testes/CopiaImagemMesmoFormato.pgm\n");
	printf(" - testes/CopiaImagemAscii.pgm\n");
	printf(" - testes/CopiaImagemBinario.pgm\n");
	printf(" - testes/recorte1.pgm\n");
	printf(" - testes/recorte2.pgm\n");
	printf(" - testes/recorte3.pgm\n");
	printf(" - testes/recorte1Borrado.pgm\n");
	printf(" - testes/recorte2Borrado.pgm\n");
	printf(" - testes/recorte3Borrado.pgm\n");
	printf(" - testes/originalJanela3Borrado.pgm\n");
	printf(" - testes/originalJanela5Borrado.pgm\n");
	printf(" - testes/originalJanela7Borrado.pgm\n");
	printf(" - testes/buscaDoRecorte1.pgm\n");
	printf(" - testes/buscaDoRecorte2.pgm\n");
	printf(" - testes/buscaDoRecorte3.pgm\n");
	printf(" - testes/buscaDoRecorte1Borrado.pgm\n");
	printf(" - testes/buscaDoRecorte2Borrado.pgm\n");
	printf(" - testes/buscaDoRecorte3Borrado.pgm\n\n");

	print_sucess("Boa sorte na apresentação!");

	imagem_destroy(&original);

	imagem_destroy(&recorte1);
	imagem_destroy(&recorte2);
	imagem_destroy(&recorte3);

	imagem_destroy(&borrado1);
	imagem_destroy(&borrado2);
	imagem_destroy(&borrado3);

	imagem_destroy(&originalBorrado1);
	imagem_destroy(&originalBorrado2);
	imagem_destroy(&originalBorrado3);
}
