#include <stdio.h>
#include <stdlib.h>
float media(float n1,float n2);
float mediageral(float m[],int n);
int main() {
    int n,i;
    float *n1,*n2,*m,mg;
    char stp;
    printf("\nEntre com a quantidade de alunos: ");
    scanf("%d",&n);
    n1=(float *)malloc(n*sizeof(float));
    if(n1==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit (1);
    }
    n2=(float *)malloc(n*sizeof(float));
    if(n2==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit (1);
    }
    m=(float *)malloc(n*sizeof(float));
    if(m==NULL){
                 printf("\n\nERRO - Memoria insuficiente");
                 exit (1);
    }
    for(i=0;i<n;i++){
                     printf("\n\nEntre com a 1ª nota do %dª aluno: ",i+1);
                     scanf("%f",&n1[i]);
                     printf("\n\nEntre com a 2ª nota do %dª aluno: ",i+1);
                     scanf("%f",&n2[i]);
                     m[i]=media(n1[i],n2[i]);
                     if(m[i]>=6.){
                                  printf("\nAPROVADO");
                     }
                     else{
                          printf("\nREPROVADO");
                     }
                     printf("\nMedia: %.1f",m[i]);
    }
    mg=mediageral(m,n);
    printf("\n\nMedia geral da turma: %.1f",mg);
    stp='\0';
    for(;;){
                     printf("\n\nDeseja consultar a situacao de algum aluno?");
                     printf("\nSim - S\tNao - N");
                     printf("\nOpcao: ");
                     getchar();
                     stp=getchar();
                     if(stp=='N'||stp=='n'){
                                  break;
                     }
                     else{
                          printf("\n\nEntre com o indice do aluno: ");
                          scanf("%d",&i);
                          printf("\n1ª nota: %.1f",n1[i-1]);
                          printf("\n2ª nota: %.1f",n2[i-1]);
                          printf("\nMedia: %.1f",m[i-1]);
                          printf("\nSituacao: ");
                          if(m[i-1]>=6.){
                                         printf("APROVADO");
                          }
                          else{
                               printf("REPROVADO");
                          }
                     }
    }                                                          
    printf("\n\n");
    system("PAUSE");
    free(n1);
    free(n2);
    free(m);
    return 0;
}
float media(float n1,float n2){
      float media;
      media=(2*n1+3*n2)/5;
      return media;
}
float mediageral(float m[],int n){
      float s,mg;
      int i;
      s=0.;
      for(i=0;i<n;i++){
                       s+=m[i];
      }
      mg=s/n;
      return mg;
}
