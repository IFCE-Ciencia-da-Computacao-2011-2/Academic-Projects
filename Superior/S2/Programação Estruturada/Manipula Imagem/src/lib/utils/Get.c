#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "Get.h"

/**
 * Terminal colorido
 * http://stackoverflow.com/questions/3585846/color-text-in-terminal-aplications-in-unix
 */
#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"
#define RESET "\033[0m"

static char * getLinhaStdin();

/**
 * Cr�ditos:
 * http://stackoverflow.com/questions/7898215/how-to-clear-input-buffer-in-c
 */
static void limparBuffer() {
	while ( getchar() != '\n' );
}

int getInt(const char * texto) {
	int retorno;
	printf("%s", texto);
	scanf("%d", &retorno);

	return retorno;
}

/**
 * Pegar um endere�o de um arquivo com a 'extensao' especificada
 *
 * @return Endere�o dado alocado dinamicamente
 */
char * getEnderecoArquivo(char * texto, char * const extensao) {
	limparBuffer();

	char * endereco = NULL;

    while (1) {
    	printf("%s", texto);

    	endereco = getLinhaStdin();
    	if (endereco == NULL) {
    		print_error("N�o foi poss�vel ler o nome, tente novamente!");
    	}

    	// Verificar se extens�o � v�lida
    	if (!extensaoValida(endereco, extensao)) {
    		print_error("Extens�o inv�lida!");
    		print_error("Extens�o permitida: ");
    		printf(" - ");
    		print_sucess(extensao);
    		continue;
    	}

    	break;
	}
	return endereco;
}

/** Pega uma linha da entrada de dados padr�o
 *  Obs: � feito um malloc para linha
 *       Quando for terminar de usar, fa�a um free(linha);
 *  Obs: �ltimo caractere � '\0', e n�o '\n'!
 *
 * @return Endere�o da linha
 * 		   NULL: N�o foi poss�vel ler a linha
 */
static char * getLinhaStdin() {
	return getLinha(stdin);
}

/** L� uma linha do input dado
 *  Obs: � feito um malloc para linha
 *       Quando for terminar de usar, fa�a um free(linha);
 *  Obs: �ltimo caractere � '\0', e n�o '\n'!
 *
 * @return Endere�o da linha
 * 		   NULL: N�o foi poss�vel ler a linha
 */
char * getLinha(FILE * const input) {
	char * buffer = NULL;

	size_t tamBuffer = 0;
	ssize_t tamPalavra;

	// Pegar linha
	tamPalavra = getline(&buffer, &tamBuffer, input);
	if (tamPalavra == -1) {
		free(buffer);
		return NULL;
	}

	// Tirar o \0
	tamPalavra -= 1;

	// Passar do buffer para o par�metro 'linha'
	char * linha = (char *) malloc(sizeof(char) * (int) tamPalavra);
	int i;
	for (i=0; i < tamPalavra; i++)
		*(linha+i) = *(buffer+i);

	// substituir o \n por \0
	*(linha+i) = '\0';

	return linha;
}

/**
 * @param extensao Extens�o v�lida.
 * 				   Obs: N�o inserir cararctere ponto '.' antes da extens�o!
 */
int extensaoValida(char * const endereco, char * const extensao) {
	int tamanhoEndereco = strlen(endereco);
	int tamanhoExtensao = strlen(extensao);

	char * ptrEndereco = (endereco + (tamanhoEndereco - tamanhoExtensao));
	char * ptrExtensao = extensao;

	// Tamanho da palavra menor ou igual ao ponteiro
	// Se for igual, � porque n�o tem ponto, logo n�o tem extens�o
	// possivelmente sendo um diret�rio passado, e n�o um arquivo
	if (endereco >= ptrEndereco) {
		return 0;
	}

	// Existe o ponto que separa a extens�o
	// do arquivo
	if (*(ptrEndereco-1) != '.') {
		return 0;
	}

	// Verificando se as extens�es batem
	while (ptrEndereco < (endereco + tamanhoEndereco)) {
		if (toupper((unsigned char) *ptrEndereco) != toupper((unsigned char) *ptrExtensao))
			return 0;
		ptrEndereco++;
		ptrExtensao++;
	}

	return 1;
}

void print_error(const char * const msgErro) {
	printf("%s%s%s\n", KRED, msgErro, RESET);
}
void print_sucess(const char * const msgErro) {
	printf("%s%s%s\n", KGRN, msgErro, RESET);
}
