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
Eloja vendeuMais(Eloja *p,int n);
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
    vm=vendeuMais(loja,n);
    printf("\n\nTotal de pecas vendidas em todas as lojas: %d",pv);
    printf("\nValor total vendido em todas as lojas: R$.2f",vt);
    printf("\n\nLoja que vendeu mais: %s",vm.nome);
    printf("\nNumero de pecas vendidas na loja: %d",vm.pecas);
    printf("\nValor vendido na loja: R$%.2f",vm.valor);
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

Eloja vendeuMais(Eloja *p,int n){
      int i;
      Eloja aux;
      aux=p[0];
      for(i=1;i<n;i++){
                       if(p[i].valor>aux.valor){
                                                aux=p[i];
                       }
      }
      return aux;
}
