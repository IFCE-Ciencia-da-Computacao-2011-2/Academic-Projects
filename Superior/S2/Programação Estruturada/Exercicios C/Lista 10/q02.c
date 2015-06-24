#include <stdio.h>
#include <stdlib.h>
#define TAM 100
typedef struct Eloja{
        char nome[TAM];
        int pecas;
        float valor;
}Eloja;
int pecasVendidas(Eloja *p,int n);
float valorTotal(Eloja *p,int n);
void vendeuMais(Eloja *p,int n);
int main() {
    int i,n,pv;
    float vt;
    Eloja *loja,vm;
    do{
          printf("\nEntre com a quantidade de lojas: ");
          scanf("%d",&n);
          if(n<1){
                  printf("\nNumero invalido\n");
          }
    }while(n<1);
    loja=(Eloja *)malloc(n*sizeof(Eloja));
    if(loja==NULL){
                   printf("\n\nERRO - Memoria insuficiente");
                   exit (1);
    }
    printf("\n\nCadastrar as lojas");
    for(i=0;i<n;i++){
                     printf("\n\nNumero de inscricao da loja: %03d",i+1);
                     printf("\nNome: ");
                     getchar();
                     gets(loja[i].nome);
                     printf("\nNumero de pecas vendidas na loja: ");
                     scanf("%d",&loja[i].pecas);
                     printf("\nValor vendido na loja: R$");
                     scanf("%f",&loja[i].valor);
    }
    pv=pecasVendidas(loja,n);
    vt=valorTotal(loja,n);
    printf("\n\nTotal de pecas vendidas em todas as lojas: %d",pv);
    printf("\nValor total vendido em todas as lojas: R$.2f",vt);
    vendeuMais(loja,n);
    printf("\n\n");
    free(loja);
    system("PAUSE");
    return 0;
}

int pecasVendidas(Eloja *p,int n){
    int i,s;
    s=0;
    for(i=0;i<n;i++){
                     s+=p[i].pecas;
    }
    return s;
}

float valorTotal(Eloja *p,int n){
      int i,s;
      s=0;
      for(i=0;i<n;i++){
                       s+=p[i].valor;
      }
      return s;
}

void vendeuMais(Eloja *p,int n){
      int i;
      float aux;
      aux=p[0].valor;
      for(i=1;i<n;i++){
                       if(p[i].valor>aux){
                                                aux=p[i].valor;
                       }
      }
      printf("\n\nLojas que venderam mais");
      for(i=0;i<n;i++){
                       if(p[i].valor==aux){
                                           printf("\nNome: %s",p[i].nome);
                                           printf("\nPecas vendidas: %d",p[i].pecas);
                                           printf("\nValor vendido: R$%.2f\n",p[i].valor);
                       }
      }
}
