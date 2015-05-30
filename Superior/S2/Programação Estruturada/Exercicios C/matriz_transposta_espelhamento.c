#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int getRandomNumber(int max) {
	return rand() % (max+1);
}
int getRandomNumberMinMax(int min, int max) {
	return min + getRandomNumber(max-min);
}

void popularMatrizRandom(int * const ponteiro, int sizeLinha, int sizeColuna, int numeroMaximo) {
    int max = sizeLinha*sizeColuna;
    int i;

    for (i=0; i<max; i++) {
        ponteiro[i] = getRandomNumber(numeroMaximo);
    }
}

void imprimirMatriz(int const * ponteiro, int sizeLinha, int sizeColuna) {
    int i;
    int max = sizeLinha*sizeColuna;

    for (i = 0; i<max; i++) {
        printf("% .5d", ponteiro[i]);

        if (!((i+1)%sizeLinha)) {
            printf("\n");
        }
    }
}

/** Retorna um ponteiro para a memória alocada */
void * alocarMemoriaMatriz(linha, coluna, tamBytesTipo) {
    return malloc(linha*coluna*tamBytesTipo);
}

void inicialize() {
    srand((unsigned) time(NULL));
}
int main() {
    inicialize();

    int * matriz = NULL;
    int tamanho = getRandomNumberMinMax(3, 7);

    matriz = (int *) alocarMemoriaMatriz(tamanho, tamanho, sizeof(int));

    popularMatrizRandom(matriz, tamanho, tamanho, 10);
    imprimirMatriz(matriz, tamanho, tamanho);
}
