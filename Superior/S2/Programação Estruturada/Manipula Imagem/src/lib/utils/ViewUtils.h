#ifndef _ViewUtils_
#define _ViewUtils_

/**
 * Entrada e sa�da de n�vel mais alto que Get.h
 */

#include "../ImagemPGM.h"

extern void carregarImagemPGM(ImagemPGM * imagem, char * const mensagem);
extern void salvarImagemPGM(ImagemPGM * imagem, char * const mensagem);
extern void dadosSimplesDaImagem(ImagemPGM * imagem);

#endif
