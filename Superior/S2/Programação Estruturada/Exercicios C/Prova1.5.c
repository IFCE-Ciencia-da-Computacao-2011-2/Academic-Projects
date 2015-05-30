/*
 Quinta questão da prova 
*/

#include <stdio.h>
#include <stdio.h>

int main() {
	unsigned char entrada;

	printf("Entrada: ");
	scanf("%c", &entrada);

	printf("Dado: %X\n", entrada);

	// Limpar 3 algarismos menos significativos
	entrada = entrada & 0xF8; // 1111 1000

	// Inverter o mais significativo
	entrada = entrada ^ 0x8F; // 0111 1111

	printf("Saída: 0x%X\n", saida);
	return 0;
}
