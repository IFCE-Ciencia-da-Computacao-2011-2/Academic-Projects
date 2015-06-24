#include <stdio.h>
#include <stdlib.h>
void temf(float *tc,float *tf,int N);
float media(float *t,int n);
int main() {
    int i,n;
    float *tc,*tf,mtc,mtf;
    printf("\nEntre com a quantidade de temperaturas a serem lidas: ");
    scanf("%d",&n);
    tc=(float *)malloc(n*sizeof(float));
    if(tc==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit (1);
    }
    tf=(float *)malloc(n*sizeof(float));
    if(tf==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit (1);
    }
    for(i=0;i<n;i++){
                     printf("\n\nEntre com a %dª temperatura em graus Celsius: ",i+1);
                     scanf("%f",&tc[i]);
    }
   	temf(tc,tf,n);
    for(i=0;i<n;i++){
                     printf("\n%d temperatura em graus Celsius: %.2fºC",i+1,tc[i]);
                     printf("\n%d temperatura em graus Fahrenheit: %.2fºF",i+1,tf[i]);
    }
    mtc=media(tc,n);
    mtf=media(tf,n);
    printf("\n\nMedia aritmetica das temperaturas em graus Celsius: %.2fºC",mtc);
    printf("\nMedia aritmetica das temperaturas em graus Fahrenheit: %.2fºF",mtf);
    printf("\n\n");
    free(tc);
    free(tf);
    system("PAUSE");
    return 0;
}

void temf(float *tc,float *tf,int n){
	int i;
	for(i=0;i<n;i++){
		tf[i]=tc[i]*9/5+32;
	}
}

float media(float *t,int n){
      int i;
      float s,m;
      s=0.;
      for(i=0;i<n;i++){
                       s+=t[i];
      }
      m=s/n;
      return m;
}
