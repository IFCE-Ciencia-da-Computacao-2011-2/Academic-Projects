#include <stdio.h>

#ifndef _Get_
#define _Get_


/**
 * Biblioteca para obtenção e verificação de dados
 * inseridos pelo usuário
 */

extern int getInt(const char * texto);
extern char * getEnderecoArquivo(char * texto, char * extensao);

extern int extensaoValida(char * const  endereco, char * const extensao);

extern void print_error(const char * const msgErro);
extern void print_sucess(const char * const msgErro);

extern char * getLinha(FILE * const input);

#endif
