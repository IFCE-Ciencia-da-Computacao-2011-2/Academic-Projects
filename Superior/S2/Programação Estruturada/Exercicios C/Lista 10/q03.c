#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TAM 100
typedef struct Efilme{
        char nome[TAM];
        char nome_cliente[TAM];
        int status;
}Efilme;
int n;
Efilme *p;
void cadastro();
void locar();
void consultar();
void liberar();
int main() {
    int stp;
    do{
           printf("\nEntre com o numero de filmes: ");
           scanf("%d",&n);
    }while(n<1);
    p=(Efilme *)malloc(n*sizeof(Efilme));
    printf("\n\nCadastrar os filmes");
    getchar();
    cadastro();
    stp=0;
    for(;;){
            printf("\n\nEntre com uma das opcoes abaixo:");
            printf("\n(1) - Locar filme");
            printf("\n(2) - Liberar filme");
            printf("\n(3) - Consultar lista completa de filme");
            printf("\n(4) - Sair");
            printf("\nOpcao: ");
            scanf("%d",&stp);
            if(stp==4){
                       break;
            }
            else if(stp<1||stp>4){
                             printf("\n\nNumero invalido");
            }
            else{
                 getchar();
                 switch(stp){
                             case 1:
                                  locar();
                             break;
                             case 2:
                                  liberar();
                             break;
                             case 3:
                                  consultar();
                             break;
                 }
            }
    }
    printf("\n\n");
    free(p);
    system("PAUSE");
    return 0;
}

void cadastro(){
     int i;
     for(i=0;i<n;i++){
                      printf("\n\nEntre com o nome do filme: ");
                      gets(p[i].nome);
                      p[i].nome_cliente[0]='\0';
                      p[i].status=0;
     }
}

void locar(){
     int i;
     char aux[TAM];
     printf("\n\nEntre com o nome do filme: ");
     gets(aux);
     for(i=0;i<n;i++){
                      if(strcmp(aux,p[i].nome)==0){
                                                   if(p[i].status==1){
                                                                      printf("\n\nFilme ja esta locado");
                                                   }
                                                   else{
                                                        printf("\nEntre com o nome do cliente: ");
                                                        gets(p[i].nome_cliente);
                                                        p[i].status=1;
                                                        printf("\nFilme locado com sucesso");
                                                   }
                                                   break;
                      }
     }
}

void liberar(){
     int i;
     char aux[TAM];
     printf("\n\nEntre com o nome do filme: ");
     gets(aux);
     for(i=0;i<n;i++){
                      if(strcmp(aux,p[i].nome)==0){
                                                   if(p[i].status==0){
                                                                      printf("\n\nFilme ja esta liberado");
                                                   }
                                                   else{
                                                        printf("\nNome do cliente: %s",p[i].nome_cliente);
                                                        p[i].nome_cliente[0]='\0';
                                                        p[i].status=0;
                                                        printf("\nFilme liberado com sucesso");
                                                   }
                                                   break;
                      }
     }
}

void consultar(){
     int i;
     printf("\n\nLista de filmes");
     for(i=0;i<n;i++){
                      printf("\n%s..........",p[i].nome);
                      if(p[i].status==1){
                                         printf("Filme locado..........%s",p[i].nome_cliente);
                      }
                      else{
                           printf("Filme liberado");
                      }
     }
}
