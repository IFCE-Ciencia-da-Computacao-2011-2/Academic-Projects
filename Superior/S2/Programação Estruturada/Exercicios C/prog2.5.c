#include <stdio.h>

/** Contar quantos 1's tem no binário de um
 *  num
 */
int main() {

	unsigned char num = 179; // 10110011
	unsigned char mask = 1;
	int count = 0;

	int index;
	for (index = 0; index < sizeof(num)*8; index++) {
		if (num & mask == 1) {
			count += 1;
		}
		num = num >> 1;
	}
	printf("%d\n", count);

	return 0;
}
