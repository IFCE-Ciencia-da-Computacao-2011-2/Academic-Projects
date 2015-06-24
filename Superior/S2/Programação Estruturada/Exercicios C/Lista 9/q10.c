#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
    char stp,consulta[TAM];
    struct Ficha *ficha;
    printf("\nEntre com a quantidade de clientes(max. %d): ",TAM);
    scanf("%d",&n);
    ficha=(struct Ficha *)malloc(n*sizeof(struct Ficha));
    if(ficha==NULL){
                    printf("\n\nERRO - Memoria insuficiente");
    }
    printf("\nCadastro das fichas dos clientes");
    printf("\nEntre com os dados dos clientes:");
    getchar();
    for(i=0;i<n;i++){
                     printf("\nNumero de inscricao do cliente: %03d",i+1);
                     printf("\nNome: ");
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
                                        printf("\n\nEntre com o nome do cliente: ");
                                        getchar();
                                        gets(consulta);
                                        i=0;
                                        while(1){
                                                         if(!(strcmp(consulta,ficha[i].nome))){
                                                                                               printf("\n\nConsulta do cadastro do cliente: ");
                                                                                               puts(ficha[i].nome);
                                                                                               printf("\nNome: ");
                                                                                               puts(ficha[i].nome);
                                                                                               printf("\nTelefone: %li",ficha[i].telefone);
                                                                                               printf("\nLogradouro: ");
                                                                                               puts(ficha[i].logradouro);
                                                                                               printf("\nNumero: %d",ficha[i].numero);
                                                                                               printf("\nCEP: %li",ficha[i].cep);
                                                                                               printf("\nProfissao: ");
                                                                                               puts(ficha[i].profissao);
                                                                                               break;
                                                         }
                                                         i++;
                                        }
            }
            else{
                 printf("\n\nOpcao indisponivel");
            }
            getchar();
    }
    printf("\n\n");
    free(ficha);
    system("PAUSE");
    return 0;
}
