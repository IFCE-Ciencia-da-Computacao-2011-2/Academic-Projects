#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TAM 100
struct Eturma{
       char nome[TAM];
       float nota1;
       float nota2;
       float media;
       char situacao[TAM];
};
float media(float n1,float n2);
float media_geral(struct Eturma *aluno,int n);
int main() {
    int i,n;
    float mg;
    struct Eturma *aluno;
    do{
        printf("\nEntre com a quantidade de alunos(max %i): ",TAM);
        scanf("%i",&n);
        if(n<1||n>TAM){
                printf("\nNumero invalido\n");
        }
    }while(n<1||n>TAM);
    aluno=(struct Eturma *)malloc(n*sizeof(struct Eturma));
    for(i=0;i<n;i++){
                      printf("\n\nCadastro do aluno: %03i",i+1);
                      printf("\nEntre com o nome do aluno: ");
                      getchar();
                      gets(aluno[i].nome);
                      printf("\nEntre com a 1� nota: ");
                      scanf("%f",&aluno[i].nota1);
                      printf("\nEntre com a 2� nota: ");
                      scanf("%f",&aluno[i].nota2);
                      aluno[i].media=media(aluno[i].nota1,aluno[i].nota2);
                      printf("\nMedia: %.1f",aluno[i].media);
                      if(aluno[i].media>=6.){
                                             strcpy(aluno[i].situacao,"Aprovado");
                                             printf("\nSituacao: ");
                                             puts(aluno[i].situacao);
                      }
                      else{
                           strcpy(aluno[i].situacao,"Reprovado");
                           printf("\nSituacao: ");
                           puts(aluno[i].situacao);
                      }
     }
     printf("\n\nConsulta do cadastro dos alunos");
     for(i=0;i<n;i++){
                      printf("\n\nConsulta do cadastro do aluno: %03i",i+1);
                      printf("\nNome: ");
                      puts(aluno[i].nome);
                      printf("\n1� Nota: %.1f",aluno[i].nota1);
                      printf("\n2� Nota: %.1f",aluno[i].nota2);
                      printf("\nMedia: %.1f",aluno[i].media);
                      printf("\nSituacao: ");
                      puts(aluno[i].situacao);
     }
     mg=media_geral(aluno,n);
     printf("\n\nMedia geral da turma: %.1f",mg);
     printf("\n\n");
     free(aluno);
     system("PAUSE");
     return 0;
}

float media(float n1,float n2){
      float m;
      m=(2*n1+3*n2)/5;
      return m;
}

float media_geral(struct Eturma aluno[],int n){
      int i;
      float sg,mg;
      sg=0.;
      for(i=0;i<n;i++){
                       sg+=aluno[i].media;
      }
      mg=sg/n;
      return mg;
}
