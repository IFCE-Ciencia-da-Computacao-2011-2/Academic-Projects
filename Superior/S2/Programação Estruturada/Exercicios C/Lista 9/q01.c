#include <stdio.h>
#define TAM 100
float soma(float *pn,int n);
int main() {
    int n,i;
    float ns[TAM],s;
    printf("\nEntre com a quantidade de numeros(max. %d): ",TAM);
    scanf("%d",&n);
    for(i=0;i<n;i++){
                     printf("\n\nEntre com o %dª numero: ",i+1);
                     scanf("%f",&ns[i]);
    }
    s=soma(ns,n);
    printf("\n\nResultado da soma: %.2f",s);
    printf("\n\n");
    return 0;
}

float soma(float *pn,int n){
      float soma;
      int i;
      soma=0.;
      for(i=0;i<n;i++){
                       soma+=pn[i];
      }
      return soma;
}
