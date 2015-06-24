#include <stdio.h>
#include <stdlib.h>
#define TAM 100
struct Ficha{
       char nome[TAM];
       long int telefone;
       char logradouro[TAM];
       int numero;
       long int cep;
       char profissao[TAM];
};
int main() {
    struct Ficha ficha;
    printf("\nCadastro da ficha do cliente");
    printf("\nEntre com os dados do cliente:");
    printf("\nNome: ");
    gets(ficha.nome);
    printf("\nTelefone: ");
    scanf("%li",ficha.telefone);
    printf("\nLogradouro: ");
    getchar();
    gets(ficha.logradouro);
    printf("\nNumero: ");
    scanf("%d",&ficha.numero);
    printf("\nCEP: ");
    scanf("%li",&ficha.cep);
    printf("\nProfissao: ");
    getchar();
    gets(ficha.profissao);
    printf("\n\nConsulta do cadastro do cliente");
    printf("\nNome: ");
    puts(ficha.nome);
    printf("\nTelefone: %li",ficha.telefone);
    printf("\nLogradouro: ");
    puts(ficha.logradouro);
    printf("\nNumero: %d",ficha.numero);
    printf("\nCEP: %li",ficha.cep);
    printf("\nProfissao: ");
    puts(ficha.profissao);
    printf("\n\n");
    system("PAUSE");
    return 0;
}
