#ifndef _Filtos_
#define _Filtos_

#include "ImagemPGM.h"

extern void filtro_imagemByMedia(const ImagemPGM * const imgOriginal, ImagemPGM * imgBorrada, unsigned int const tamanhoBorda);
extern void filtro_matrizByMedia(MatrizBi * const matriz, MatrizBi * const matrizFiltrada, unsigned int tamanhoBorda);

#endif
