#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include "lib/utils/Get.h"
#include "lib/utils/Menu.h"
#include "lib/utils/ViewUtils.h"
#include "lib/Filtros.h"
#include "lib/ImagemPGM.h"
#include "lib/TilePGM.h"
#include "tests.h"
#include "simulaTrabalho.h"

#define EXTENSAO "PGM"

ImagemPGM imagemPrincipal;

static int menuInicial();
static int menuPrincipal();
static void sair();

static void carregarImagem(ImagemPGM * imagem);
static void recortar(ImagemPGM * imagem);
static void filtrarByMedia(ImagemPGM * imagem);
static void buscarImagem(ImagemPGM * imagem);

/*************************************
 * PRINCIPAL
 *************************************/

int main(int argc, char *argv[]) {
	setlocale(LC_ALL, "Portuguese");

	imagemPrincipal = EmptyImagemPGM;

	if (argc > 1 && strcmp(argv[1], "debug") == 0)
		main_tests();
	else if (argc > 1 && strcmp(argv[1], "simule") == 0)
		simulaTrabalho();
	else if (argc > 1 && strcmp(argv[1], "all") == 0) {
		main_tests();
		simulaTrabalho();
	} else
		menuInicial();

	return 0;
}

/*************************************
 * Menus
 *************************************/

static int menuInicial() {
	menu_clear();
	menu_cabecalho("Trabalho programação");
	menu_item(1, "Carregar Imagem Principal");
	menu_item(2, "Sair");

	int opcaoSelecionada = menu_selecionarOpcao(2);

	switch (opcaoSelecionada) {
		case 1:
			menu_cabecalho("Ler imagem");
			carregarImagem(&imagemPrincipal);
			menuPrincipal();
			break;
		case 2:
			sair();
			break;
		default:
			break;
	}

	return opcaoSelecionada;
}

static int menuPrincipal() {
	int opcaoSelecionada = 0;
	int finalizaPrograma = 0;

	while (!finalizaPrograma) {
		menu_clear();
		menu_cabecalho("Menu principal");

		menu_item(1, "Recortar imagem");
		menu_item(2, "Aplicar filtro da média");
		menu_item(3, "Buscar subimagem");
		menu_item(4, "Menu Anterior");
		menu_item(5, "Sair");

		opcaoSelecionada = menu_selecionarOpcao(6);

		menu_clear();

		switch (opcaoSelecionada) {
			case 1:
				menu_cabecalho("Recortar imagem");
				recortar(&imagemPrincipal);
				break;
			case 2:
				menu_cabecalho("Filtrar imagem: Média");
				filtrarByMedia(&imagemPrincipal);
				break;
			case 3:
				menu_cabecalho("Buscar imagem");
				buscarImagem(&imagemPrincipal);
				break;
			case 4:
				if (menuInicial() == 2) // TODO - Gambiarra
					finalizaPrograma = 1;
				break;
			case 5:
				sair();
				finalizaPrograma = 1;
				break;
			default:
				break;
		}
	}

	return opcaoSelecionada;
}

static void sair() {
	imagem_destroy(&imagemPrincipal);
}


/*************************************
 * Ler Imagem
 *************************************/

static void carregarImagem(ImagemPGM * imagem) {
	carregarImagemPGM(imagem, "Endereço da imagem (*.pgm): ");
}


/*************************************
 * Recortar
 *************************************/

/**
 * Realiza um recorte na imagem e salva a área recortada.
 */
static int pegarTileParaRecorte(TilePGM * tile, ImagemPGM * imagem);

/**
 * Requisito funcional 1:
 * Realizar recorte de uma regiao de interesse da imagem e salva-la em um arquivo.
 */
static void recortar(ImagemPGM * imagem) {
	dadosSimplesDaImagem(imagem);
	printf("\n");

	// Pegar posições de recorte
	TilePGM tile = EmptyTilePGM;

	int isTileValido;
	while ((isTileValido = pegarTileParaRecorte(&tile, imagem)) == TILE_ERRO) {
		print_error("Posições selecionadas inválidas!");
		print_error("Por favor, insira as coordenadas novamente\n");
		dadosSimplesDaImagem(imagem);
		printf("\n");

		continue;
	}

	ImagemPGM recorte = EmptyImagemPGM;
	tile_gerarImagemPGM(&tile, &recorte);

	print_sucess("Imagem recortada com sucesso!\n");
	salvarImagemPGM(&recorte, "Nome do recorte (*.pgm): ");

	tile_destroy(&tile);
	imagem_destroy(&recorte);
}

static int pegarTileParaRecorte(TilePGM * tile, ImagemPGM * imagem) {
	printf("Insira as coordenadas do recorte\n");
	int x = getInt("X inicial: ");
	int y = getInt("Y inicial: ");
	int xEnd = getInt("X final: ");
	int yEnd = getInt("Y final: ");

	return tile_constructor(tile, imagem, x, y, xEnd, yEnd);
}

/*************************************
 * Filtro pela média
 *************************************/
static unsigned int getTamanhoDaJanela(ImagemPGM * imagem);

/**
 * Requisito funcional 2:
 * Aplicação do filtro da média
 *
 * Cria uma imagem cópia e adiciona o filtro da média nela
 */
static void filtrarByMedia(ImagemPGM * imagem) {
	unsigned int tamJanela = getTamanhoDaJanela(imagem);
	unsigned int tamBorda = tamJanela/2;

	ImagemPGM imagemFiltrada = EmptyImagemPGM;
	filtro_imagemByMedia(imagem, &imagemFiltrada, tamBorda);

	print_sucess("Imagem filtrada com sucesso!");
	printf("\nSalvar imagem borrada: \n");

	salvarImagemPGM(&imagemFiltrada, "Nome da imagem borrada (*.pgm): ");

	imagem_destroy(&imagemFiltrada);
}

static unsigned int getTamanhoDaJanela(ImagemPGM * imagem) {
	int tamJanela = 0;

	while (1) {
		tamJanela = getInt("Tamanho da janela: ");

		if (tamJanela % 2 == 0 ||
			tamJanela <= 1)
			print_error("Tamanho da janela deve ser ímpar maior que 1!");

		else if (tamJanela >= imagem->headArquivo.height ||
				 tamJanela >= imagem->headArquivo.width) {
			print_error("Tamanho da janela deve menor que a ALTURA e a LARGURA da imagem!");
			dadosSimplesDaImagem(imagem);

		} else
			break;

		printf("\n");
	}

	return (unsigned int) tamJanela;
}

/*************************************
 * Buscar imagem
 *************************************/

/**
 * Requisito funcional 4:
 * Realizar busca de uma imagem em outra
 *
 * Cria uma imagem cópia e adiciona o filtro da média nela
 */
static void buscarImagem(ImagemPGM * imagem) {
	// Criando variáveis
	ImagemPGM resultado = EmptyImagemPGM;
	ImagemPGM imagemASerBuscada = EmptyImagemPGM;
	TilePGM tileResultado = EmptyTilePGM;

	// Copiando Imagem Principal
	imagem_copy(imagem, &resultado);

	// Pegando dados da imagem a ser buscada
	while (1) {
		carregarImagemPGM(&imagemASerBuscada, "Nome da imagem RECORTE a ser buscado (*.pgm): ");

		printf("Buscando imagem\n");

		tileResultado = tile_buscarSubimagem(&resultado, &imagemASerBuscada);
		if (tile_isEmpty(&tileResultado)) {
			print_error("Imagem buscada é maior que a carregada no sistema!");
			printf("IMAGEM CARREGADA:\n");
			dadosSimplesDaImagem(&resultado);
			printf("RECORTE CARREGADO:\n");
			dadosSimplesDaImagem(&imagemASerBuscada);

			printf("Por favor, preencha novamente.\n\n");
			continue;
		}

		break;
	}

	tile_marcarBorda(&tileResultado);

	// Salvando resultados
	printf("\nSalvar resultado da busca:\n(Pressione ENTER para continuar)\n");
	salvarImagemPGM(&resultado, "Nome da imagem (*.pgm): ");

	// Reciclando memória
	tile_destroy(&tileResultado);
	imagem_destroy(&resultado);
	imagem_destroy(&imagemASerBuscada);
}
