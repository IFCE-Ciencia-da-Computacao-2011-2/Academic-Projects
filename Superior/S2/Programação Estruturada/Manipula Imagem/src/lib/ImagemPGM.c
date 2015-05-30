#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ImagemPGM.h"
#include "utils/Get.h"

static void imagem_constructorDefault(ImagemPGM *imagem, const char * const magicalNumber, int width, unsigned int height, unsigned int levelsOfGray, char * const comment);
static void imagem_readHeaderAndInicialize(ImagemPGM * imagem, FILE * const arquivoPtr);
static void imagem_readPixels(ImagemPGM * const imagem, const char * const enderecom);

/****************************************
 * Alocação
 ****************************************/

/* Inicializa devidamente a ImagemPGM passada como referência
 *
 * @param width: Largura da imagem
 * @param height: Altura da imagem
 * @param comment: Comentário. NULL caso não haja comentário
 */
void imagem_constructor(ImagemPGM *imagem, const char * const magicalNumber, int width, unsigned int height, unsigned int levelsOfGray, char * const comment) {
	imagem_constructorDefault(imagem, magicalNumber, width, height, levelsOfGray, comment);

    if (width == 0 || height == 0 || levelsOfGray == 0) {
        imagem->pixels = EmptyMatrizBi;
    } else {
    	matriz_constructor(&imagem->pixels, height, width, sizeof(char));
    }
}

/** Popula a 'imagem' com base na matriz dada
 */
void imagem_constructorByMatriz(ImagemPGM * const imagem, const MatrizBi * const matriz, unsigned int levelsOfGray, char * const comment) {
	imagem_constructorDefault(imagem, "P5", matriz->totalColunas, matriz->totalLinhas, levelsOfGray, comment);

	imagem->pixels = *matriz;
}

/**
 * Inicializa tudo, menos a parte dos pixels
 */
static void imagem_constructorDefault(ImagemPGM *imagem, const char * const magicalNumber, int width, unsigned int height, unsigned int levelsOfGray, char * const comment) {
	imagem->headArquivo.magicalNumber[0] = magicalNumber[0];
	imagem->headArquivo.magicalNumber[1] = magicalNumber[1];

	imagem->headArquivo.width = width;
	imagem->headArquivo.height = height;

	if (comment != NULL) {
		imagem->headArquivo.comment = malloc(strlen(comment));
		strcpy(imagem->headArquivo.comment, comment);
	} else
		imagem->headArquivo.comment = NULL;

	imagem->headArquivo.levelsOfGray = levelsOfGray;
	imagem->headArquivo.sizePixel = levelsOfGray/256 + levelsOfGray%256 == 0 ? 0 : 1;
}

/* Desloca da memória a paleta
 */
void imagem_destroy(ImagemPGM *imagem) {
	matriz_destroy(&imagem->pixels);

	if (imagem->headArquivo.comment != NULL) {
    	free(imagem->headArquivo.comment);
    	imagem->headArquivo.comment = NULL;
    }

    imagem->headArquivo = EmptyHeadArquivo;
}


/****************************************
 * Processamento da imagem
 ****************************************/
static void pularLinhas(FILE * arquivo, int quantidade);
static int file_readPixel(FILE * arquivo, int isBinaria);
static int file_readPixelBinario(FILE * arquivo);
static int file_readPixelAscii(FILE * arquivo);

/* Carrega os dados da imagem no endereço dado no ImagemPGM dado
 *
 * @return Deu certo abrir a imagem?
 */
int imagem_read(ImagemPGM * imagem, const char * const endereco) {
	*imagem = EmptyImagemPGM;

	FILE *arquivoPtr = fopen(endereco, "r");

	if (arquivoPtr == NULL)
		return IMAGEM_ERRO;

	// Carregar cabeçalho
	imagem_readHeaderAndInicialize(imagem, arquivoPtr);

    fclose(arquivoPtr);

    // Carregar pixels
    imagem_readPixels(imagem, endereco);

    return IMAGEM_SUCESSO;
}

/* Carrega os dados do cabeçalho da imagem
 *
 * @return imagem
 */
static void imagem_readHeaderAndInicialize(ImagemPGM * imagem, FILE * const arquivoPtr) {

	char magicalNumber[2] = "  ";
	fscanf(arquivoPtr, "%2c\n", magicalNumber);

	// Buscar comentário
	char buffer[sizeof(int)];
	fscanf(arquivoPtr, "%c", buffer);
	fseek(arquivoPtr, -sizeof(char), SEEK_CUR);

	char * comentario = NULL;
	if (buffer[0] == '#') {
		comentario = getLinha(arquivoPtr);
	}

	fscanf(arquivoPtr, "%s", buffer);
	int width = atoi(buffer);
	fscanf(arquivoPtr, "%s", buffer);
	int height = atoi(buffer);

	fscanf(arquivoPtr, "%s\n", buffer);
	int levelsOfGray = atoi(buffer);

	imagem_constructor(imagem, magicalNumber, width, height, levelsOfGray, comentario);
}

/** Carregará os pixels da imagem.
 *  Como a leitura dos pixels depende do tipo da imagem (P2 ou P5),
 *  então, esta função que terá a responsabilidade de abrir e fechar
 *  o arquivo
 */
static void imagem_readPixels(ImagemPGM * const imagem, const char * const endereco) {
	FILE * arquivoPtr = NULL;

    // Verifica se o arquivo é 'binário' ou 'normal'
	int isBinario = imagem->headArquivo.magicalNumber[1] == '5';
    if (isBinario) {
    	arquivoPtr = fopen(endereco, "rb");
    } else {
    	arquivoPtr = fopen(endereco, "r");
    }

    // Pular linhas do cabeçalho
    int existeComentario = imagem->headArquivo.comment != NULL;
    int totalLinhasASeremPuladas = existeComentario ? 4 : 3;
    pularLinhas(arquivoPtr, totalLinhasASeremPuladas);

    // Ler pixels
    int x, y;
    for (y = 0; y<imagem->headArquivo.height; y++)
    	for (x = 0; x<imagem->headArquivo.width; x++)
    		*imagem_getPixel(imagem, x, y) = file_readPixel(arquivoPtr, isBinario);

    // Fechar arquivo
    fclose(arquivoPtr);
}

/** Altera o ponteiro para o início da próxima linha * n vezes
 *  onde n = @param quantidade
 *
 * @param quantidade Quantidade de linhas que serão puladas
 */
static void pularLinhas(FILE * arquivo, int quantidade) {
	int i;
	char c;

	for (i = 0; i<quantidade; i++) {
		while ((c = fgetc(arquivo)) != '\n');
	}
}

/** Retorna o píxel que está imediatamente após o ponteiro ou
 *  EOF caso tenha chegado no final do arquivo
 */
static int file_readPixel(FILE * arquivo, int isBinaria) {
	int pixel = 0;
	if (isBinaria) {
		pixel = file_readPixelBinario(arquivo);
	} else {
		pixel = file_readPixelAscii(arquivo);
	}

	return pixel;
}

/** Pixels representados de forma binária
 */
static int file_readPixelBinario(FILE * arquivo) {
	unsigned char c = fgetc(arquivo);

	if (c == EOF)
		return c;

	return (int) c;
}

/** Pixels representados de forma ASCII
 */
static int file_readPixelAscii(FILE * arquivo) {
	char c[3] = "00\0";
	fscanf(arquivo, "%s", c);

	return atoi(c);
}
/****************************************
 * Processamento da imagem - Salvar
 ****************************************/
static void file_writePixel(FILE * arquivo, unsigned char pixel, int isBinaria);
static void file_writePixelBinario(FILE * arquivo, unsigned char pixel);
static void file_writePixelAscii(FILE * arquivo, unsigned char pixel);

void imagem_save(const ImagemPGM * const imagem, char * const endereco) {
	FILE *file = fopen(endereco, "wb");
	int isBinario = imagem->headArquivo.magicalNumber[1] == '5';

	fprintf(file, "%c%c\n", *imagem->headArquivo.magicalNumber, *(imagem->headArquivo.magicalNumber+1));

	if (imagem->headArquivo.comment != NULL) {
		fprintf(file, "%s\n", imagem->headArquivo.comment);
	}
	fprintf(file, "%u %u\n", imagem->headArquivo.width, imagem->headArquivo.height);
	fprintf(file, "%u\n", imagem->headArquivo.levelsOfGray);

	int x, y;
	for (y = 0; y < imagem->headArquivo.height; y++) {
		for (x = 0; x < imagem->headArquivo.width; x++) {
			file_writePixel(file, (unsigned char) *imagem_getPixel(imagem, x, y), isBinario);
		}
		if (!isBinario) {
			fprintf(file, "\n");
		}
	}

	fclose(file);
}

/** Escreve o píxel que está imediatamente após o ponteiro
 */
static void file_writePixel(FILE * arquivo, unsigned char pixel, int isBinaria) {
	if (isBinaria) {
		file_writePixelBinario(arquivo, pixel);
	} else {
		file_writePixelAscii(arquivo, pixel);
	}
}

/** Pixels representados de forma binária
 */
static void file_writePixelBinario(FILE * arquivo, unsigned char pixel) {
	fprintf(arquivo, "%c", pixel);
}

/** Pixels representados de forma ASCII
 */
static void file_writePixelAscii(FILE * arquivo, unsigned char pixel) {
	fprintf(arquivo, "%d ", (int) pixel);
}
/****************************************
 * Processamento da imagem - Cópia
 ****************************************/
void imagem_copy(const ImagemPGM * const imagem, ImagemPGM * const copia) {
	imagem_constructor(
		copia,
		imagem->headArquivo.magicalNumber,
		imagem->headArquivo.width,
		imagem->headArquivo.height,
		imagem->headArquivo.levelsOfGray,
		imagem->headArquivo.comment
	);

	int x, y;
	for (y = 0; y < imagem->headArquivo.height; y++) {
		for (x = 0; x < imagem->headArquivo.width; x++) {
			*imagem_getPixel(copia, x, y) = *imagem_getPixel(imagem, x, y);
		}
	}
}
/****************************************
 * Processamento da imagem - Obtendo dados
 ****************************************/

/* Retorna o endereço do pixel requisitado
 *
 * @param img Imagem a ser pego o pixel
 * @param x (coluna) Posição x no plano cartesiano
 * @param y (linha)  Posição y no plano cartesiano
 *
 * @return Endereço do pixel com a posição dada
 */
unsigned char * imagem_getPixel(const ImagemPGM * const imagem, int x, int y) {
	return matriz_getElementoAddress(&imagem->pixels, y, x);
}


/****************************************
 * Verificar se está preenchida
 ****************************************/
static unsigned int imagem_headArquivo_isEmpty(const HeadArquivo * const header);

unsigned int imagem_isEmpty(const ImagemPGM * const imagem) {
	return imagem_headArquivo_isEmpty(&imagem->headArquivo) &&
		   matriz_isEmpty(&imagem->pixels);
}

static unsigned int imagem_headArquivo_isEmpty(const HeadArquivo * const header) {
	return header->magicalNumber[0] == EmptyHeadArquivo.magicalNumber[0] &&
		   header->magicalNumber[1] == EmptyHeadArquivo.magicalNumber[1] &&
		   header->width  == EmptyHeadArquivo.width &&
		   header->height == EmptyHeadArquivo.height &&
		   header->comment      == EmptyHeadArquivo.comment &&
		   header->levelsOfGray == EmptyHeadArquivo.levelsOfGray &&
		   header->sizePixel    == EmptyHeadArquivo.sizePixel;
}

/****************************************
 * Main
 ****************************************/

/* Imprime os dados da 'img' dada
 *
 * @param img = Imagem a ser exibida os dados
 */
void imagem_toString(ImagemPGM *img) {
	printf("+------------------------------+\n");
	printf("|         HeadArquivo          |\n");
	printf("+------------------------------+\n\n");
	printf("magicalNumber: %c%c\n",
		img->headArquivo.magicalNumber[0],
		img->headArquivo.magicalNumber[1]
	);

	printf("width:         %u px\n",
		img->headArquivo.width
	);
	printf("height:        %u px\n",
		img->headArquivo.height
	);

	printf("comment:       %s\n",
		img->headArquivo.comment
	);

	printf("levelsOfGray:  %u\n",
		img->headArquivo.levelsOfGray
	);

	printf("\n");
	printf("+------------------------------+\n");
	printf("|         Imagem               |\n");
	printf("+------------------------------+\n\n");

	if (matriz_isEmpty(&img->pixels)) {
		printf("Nenhum espaço alocado para os pixels o.O \n");
		return;
	}

	/**/
    if (img->pixels.totalColunas > 20 ||
		img->pixels.totalLinhas > 20) {
    	printf("Esta matriz é um pouco grande. Não acho uma boa ideia imprimir.\n");
        return;
    }/**/

    matriz_toString(&img->pixels);
}
