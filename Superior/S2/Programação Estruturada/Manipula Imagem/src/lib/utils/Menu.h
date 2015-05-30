#ifndef _Menu_
#define _Menu_

#include <stdio.h>
#include "Get.h"

// Tamanho lateral do menu
#define TAM_MENU 36

extern void menu_cabecalho(const char * const titulo);
extern void menu_item(const int numItem, const char * const titulo);
extern void menu_clear();

extern int menu_selecionarOpcao(const int const totalItens);

#endif
