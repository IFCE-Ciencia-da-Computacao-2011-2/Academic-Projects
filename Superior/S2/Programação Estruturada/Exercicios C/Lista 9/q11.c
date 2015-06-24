#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TAM 100
struct tipo_endereco{
       char rua[TAM];
       int numero;
       char bairro[TAM];
       char cidade[TAM];
       char sigla_estado[3];
       long int cep;
};
struct ficha_pessoal{
       char nome[TAM];
       long int telefone;
       struct tipo_endereco endereco;
};
struct ficha_pessoal *alocar(int n);
struct ficha_pessoal *liberar(struct ficha_pessoal *ficha);
void cadastro(struct ficha_pessoal *ficha,int n);
void consulta_nome(struct ficha_pessoal *ficha,int n,char *consulta);
void consulta_completa(struct ficha_pessoal *ficha,int n);
int main() {
    int n,op;
    struct ficha_pessoal *ficha;
    char consulta[TAM];
    n=0;
    do{
         printf("\nEntre com a quantidade de clientes: ");
         scanf("%i",&n);
         if(n<1){
                 printf("\n\nNumero invalido");
         }
    }while(n<1);
    ficha=alocar(n);
    if(ficha==NULL){
                    printf("\n\nERRO - Memoria insuficiente");
                    exit (1);
    }
    cadastro(ficha,n);
    for(;;){
            printf("\n\nOpcoes de consulta");
            printf("\n(1) - Consulta por nome");
            printf("\n(2) - Consulta ficha completa");
            printf("\n(3) - Sair");
            printf("\nOpcao: ");
            scanf("%i",&op);
            switch(op){
                       case 1:
                            printf("\n\nEntre com o nome do cliente: ");
                            getchar();
                            gets(consulta);
                            consulta_nome(ficha,n,consulta);
                       break;
                       case 2:
                            consulta_completa(ficha,n);
                       break;
                       case 3:
                       break;
                       break;
                       default:
                               printf("\nOpcao indisponivel");
                       break;
            }
            if(op==3){
                      break;
            }
    }
    printf("\n\n");
    ficha=liberar(ficha);
    system("PAUSE");
    return 0;
}

struct ficha_pessoal *alocar(int n){
       struct ficha_pessoal *p;
       p=(struct ficha_pessoal *)malloc(n*sizeof(struct ficha_pessoal));
       return (p);
}

struct ficha_pessoal *liberar(struct ficha_pessoal *ficha){
       free (ficha);
       return (NULL);
}

void cadastro(struct ficha_pessoal *ficha,int n){
     int i;
     for(i=0;i<n;i++){
                      printf("\n\nNumero de inscricao do cliente: %03d",i+1);
                      printf("\nNome: ");
                      getchar();
                      gets(ficha[i].nome);
                      printf("\nTelefone: ");
                      scanf("%li",&ficha[i].telefone);
                      printf("\n\nDados do endereco");
                      printf("\nRua: ");
                      getchar();
                      gets(ficha[i].endereco.rua);
                      printf("\nNumero: ");
                      scanf("%i",&ficha[i].endereco.numero);
                      printf("\nBairro: ");
                      getchar();
                      gets(ficha[i].endereco.bairro);
                      printf("\nCidade: ");
                      gets(ficha[i].endereco.cidade);
                      printf("\nSigla do estado: ");
                      gets(ficha[i].endereco.sigla_estado);
                      printf("\nCEP: ");
                      scanf("%li",&ficha[i].endereco.cep);
     }
}

void consulta_nome(struct ficha_pessoal *ficha,int n,char *consulta){
     int i;
     for(i=0;i<n;i++){
                      if(!(strcmp(consulta,ficha[i].nome))){
                                                            printf("\n\nConsulta do cadastro do cliente: ");
                                                            puts(ficha[i].nome);
                                                            printf("\nNome: ");
                                                            puts(ficha[i].nome);
                                                            printf("\nTelefone: %li",ficha[i].telefone);
                                                            printf("\n\nDados do endereco");
                                                            printf("\nRua: ");
                                                            puts(ficha[i].endereco.rua);
                                                            printf("\nNumero: %i",ficha[i].endereco.numero);
                                                            printf("\nBairro: ");
                                                            puts(ficha[i].endereco.bairro);
                                                            printf("\nCidade: ");
                                                            puts(ficha[i].endereco.cidade);
                                                            printf("\nSigla do estado: ");
                                                            puts(ficha[i].endereco.sigla_estado);
                                                            printf("\nCEP: %li",ficha[i].endereco.cep);
                                                            break;
                      }
     }
}

void consulta_completa(struct ficha_pessoal *ficha,int n){
     int i;
     for(i=0;i<n;i++){
                      printf("\n\nConsulta do cadastro do cliente: ");
                      puts(ficha[i].nome);
                      printf("\nNome: ");
                      puts(ficha[i].nome);
                      printf("\nTelefone: %li",ficha[i].telefone);
                      printf("\n\nDados do endereco");
                      printf("\nRua: ");
                      puts(ficha[i].endereco.rua);
                      printf("\nNumero: %i",ficha[i].endereco.numero);
                      printf("\nBairro: ");
                      puts(ficha[i].endereco.bairro);
                      printf("\nCidade: ");
                      puts(ficha[i].endereco.cidade);
                      printf("\nSigla do estado: ");
                      puts(ficha[i].endereco.sigla_estado);
                      printf("\nCEP: %li",ficha[i].endereco.cep);
     }
}
