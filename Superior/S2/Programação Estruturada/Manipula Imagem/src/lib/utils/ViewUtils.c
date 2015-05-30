#include <stdio.h>
#include <stdlib.h>
#include "ViewUtils.h"
#include "Get.h"

#define EXTENSAO "PGM"

void carregarImagemPGM(ImagemPGM * imagem, char * const mensagem) {
	printf("CARREGAR IMAGEM\n");

	if (!imagem_isEmpty(imagem)) {
		imagem_destroy(imagem);
	}

	char *endereco = NULL;

	int imagemCarregadaComSucesso = 0;

	while (!imagemCarregadaComSucesso) {
		endereco = getEnderecoArquivo(mensagem, EXTENSAO);
		imagemCarregadaComSucesso = imagem_read(imagem, endereco);
		free(endereco);

		if(!imagemCarregadaComSucesso) {
			print_error("A imagem passada não foi localizada.");
			printf("Pressione ENTER para continuar");
		}
	}

	print_sucess("IMAGEM CARREGADA COM SUCESSO");
}
void salvarImagemPGM(ImagemPGM * imagem, char * const mensagem) {
	printf("SALVAR IMAGEM\n");

	char *endereco = getEnderecoArquivo(mensagem, EXTENSAO);
	imagem_save(imagem, endereco);
	free(endereco);

	print_sucess("IMAGEM SALVA COM SUCESSO");
}

void dadosSimplesDaImagem(ImagemPGM * imagem) {
	printf("Dados da imagem: \n");
	printf(" ALTURA: %d\n", imagem->headArquivo.height);
	printf(" LARGURA: %d\n", imagem->headArquivo.width);
}
