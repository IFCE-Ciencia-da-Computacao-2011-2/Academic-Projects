#include <stdio.h>
#include <stdlib.h>
void ordenacao(int *ni,int n,char op);
int main() {
    int i,n,*ni;
    char op;
    printf("\nEntre com a quantidade de numeros a serem lidos: ");
    scanf("%d",&n);
    ni=(int *)malloc(n*sizeof(int));
    if(ni==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit(1);
    }
    for(i=0;i<n;i++){
                     printf("\n\nEntre com o %dª numero inteiro: ",i+1);
                     scanf("%d",&ni[i]);
    }
    op='\0';
    for(;;){
              printf("\n\nEntre com a opcao de ordenacao");
              printf("\n(c) - Crescente");
              printf("\n(d) - Decrescente");
              printf("\nOpcao: ");
              getchar();
              op=getchar();
              if(op=='c'||op=='C'||op=='d'||op=='D'){
                                                     break;
              }
              else{
                   printf("\n\nOpcao indisponivel");
              }
    }
    ordenacao(ni,n,op);
    printf("\n\n");
    free(ni);
    system("PAUSE");
    return 0;
}

void ordenacao(int *ni,int n,char op){
     int i,j,aux;
     if(op=='c'||op=='C'){
                          for(i=0;i<n-1;i++){
                                           for(j=i+1;j<n;j++){
                                                              if(ni[i]>ni[j]){
                                                                              aux=ni[i];
                                                                              ni[i]=ni[j];
                                                                              ni[j]=aux;
                                                              }
                                           }
                          }
     }
     if(op=='d'||op=='D'){
                          for(i=0;i<n-1;i++){
                                           for(j=i+1;j<n;j++){
                                                              if(ni[i]<ni[j]){
                                                                              aux=ni[i];
                                                                              ni[i]=ni[j];
                                                                              ni[j]=aux;
                                                              }
                                           }
                          }
     }
     printf("\n\nNumeros em ordenados:");
                          for(i=0;i<n;i++){
                                           printf(" %d",ni[i]);
                          }
}
