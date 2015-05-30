#include <stdio.h>

// %d  -> int
// %f  -> float
// %c  -> char
// %lf -> double

int main() {
	int a, b;

	printf("Entre com o valor de 'a': ");
	scanf("%d", &a);

	printf("Entre com o valor de 'b': ");
	scanf("%d", &b);

	printf("\n");

	//a = a ^ b;
	//b = a ^ b;
	//a = a ^ b;
	b = a+b;
	a = b-a;
	b = b-a;

	printf("Valor de 'a': %d \n", a);
	printf("Valor de 'b': %d \n", b);

	return 0;
}
