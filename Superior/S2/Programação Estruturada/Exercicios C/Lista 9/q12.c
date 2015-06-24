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
int main() {
    int i,n;
    float sg,mg;
    struct Eturma aluno[TAM];
    do{
        printf("\nEntre com a quantidade de alunos(max %i): ",TAM);
        scanf("%i",&n);
        if(n<1||n>TAM){
                printf("\nNumero invalido\n");
        }
    }while(n<1||n>TAM);
    for(i=0;i<n;i++){
                      printf("\n\nCadastro do aluno: %03i",i+1);
                      printf("\nEntre com o nome do aluno: ");
                      getchar();
                      gets(aluno[i].nome);
                      printf("\nEntre com a 1ª nota: ");
                      scanf("%f",&aluno[i].nota1);
                      printf("\nEntre com a 2ª nota: ");
                      scanf("%f",&aluno[i].nota2);
                      aluno[i].media=(2*aluno[i].nota1+3*aluno[i].nota2)/5;
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
                      printf("\n1ª Nota: %.1f",aluno[i].nota1);
                      printf("\n2ª Nota: %.1f",aluno[i].nota2);
                      printf("\nMedia: %.1f",aluno[i].media);
                      printf("\nSituacao: ");
                      puts(aluno[i].situacao);
     }
     sg=0.;
     for(i=0;i<n;i++){
                      sg+=aluno[i].media;
     }
     mg=sg/n;
     printf("\n\nMedia geral da turma: %.1f",mg);
     printf("\n\n");
     system("PAUSE");
     return 0;
}
