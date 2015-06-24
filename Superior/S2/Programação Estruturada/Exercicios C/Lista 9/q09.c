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
    int i,n;
    char stp;
    struct Ficha ficha[TAM];
    printf("\nEntre com a quantidade de clientes(max. %d): ",TAM);
    scanf("%d",&n);
    printf("\nCadastro das fichas dos clientes");
    printf("\nEntre com os dados dos clientes:");
    for(i=0;i<n;i++){
                     printf("\nNumero de inscricao do cliente: %03d",i+1);
                     printf("\nNome: ");
                     getchar();
                     gets(ficha[i].nome);
                     printf("\nTelefone: ");
                     scanf("%li",&ficha[i].telefone);
                     printf("\nLogradouro: ");
                     getchar();
                     gets(ficha[i].logradouro);
                     printf("\nNumero: ");
                     scanf("%d",&ficha[i].numero);
                     printf("\nCEP: ");
                     scanf("%li",&ficha[i].cep);
                     printf("\nProfissao: ");
                     getchar();
                     gets(ficha[i].profissao);
    }
    stp='\0';
    for(;;){
            printf("\n\nDeseja consultar a ficha de algum cliente?");
            printf("\nSim - S\tNao - N");
            printf("\nOpcao: ");
            stp=getchar();
            if(stp=='N'||stp=='n'){
                                   break;
            }
            else if(stp=='S'||stp=='s'){
                                        printf("\n\nEntre com o numero de inscricao do cliente: ");
                                        scanf("%d",&i);
                                        printf("\n\nConsulta do cadastro do cliente: %03d",i);
                                        printf("\nNome: ");
                                        puts(ficha[i-1].nome);
                                        printf("\nTelefone: %li",ficha[i-1].telefone);
                                        printf("\nLogradouro: ");
                                        puts(ficha[i-1].logradouro);
                                        printf("\nNumero: %d",ficha[i-1].numero);
                                        printf("\nCEP: %li",ficha[i-1].cep);
                                        printf("\nProfissao: ");
                                        puts(ficha[i-1].profissao);
            }
            else{
                 printf("\n\nOpcao indisponivel");
            }
            getchar();
    }
    printf("\n\n");
    system("PAUSE");
    return 0;
}
