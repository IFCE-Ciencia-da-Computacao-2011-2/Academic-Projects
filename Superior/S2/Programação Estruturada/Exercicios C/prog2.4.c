#include <stdio.h>

int xor(int a, int b) {
	return (a &~b) | (b &~a);
}

int main() {

	int a = 10;
	int b = 30;

	printf("Orig: a = %d. b = %d\n", a, b);

	a = a ^ b;
	b = a ^ b;
	a = a ^ b;

	printf(" ^  : a = %d. b = %d\n", a, b);

	a = xor(a, b);
	b = xor(a, b);
	a = xor(a, b);

	printf("XOR : a = %d; b = %d;\n", a, b);
	return 0;
}
