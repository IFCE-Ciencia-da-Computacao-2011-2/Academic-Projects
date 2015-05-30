#ifndef _ImagemPGM_
#define _ImagemPGM_

#include <stdio.h>
#include "MatrizBidimensional.h"

#define IMAGEM_ERRO 0
#define IMAGEM_SUCESSO 1

/* Cabeçalho de PGM
 * Sobre:
 * Obs: sizePixel não consta no formato. Ele é uma particularidade
 *      do código para facilitar o acesso/criar aos pixels
 */
typedef struct {
    char magicalNumber[2];
    unsigned int width;
    unsigned int height;
    char * comment;
    unsigned int levelsOfGray;
    unsigned int sizePixel;
} HeadArquivo;

static const HeadArquivo EmptyHeadArquivo = {"00", 0, 0, NULL, 0, 0};

/* Imagem PGM
 * Sobre: Imagem formada pelo cabeçalho e uma matriz de pixels
 * Tamanho: headArquivo.width * headArquivo.height * (headArquivo.levelsOfGray/256) + tamanho das próprias
 */
typedef struct {
	HeadArquivo headArquivo;
	MatrizBi pixels;
} ImagemPGM;

// FIXME Não sei como resolver isso
static const ImagemPGM EmptyImagemPGM;// = {EmptyHeadArquivo, EmptyMatrizBi};


extern void imagem_constructor(ImagemPGM *imagem, const char * const magicalNumber, int width, unsigned int height, unsigned int levelsOfGray, char * const comment);
extern void imagem_constructorByMatriz(ImagemPGM * const imagem, const MatrizBi * const matriz, unsigned int levelsOfGray, char * const comment);
extern void imagem_destroy(ImagemPGM *imagem);

unsigned int imagem_isEmpty(const ImagemPGM * const imagem);

extern int  imagem_read(ImagemPGM * imagem, const char * const endereco);
extern void imagem_save(const ImagemPGM * const imagem, char * const endereco);
extern void imagem_copy(const ImagemPGM * const imagem, ImagemPGM * const copia);

extern unsigned char * imagem_getPixel(const ImagemPGM * const imagem, int x, int y);

extern void imagem_toString(ImagemPGM *img);

#endif
