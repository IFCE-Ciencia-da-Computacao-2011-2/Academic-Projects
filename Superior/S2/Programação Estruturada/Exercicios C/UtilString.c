#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 10

void read(char * const string, int size) {
	fgets(string, size, stdin);

	// Palavra maior do que o tamanho
	if (string[size-1] == '\0') {
		while (getchar() != '\n');

	// Palavra menor do que o tamanho
	} else {
		// Retirar \n da palavra
		int index = getPos(string, '\n', size);
		string[index-1] = '\n';
	}
}

/**
 * @param size: Tamanho da string
 * @return Primeira ocorrência da posição
 	   -1 se não encontrar
 */

int getPos(char * const string, char ch, int size) {
	int index;
	for (index = 0; index < size; index ++) {
		if (string[index] == ch) {
			return index;
		}
	}
	return -1;
}

int main()  {
	char nomeCompleto[SIZE*2];
	char sobrenome[SIZE];

	printf("Dados pessoais\n\n");

	printf("Nome: ");
	read(nomeCompleto, SIZE);

	printf("Sobrenome: ");
	read(sobrenome, SIZE);

	strcat(nomeCompleto, sobrenome);
	printf("\nSeu nome: %s\n", nomeCompleto);

	return 0;
}
