#include <stdio.h>
#include <stdlib.h>
#define TAM 100
#define PI 3.14
void area(float *pr,float *pa,int n);
int main() {
    int i,n;
    float r[TAM],a[TAM];
    printf("\nEntre com o numero de esferas(max. %d): ",TAM);
    scanf("%d",&n);
    for(i=0;i<n;i++){
                     printf("\n\nEntre com o raio em metros da %dª esfera: ",i+1);
                     scanf("%f",&r[i]);
    }
    printf("\n\nResultado:");
    area(r,a,n);
    for(i=0;i<n;i++){
                     printf("\n%dª esfera: %.2f",i+1,a[i]);
    }
    printf("\n\n");
    system("PAUSE");
    return 0;
}

void area(float *pr,float *pa,int n){
     int i;
     for(i=0;i<n;i++){
                      pa[i]=4*PI*pr[i]*pr[i];
     }
}
