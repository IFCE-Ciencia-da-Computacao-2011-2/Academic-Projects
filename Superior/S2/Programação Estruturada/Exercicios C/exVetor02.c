/* 
Faça um programa em C que solicite a quantidade n de clientes de uma empresa. Em seguida:
a) Leia o crédito de cada um dos n clientes. O crédito de cada cliente deve ser armazenado no vetor c;
b) Faça uma função de nome maiorCredito que receba o vetor c e retorne o valor do maior crédito. Imprima este valor pela função principal;
c) Faça uma função de nome menorCredito que receba o vetor c e retorne o valor do menor crédito. Imprima este valor pela função principal;
d) Faça uma função de nome somaCredito que receba o vetor c e retorne o valor da soma de todos os créditos no vetor. Imprima este valor pela função principal;
e) Faça uma função com o protótipo: int contaCredito(float v[], float valor, int n). A função deve retornar a quantidade de clientes no vetor v com crédito igual a valor. Solicite o valor de pesquisa pelo teclado na função principal. Imprima a quantidade pela função principal;
f) Imprima a quantidade de clientes com crédito igual ao menor crédito. Utilize a função contaCredito;
g) Faça uma função com o protótipo: void ordenaCrescente(float v[], int n). A função deve ordenar o vetor v em ordem crescente de valores. Chame a função passando o vetor c para ela e imprima o vetor c pela função principal em seguida;
h) Imprima o valor médio dos créditos no vetor c. Utilize a função somaCredito para isso.
*/

#include <stdio.h>
#define TAM 100

float maiorCredito(float v[], int n);
float menorCredito(float v[], int n);
float somaCredito(float v[], int n);
int contaCredito(float v[], float valor, int n);
void ordenaCrescente(float v[], int n);

int main() {
	int i, n, cont;
	float c[TAM], maiorC, menorC, somaC, mediaC, valor;

	//Entrada da quantidade de clientes
	printf("\n=============================================");
	printf("\nEntre com a quantidade de clientes: ");
	scanf("%d",&n);

	//Laço de leitura dos créditos dos clientes
	printf("\n=============================================\n");
	for(i=0;i<n;i++) {
		printf("Entre com crédito do cliente %d R$: ",i+1);
		scanf("%f",&c[i]);
	}
	
	//Determinação do maior crédito
	printf("\n\n=============================================");
	maiorC = maiorCredito(c,n);
	printf("\n*** Maior crédito: R$ %.2f",maiorC);

	//Determinação do menor crédito
	printf("\n\n=============================================");
	menorC = menorCredito(c,n);
	printf("\n*** Menor crédito: R$ %.2f",menorC);

	//Determinação da soma dos créditos
	printf("\n\n=============================================");
	somaC = somaCredito(c,n);
	printf("\n*** Soma dos créditos: R$ %.2f",somaC);

	//Determinação da quantidade de clientes com crédito igual a valor
	printf("\n\n=============================================");
	printf("\nEntre com o valor de pesquisa: ");
	scanf("%f",&valor);
	cont = contaCredito(c,valor,n);
	printf("\n*** Quant. de clientes com crédito igual a R$ %.2f: %d",valor, cont);

	//Determinação da quantidade de clientes com crédito igual ao menor crédito
	printf("\n\n=============================================");
	cont = contaCredito(c,menorC,n);
	printf("\n*** Quant. de clientes com crédito igual ao menor crédito R$ %.2f: %d",menorC, cont);

	//Ordena e imprime os créditos em ordem crescente
	printf("\n\n=============================================");
	ordenaCrescente(c,n); //a função é chamada e ordena o vetor c em ordem crescente
	printf("\n*** Créditos em ordem crescente: ");
	for(i=0;i<n;i++)
		printf("\n%dº crédito: R$ %8.2f",i+1,c[i]);

	//Determina a média aritmética dos créditos
	printf("\n\n=============================================");
	mediaC = somaCredito(c,n)/n;
	printf("\n*** Média dos créditos: R$ %.2f",mediaC);

	printf("\n\n");
	return 0;
}

float maiorCredito(float v[], int n) {
	int i;
	float aux;
	aux = v[0];
	for(i=1;i<n;i++)
		if(v[i]>aux)
			aux = v[i];
	return aux;
}

float menorCredito(float v[], int n) {
	int i;
	float aux;
	aux = v[0];
	for(i=1;i<n;i++)
		if(v[i]<aux)
			aux = v[i];
	return aux;
}

float somaCredito(float v[], int n) {
	int i;
	float s;
	s = 0.0;
	for(i=0;i<n;i++)
		s = s + v[i];
	return s;
}

int contaCredito(float v[], float valor, int n) {
	int i, cont;
	cont = 0;
	for(i=0;i<n;i++)
		if(v[i] == valor)
			cont = cont + 1;
	return cont;
}

void ordenaCrescente(float v[], int n) {
	int i,j;
	float aux;
	for(i=0;i<n-1;i++)
		for(j=i+1;j<n;j++)
			if(v[i]>v[j]) {
				aux = v[i];
				v[i] = v[j];
				v[j] = aux;
			}
}
