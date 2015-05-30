#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
Quando se trabalhar com Strings, lembre-se do '\0' no fim da palavra!

 -> strcpy(s1,s2):
Copia s2 em s1. Tamanho da matriz destinada a s1 (e não o tamanho da palavra em s1!)
tem que ser maior ou igual a s2

 -> strcat(s1,s2):
concatena s2 ao final de s1
ATENÇÃO: Se você fizer: 
	char a[20];
	char b = "bacaca";
	strcat(s1, s2);

Tem altas chances de dar merda, pois, como 'a' não foi inicializado (não foi dado um valor a 'a')
s2 vai ficar no fim do lixo que já tinha em 'a'. Para não ter problemas, faça:
	char a[20];
	a[0] = '\0'
	char b = "bacaca";
	strcat(s1, s2);

 -> strlen(s1):
Retorna o tamanho da palavra contida em s1.
No caso:
	char teste[50] = "bacaca";
	printf("Palavra: %s\n", teste);
	printf("strlen(%s) = %d\n", teste, strlen(teste));
	printf("sizeof(%s) = %d\n", teste, sizeof(teste));

IMPRIME:
	Palavra: bacaca
	strlen(bacaca) = 6
	sizeof(bacaca) = 50

 -> strcmp(s1, s2):
retorna 0 se iguais
menor que 0 se s1 < s2
maior que 0 se s1 > s2.

É melhor explicar o algoritmo:
Como sabemos, uma letra é um char que possui uma representação numérica positiva conforme ASCII

Então:
	char palavra1[20] = "teste";
	char palavra2[20] = "teste";

	Pega a primeira letra das palavras e subtrai uma pela outra. 
	se forem letras iguais (palavra1[0] - palavra2[0] == 0), olha a próxima letra de cada
	palavra	até achar letras diferentes

	Retorna a subtração das letras diferentes.

Agora uma particuliaridade:
	char palavra1[20] = "teste";
	char palavra2[20] = "teste ";

	strcmp(s1, s2) == -1
	strcmp(s2, s1) == 1

	char palavra1[20] = "123";
	char palavra2[20] = "123";

	strcmp(s2, s1) == 0


 -> strchr(s1, ch);
Retorna um ponteiro para a primeira ocorrência de char 'ch' em char[] 's1'.
Se não houver, retorna NULL

 -> strstr(s1,s2)
Retorna um ponteiro para a primeira ocorrência de s2 em s1.
Se não houver, retorna NULL
*/


/**

 -> void * malloc(size_t numero_bytes);
Exemplo: int * teste = malloc(5* sizeof(int));

 -> Testar se memória foi alocada
if(!teste) {
	printf("Lasquei-me! Sem memória!");
}

 -> void free(void * p);
Exemplo: free(teste);

 -> realoc
http://www.cprogressivo.net/2013/10/A-funcao-realloc-realocando-memoria-dinamicamente-e-a-calloc.html

 -> calloc (Mesmo link, tá pelo final do artigo)
http://www.cprogressivo.net/2013/10/A-funcao-realloc-realocando-memoria-dinamicamente-e-a-calloc.html

"Quando usamos a malloc() simplesmente reservamos um espaço de memória.
Já quando usamos a calloc(), além de reservar esse espaço de memória ele muda os valores contidos nesses bytes, colocando todos para 0."
*/


/*
1. Preencher (ler) um vetor X de 10 elementos com o valor inteiro 30. 
Escrever o vetor X após seu total preenchimento. 
*/
void questao1() {
	int size = 10;
	int x[size];

	int i;
	for (i=0; i<size; i++) {
		*(x+i) = 30;
	}

	for (i=0; i<size; i++) {
		printf("x[%d] = %d\n", i, x[i]);
	}
}

/**
 * Retorna o tamanho da palavra
 * Se não for encontrado um \0 na palavra
 * retorna -1, que quer dizer que o conteúdo da palavra
 * vai além do tamanho dela
 */
int tamPalavra(char * palavra, unsigned int tamanho) {
	unsigned int strLength = strlen(palavra);

	if (strLength+1 < tamanho) {
		return strLength;
	}
	if (palavra[strLength-1] == '\0') {
		return strLength;
	} else {
		return -1;
	}
}

/* Retorna a última posição do 'c' (char) na 'string'
 * Retorna -1 caso não encontre o char
 */
int getLastCharPos(char const * const string, char c) {
	int i = strlen(string)-1;
	while (string[i] != c && i > 0) {
		i--;
	}

	return i;
}

/** Cuidado que isso pode dar loop infinito */
void limpaBuffer() {
	while (getchar() != '\n');
}

void getPalavra(char * palavra, unsigned int tamanho) {
	fgets(palavra, tamanho, stdin);

	if (tamPalavra(palavra, tamanho) > -1) {
		int posQuebraLinha = getLastCharPos(palavra, '\n');

		palavra[posQuebraLinha] = '\0';
		palavra[posQuebraLinha+1] = ' ';

	} else {
		limpaBuffer();
	}
}

/*
2. Faça um programa que leia quatro palavras e armazene cada palavra
em uma string. Depois, concatene todas as strings 
lidas em uma única e mostre o resultado
*/
void questao2() {
	unsigned int size = 15;
	char palavra1[size];
	char palavra2[size];
	char palavra3[size];
	char palavra4[size];

	int TOTAL_PALAVRAS = 4;
	char * palavras[] = {palavra1, palavra2, palavra3, palavra4};

	int i;
	for (i=0; i<TOTAL_PALAVRAS; i++) {
		printf("Digite uma palavra: ");
		getPalavra(*(palavras+i), size);
	}


	int sizeNovaPalavra = 0;
	for (i=0; i<TOTAL_PALAVRAS; ++i) {
		printf("%d° palavra: %s\n", i+1, *(palavras+i));
		sizeNovaPalavra += strlen(*(palavras+i));
	}
	sizeNovaPalavra += 1; // + \0

	// Concatenar palavras
	char novaPalavra[sizeNovaPalavra];
	novaPalavra[0] = '\0'; // Isso é necessário pois quando declara a variável (linha acima)
	// fica lixo - o que já tinha na memória -, já que o valor/conteúdo não foi declarado
	// Aí na hora de concatenar, o strcat não sabe o começo da palavra...

	for (i = 0; i<TOTAL_PALAVRAS; ++i) {
		strcat(novaPalavra, *(palavras+i));
	}

	// Imprimir palavra concatenada
	printf("Palavras concatenadas: '%s'\n", novaPalavra);
}

/**
3. Escreva um programa que leia uma palavra (com no máximo 20 caracteres)
e mostre as letras cujos índices são par
*/
void questao3() {
	int size = 20;
	char palavra[size];

	printf("Digite uma palavra: ");
	getPalavra(palavra, size);

	int sizePalavra = strlen(palavra);
	int i;
	for (i = 0; i < sizePalavra; i+=2) {
		printf("%c\n", *(palavra+i));
	}
}


/**
4. Ler um vetor D de 4 elementos. Criar um vetor E, 
com todos os elementos de D na ordem inversa, ou seja,
o último elemento passará a ser o primeiro, o penúltimo será o
segundo e assim por diante. Escrever todo o vetor D e todo o vetor E
*/
void questao4() {
	int SIZE = 4;
	char d[SIZE];
	char e[SIZE];

	printf("Digite %d char's (consecutivos, sem espaço ou ENTER): \n", SIZE);
	int i;
	for (i = 0; i < SIZE; i++) {
		*(d+i) = getchar();
	}

	printf(" (Atribuindo Matriz E) \n");
	for (i = 0; i < SIZE; i++) {
		e[SIZE-i-1] = *(d+i);
	}

	printf("Matriz d: ");
	for (i = 0; i < SIZE; i++) {
		printf("%c", *(d+i));
	}
	printf("\nMatriz e: ");
	for (i = 0; i < SIZE; i++) {
		printf("%c", *(e+i));
	}
	printf("\n");
}


/**
5. Ler um vetor X de 7 elementos inteiros e positivos. Criar um
vetor Y da seguinte forma: os elementos de Y com índice
par receberão os respectivos elementos de X divididos por 2;
os elementos com índice ímpar receberão os respectivos elementos de X
multiplicados por 3. Escrever o vetor X e o vetor Y
*/
void questao5() {
	int SIZE = 7;
	int x[SIZE];
	int y[SIZE];

	printf("Digite %d int's: \n", SIZE);
	int i;
	for (i = 0; i < SIZE; i++) {
		printf("%d°: ", i+1);
		//scanf("%d", &x[i]); // Assim ou abaixo:
		scanf("%d", (x+i)); // scanf recebe o endereço!
	}

	printf(" (Atribuindo Matriz Y) \n");
	for (i = 0; i < SIZE; i++) {
		// Ímpar
		if (i%2) {
			*(y+i) = *(x+i)*3;
		// Par
		} else {
			*(y+i) = *(x+i)/2;
		}
	}

	printf("Matriz X: ");
	for (i = 0; i < SIZE; i++) {
		printf("% 5d ", *(x+i));
	}
	printf("\nMatriz Y: ");
	for (i = 0; i < SIZE; i++) {
		printf("% 5d ", *(y+i));
	}
	printf("\n");
}


/**
6. Ler um vetor W de 5 elementos, depois ler um valor V.
Contar e escrever quantas vezes o valor V ocorre no vetor W
e escrever também em que posições (índices) do vetor
W o valor V aparece. Caso o valor V não ocorra nenhuma vez 
no vetor W, escrever uma mensagem informando isto
*/
void questao6() {
	int SIZE = 5;
	char w[SIZE];
	char v;

	printf("Digite %d char's (consecutivos, sem espaço ou ENTER): ", SIZE);
	int i;
	for (i = 0; i < SIZE; i++) {
		*(w+i) = getchar();
	}
	limpaBuffer();

	printf("Digite o char a ser buscado: ");
	v = getchar();

	printf("\n - Resultado da busca: \n");
	int totalOcorrencias = 0;
	for (i = 0; i < SIZE; i++) {
		if (*(w+i) == v) {
			printf("Índice: %d\n", i);
			totalOcorrencias += 1;
		}
	}

	if (totalOcorrencias == 0) {
		printf("Nenhuma ocorrência encontrada\n");
	}
}

/**
7. Ler um vetor C de 4 nomes de pessoas, após pedir que
o usuário digite um nome qualquer de pessoa. Escrever a
mensagem ACHEI, se o nome estiver armazenado no vetor C
ou NÃO ACHEI caso contrário
*/
void questao7() {
	char nomes[100]; // Esse é o 'vetor C' :P
	printf("Digite 4 nomes (separados com espaço): ");
	getPalavra(nomes, 100);

	char nomeASerBuscado[25];
	printf("Digite o nome a ser buscado: ");
	getPalavra(nomeASerBuscado, 25);

	char * pos = strstr(nomes, nomeASerBuscado);

	if (pos == NULL) {
		printf("NÃO ");
	}
	printf("ACHEI\n");
}

/** Retorna a posição do maior elemento da 'matriz' de tamanho 'tamanho'
 *
 * Aqui usa: Atritmética de ponteiros
 */
int maior(int * matriz, int tamanho) {
	// Índice do maior elemento
	int * index = matriz;

	int i;

	for (i = 1; i < tamanho; i++) {
		if (*(matriz+i) > *index) {
			index = (matriz+i);
		}
	}

	return index - matriz;
}
/**
8. Ler um vetor Q de 5 posições (aceitar somente números positivos).
Escrever a seguir o valor do maior elemento de Q e a respectiva
posição que ele ocupa no vetor
*/
void questao8() {
	int SIZE = 5;
	unsigned int q[SIZE];

	printf("Digite %d int's: \n", SIZE);
	int i;
	for (i = 0; i < SIZE; i++) {
		printf("q[%d]: ", i);
		scanf("%d", q+i);
	}

	int indice = maior(q, SIZE);
	printf("Maior: q[%d] = %d \n", indice, *(q+indice));
}


void getInts(int * const vetor, int tamanho) {
	printf("Digite %d int's: \n", tamanho);
	int i;

	for (i = 0; i < tamanho; i++) {
		printf("posicao %d: ", i);
		scanf("%d", (vetor+i));
	}
}

/**
9. Ler um vetor A de 4 elementos inteiros e um valor
X também inteiro. Armazenar em um vetor M o resultado 
de cada elemento de A multiplicado pelo valor X. Logo após,
imprimir o vetor M
*/
void questao9() {
	int SIZE = 4;
	int a[SIZE];
	int m[SIZE];

	getInts(a, SIZE);

	printf("Digite um inteiro: ");
	int x;
	scanf("%d", &x);

	int i;
	for (i = 0; i < SIZE; i++) {
		*(m+i) = *(a+i) * x;
	}

	for (i = 0; i < SIZE; i++) {
		printf("m[%d] = %d\n", i, *(m+i));
	}
}

void getMatrizInts(int * const vetor, int tamLinha, int tamColuna) {
	printf("=================\n");
	printf("Matriz : %d x %d \n", tamLinha, tamColuna);
	printf("=================\n\n");

	int i;
	for (i = 0; i < tamLinha; i++) {
		printf(" -> Linha %d:\n", i);
		getInts(vetor+(i*tamColuna), tamColuna);
	}
}

int getElementoIntMatriz(int const * const matriz, int linha, int coluna, int sizeLinha, int sizeColuna) {
	// Assim:
	//return *(matriz + linha*sizeColuna + coluna);
	// Ou assim:
	return matriz[linha*sizeColuna + coluna];
}

/**
10. Ler uma matriz 4x4 de números inteiros, 
multiplicar os elementos da diagonal principal 
por um número inteiro também lido e escrever a matriz resultante
*/
void questao10() {
	int SIZE = 2;
	int matriz[SIZE][SIZE];
	int * ponteiro = matriz[0];

	getMatrizInts(ponteiro, SIZE, SIZE);

	printf("\nMatriz impressa:\n");
	int elemento;
	int i, j;
	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			elemento = getElementoIntMatriz(ponteiro, i, j, SIZE, SIZE);
			printf("% 8d", elemento);
		}
		printf("\n");
	}

	// Multiplicar elementos da diagonal principal
	int multDiagPrincipal = 1;
	for (i = 0; i < SIZE; i++) {
		multDiagPrincipal *= matriz[i][i];
	}
	printf("\nMultiplicação dos elementos da diag. principal \n");
	printf("Resultado: %d\n", multDiagPrincipal);


	printf("\nMatriz resultante:\n");
	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			elemento = getElementoIntMatriz(ponteiro, i, j, SIZE, SIZE);
			printf("% 8d", elemento*multDiagPrincipal);
		}
		printf("\n");
	}
}

int main() {
	questao1();
	//questao2();
	//questao3();
	//questao4();
	//questao5();
	//questao6();
	//questao7();
	//questao8();
	//questao9();
	//questao10();
}
