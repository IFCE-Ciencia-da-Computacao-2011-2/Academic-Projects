#include "Filtros.h"
#include "ImagemPGM.h"
#include "MatrizBidimensional.h"
#include "Mascara.h"

/****************************************
 * Processamento da imagem
 ****************************************/

/**Borra a 'imgOriginal' e popula a 'imgBorrada' através do filtro da
 * média. Este filtro utiliza 'tamanhoBorda'
 *
 * @param imgOriginal Endereço da imagem a ser borrada
 * @param imgBorrada  Endereço da imagem no qual vai ser inserida a imagem original borrada
 * 					  Obs: Não inicialize! O método fará isto por você
 * @param tamanhoBorda Tamanho da borda para cálculo de borramento
 */
void filtro_imagemByMedia(const ImagemPGM * const imgOriginal, ImagemPGM * imgBorrada, unsigned int const tamanhoBorda) {
	MatrizBi pixels = imgOriginal->pixels;

	MatrizBi pixelsBorrados = EmptyMatrizBi;
	filtro_matrizByMedia(&pixels, &pixelsBorrados, tamanhoBorda);

	imagem_constructorByMatriz(imgBorrada, &pixelsBorrados, imgOriginal->headArquivo.levelsOfGray, NULL);
}

/** Filtra a 'matrizFiltrada' com o filtro da média
 *  com base na 'matriz' original e o 'tamanhoBorda' dado.
 *
 * @param matriz          Matriz original
 * @param matrizBorrada   Obs: Não inicialize! O método fará isto por você
 * @param tamanhoBorda    Tamanho da borda para cálculo de borramento
 */
void filtro_matrizByMedia(MatrizBi * const matriz, MatrizBi * const matrizFiltrada, unsigned int tamanhoBorda) {
	// Inicializar a matriz filtrada
	matriz_constructor(matrizFiltrada, matriz->totalLinhas, matriz->totalColunas, matriz->sizeElemento);

	// Gerar espelho
	MatrizBi espelho = EmptyMatrizBi;
	matriz_gerarEspelho(matriz, &espelho, tamanhoBorda);

	// Calcular média dos espelhos
	Mascara mascara = EmptyMascara;

	unsigned int coluna, linha;
	for (linha = 0; linha < matriz->totalLinhas; linha++)
		for (coluna = 0; coluna < matriz->totalColunas; coluna++) {
			mascara_constructor(&mascara, &espelho, coluna, linha, coluna+tamanhoBorda*2+1, linha+tamanhoBorda*2+1);
			*matriz_getElementoAddress(matrizFiltrada, linha, coluna) = mascara_getMedia(&mascara);
		}

	mascara_destroy(&mascara);
	matriz_destroy(&espelho);
}
