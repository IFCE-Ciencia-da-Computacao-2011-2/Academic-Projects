#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "Menu.h"
#include "Get.h"

void menu_cabecalho(const char * const titulo) {
	char linha[TAM_MENU+1];
	memset(linha, '*', TAM_MENU);
	linha[TAM_MENU] = '\0';

	int numAsteriscos = (TAM_MENU-strlen(titulo))/2 - 1;
	char asteriscos[numAsteriscos+1];
	memset(asteriscos, '*', numAsteriscos);
	asteriscos[numAsteriscos] = '\0';

	printf("%s\n", linha);
	printf("%s %s %s\n", asteriscos, titulo, asteriscos);
	printf("%s\n\n", linha);
}

void menu_item(const int numItem, const char * const titulo) {
	printf(" %d - %s\n", numItem, titulo);
}

/** @return Índice da opção selecionada
 */
int menu_selecionarOpcao(const int const totalItens) {
	int itemSelecionado = 0;
	while (1) {
		printf("\n");
		itemSelecionado = getInt("Selecione uma opção: ");

		if (itemSelecionado <= 0 || itemSelecionado > totalItens) {
			print_error("Opção inválida!");
		} else {
			break;
		}
	}

	printf("\n");
	return itemSelecionado;
}

/** Limpa toda a tela
 *
 * Créditos:
 *  - http://stackoverflow.com/questions/2347770/how-do-you-clear-console-screen-in-c
 *  - http://rosettacode.org/wiki/Terminal_control/Clear_the_screen#C
 */
void menu_clear() {
	printf("%c[2J", 27);
}
