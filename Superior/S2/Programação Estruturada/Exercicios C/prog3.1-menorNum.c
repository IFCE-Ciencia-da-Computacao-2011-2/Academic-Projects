#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TAM 50

/* Menor número aleatório de uma lista com 50 elementos */
int main() {
	float v[TAM], menor;
	int i;

	srand((unsigned) time(NULL));

	for(i=0; i<TAM; i++) {
		v[i] = (rand() % 100) / 10.0;
		printf("%f ", v[i]);
	}

	menor = v[0];
	for(i=0; i<TAM; i++) {
		if (menor > v[i]) {
			menor = v[i];
		}
	}

	printf("\nMenor: %f\n", menor);
	
	return 0;
}
