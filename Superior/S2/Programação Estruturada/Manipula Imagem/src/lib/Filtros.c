#include "Filtros.h"
#include "ImagemPGM.h"
#include "MatrizBidimensional.h"
#include "Mascara.h"

/****************************************
 * Processamento da imagem
 ****************************************/

/**Borra a 'imgOriginal' e popula a 'imgBorrada' atrav�s do filtro da
 * m�dia. Este filtro utiliza 'tamanhoBorda'
 *
 * @param imgOriginal Endere�o da imagem a ser borrada
 * @param imgBorrada  Endere�o da imagem no qual vai ser inserida a imagem original borrada
 * 					  Obs: N�o inicialize! O m�todo far� isto por voc�
 * @param tamanhoBorda Tamanho da borda para c�lculo de borramento
 */
void filtro_imagemByMedia(const ImagemPGM * const imgOriginal, ImagemPGM * imgBorrada, unsigned int const tamanhoBorda) {
	MatrizBi pixels = imgOriginal->pixels;

	MatrizBi pixelsBorrados = EmptyMatrizBi;
	filtro_matrizByMedia(&pixels, &pixelsBorrados, tamanhoBorda);

	imagem_constructorByMatriz(imgBorrada, &pixelsBorrados, imgOriginal->headArquivo.levelsOfGray, NULL);
}

/** Filtra a 'matrizFiltrada' com o filtro da m�dia
 *  com base na 'matriz' original e o 'tamanhoBorda' dado.
 *
 * @param matriz          Matriz original
 * @param matrizBorrada   Obs: N�o inicialize! O m�todo far� isto por voc�
 * @param tamanhoBorda    Tamanho da borda para c�lculo de borramento
 */
void filtro_matrizByMedia(MatrizBi * const matriz, MatrizBi * const matrizFiltrada, unsigned int tamanhoBorda) {
	// Inicializar a matriz filtrada
	matriz_constructor(matrizFiltrada, matriz->totalLinhas, matriz->totalColunas, matriz->sizeElemento);

	// Gerar espelho
	MatrizBi espelho = EmptyMatrizBi;
	matriz_gerarEspelho(matriz, &espelho, tamanhoBorda);

	// Calcular m�dia dos espelhos
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
