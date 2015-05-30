#include <stdio.h>


int main() {
	char a;
	int b;
	float c;
	double d;
	//void e; // prog1.c:9:7: erro: variable or field ‘e’ declared void

	printf("char:   %d\n", sizeof(a));
	printf("int:    %d\n", sizeof(b));
	printf("float:  %d\n", sizeof(c));
	printf("double: %d\n", sizeof(d));
	printf("void:   %d\n", sizeof( void ));

	return 0;
}
