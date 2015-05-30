#include <stdlib.h>
#include <time.h>
#include "Matematica.h"

/** Pensar numa forma melhor de fazer isso */
void matematica_inicializeLib() {
    srand((unsigned) time(NULL));
}


/** Retorna o menor elemento
 */
int menor(int i, int j) {
	return i < j ? i : j;
}

/* Passar para outro arquivo */
int getRandomNumber(int max) {
    return rand() % (max+1);
}
int getRandomNumberMinMax(int min, int max) {
    return min + getRandomNumber(max-min);
}
