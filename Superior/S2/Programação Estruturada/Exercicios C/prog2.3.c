#include <stdio.h>


int main() {
	int a = 2147483647; // para 4 bytes

	printf("int:    %d\n", a);
	a += 1;
	printf("int:    %d\n", a);

	return 0;
}
