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
 * Créditos:
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
 * Pegar um endereço de um arquivo com a 'extensao' especificada
 *
 * @return Endereço dado alocado dinamicamente
 */
char * getEnderecoArquivo(char * texto, char * const extensao) {
	limparBuffer();

	char * endereco = NULL;

    while (1) {
    	printf("%s", texto);

    	endereco = getLinhaStdin();
    	if (endereco == NULL) {
    		print_error("Não foi possível ler o nome, tente novamente!");
    	}

    	// Verificar se extensão é válida
    	if (!extensaoValida(endereco, extensao)) {
    		print_error("Extensão inválida!");
    		print_error("Extensão permitida: ");
    		printf(" - ");
    		print_sucess(extensao);
    		continue;
    	}

    	break;
	}
	return endereco;
}

/** Pega uma linha da entrada de dados padrão
 *  Obs: É feito um malloc para linha
 *       Quando for terminar de usar, faça um free(linha);
 *  Obs: Último caractere é '\0', e não '\n'!
 *
 * @return Endereço da linha
 * 		   NULL: Não foi possível ler a linha
 */
static char * getLinhaStdin() {
	return getLinha(stdin);
}

/** Lê uma linha do input dado
 *  Obs: É feito um malloc para linha
 *       Quando for terminar de usar, faça um free(linha);
 *  Obs: Último caractere é '\0', e não '\n'!
 *
 * @return Endereço da linha
 * 		   NULL: Não foi possível ler a linha
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

	// Passar do buffer para o parâmetro 'linha'
	char * linha = (char *) malloc(sizeof(char) * (int) tamPalavra);
	int i;
	for (i=0; i < tamPalavra; i++)
		*(linha+i) = *(buffer+i);

	// substituir o \n por \0
	*(linha+i) = '\0';

	return linha;
}

/**
 * @param extensao Extensão válida.
 * 				   Obs: Não inserir cararctere ponto '.' antes da extensão!
 */
int extensaoValida(char * const endereco, char * const extensao) {
	int tamanhoEndereco = strlen(endereco);
	int tamanhoExtensao = strlen(extensao);

	char * ptrEndereco = (endereco + (tamanhoEndereco - tamanhoExtensao));
	char * ptrExtensao = extensao;

	// Tamanho da palavra menor ou igual ao ponteiro
	// Se for igual, é porque não tem ponto, logo não tem extensão
	// possivelmente sendo um diretório passado, e não um arquivo
	if (endereco >= ptrEndereco) {
		return 0;
	}

	// Existe o ponto que separa a extensão
	// do arquivo
	if (*(ptrEndereco-1) != '.') {
		return 0;
	}

	// Verificando se as extensões batem
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
