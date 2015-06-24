/* Programa que lê os elementos de um vetor e em seguida faz diversas operações no vetor. */

#include <stdio.h>
#define TAM 100

//Protótipos de funções
int soma(int v[], int n);
float media(int v[], int n);
void ordenaCrescente(int v[], int n);

//Programa principal
int main() {

	//Declaração de variáveis
	int i, j, n, s, aux, valor, q;
	int v[TAM]; //vetor de inteiros v
	float m; //guarda a média aritmética
	char op; //variável que guarda a opção do usuário

	//Leitura da quantidade de elementos do vetor
	printf("\nEntre com a quantidade de elementos - no máximo %d: ",TAM);
	scanf("%d",&n);

	//Armazena os valores dos n elementos no vetor v
	printf("\n");
	for(i=0;i<n;i++) {
		printf("v[%d]: ",i);
		scanf("%d",&v[i]);
	}

	//Laço de execução
	while(1) { //laço "infinito" que termina com um comando break

		//Imprime menu para o usuário
		printf("\n\n==================================================================\n");
		printf("\nEscolha uma das opções abaixo: ");
		printf("\na - Somar elementos do vetor");
		printf("\nb - Média aritmética dos elementos do vetor");
		printf("\nc - Ordenar o vetor em ordem crescente");
		printf("\nd - Ordenar o vetor em ordem decrescente");
		printf("\ne - Maior valor no vetor");
		printf("\nf - Menor valor no vetor");
		printf("\ng - Buscar um elemento no vetor");
		printf("\nh - Contar o número de ocorrências de um elemento no vetor");
		printf("\ni - Imprimir os índices do maior valor no vetor");
		printf("\nj - Imprimir os índices do menor valor no vetor");
		printf("\nk - Contar o número de ocorrências do maior valor no vetor");
		printf("\nl - Contar o número de ocorrências do menor valor no vetor");
		printf("\nm - Imprimir os Q menores elementos no vetor ordenado crescente");
		printf("\nn - Imprimir os Q maiores elementos no vetor ordenado decrescente");
		printf("\no - Sair");
		printf("\n\nOpção: ");
		getchar(); //limpa buffer do teclado
		op = getchar(); //lê opção do usuário
		printf("\n==================================================================\n");
		
		//Verifica se a opção foi de saída do programa
		if(op=='o') //se a opção for 'o' sai do laço de execução com o comando break
			break;

		//Switch para escolha da execução da opção
		switch(op) {
			case 'a':	s = soma(v,n); //chama função soma que calcula a soma dos elementos e retorna o valor
							printf("\nSoma dos elementos do vetor: %d",s);
			break;
			case 'b':	m = media(v,n); //chama função media que calcula a média aritmética dos elementos
							printf("\nMédia aritmética dos elementos do vetor: %.1f",m);
			break;
			case 'c':	ordenaCrescente(v,n); //coloca os elementos do vetor em ordem crescente
							printf("\n\nVetor ordenado em ordem crescente");
							for(i=0;i<n;i++)
								printf("\nv[%d]: %d",i,v[i]);
			break;
	
			default:		printf("\nOpção inválida!");

		} //fim do switch de opções

	} //fim do laço de execução

	printf("\n\n");
	return 0;
} //fim do programa principal


//Soma os elementos do vetor
int soma(int v[], int n) {
	int i,s;
	s = 0; //variável que acumula valores deve ser zerada antes de entrar no laço
	for(i=0;i<n;i++)
		s = s + v[i];
	return s;
}//fim da função soma

//Média aritmética dos elementos do vetor
float media(int v[], int n) {
	int i;
	float m;
	m = 0.0; //variável que acumula valores deve ser zerada antes de entrar no laço
	for(i=0;i<n;i++)
		m = m + v[i];
	m = m/n;
	return m;
}//fim da função media

//Ordenação crescente
void ordenaCrescente(int v[], int n) {
	int i,j,aux;
	for(i=0;i<n-1;i++)
		for(j=i+1;j<n;j++)
			if(v[i]>v[j]) {
				aux = v[i];
				v[i] = v[j];
				v[j] = aux;
			}
}//fim da função ordenaCrescente


