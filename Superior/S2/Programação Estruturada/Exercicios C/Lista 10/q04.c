#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TAM 50
typedef struct Ecarro{
        char modelo[TAM];
        char marca[TAM];
        char cor[TAM];
}Ecarro;
int main() {
    int i,n,op,c;
    char aux[TAM];
    Ecarro *carro;
    do{
           printf("\nEntre com a quantidade de carros: ");
           scanf("%d",&n);
           if(n<1){
                   printf("\nNumero invalido\n");
           }
    }while(n<1);
    carro=(Ecarro *)malloc(n*sizeof(Ecarro));
    printf("\n\nCadastrar os carros");
    getchar();
    for(i=0;i<n;i++){
                     printf("\n\nCarro: %03d",i+1);
                     printf("\nModelo: ");
                     gets(carro[i].modelo);
                     printf("\nMarca: ");
                     gets(carro[i].marca);
                     printf("\nCor: ");
                     gets(carro[i].cor);
    }
    op=0;
    while(op!=4){
            printf("\n\nSelecione a opcao de busca");
            printf("\n(1) - Modelo");
            printf("\n(2) - Marca");
            printf("\n(3) - Cor");
            printf("\n(4) - Sair");
            printf("\nOpcao: ");
            scanf("%d",&op);
            getchar();
            switch(op){
                       case 1:
                            printf("\n\nEntre com o modelo: ");
                            gets(aux);
                            c=0;
                            for(i=0;i<n;i++){
                                             if(strcmp(carro[i].modelo,aux)==0){
                                                                            printf("\n\nCarro: %03d",i+1);
                                                                            printf("\nModelo: %s",carro[i].modelo);
                                                                            printf("\nMarca: %s",carro[i].marca);
                                                                            printf("\nCor: %s",carro[i].cor);
                                                                            c++;
                                             }
                            }
                            if(c==0){
                                     printf("\n\nModelo indisponivel");
                            }
                       break;
                       case 2:
                            printf("\n\nEntre com a marca: ");
                            gets(aux);
                            c=0;
                            for(i=0;i<n;i++){
                                             if(strcmp(carro[i].marca,aux)==0){
                                                                            printf("\n\nCarro: %03d",i+1);
                                                                            printf("\nModelo: %s",carro[i].modelo);
                                                                            printf("\nMarca: %s",carro[i].marca);
                                                                            printf("\nCor: %s",carro[i].cor);
                                                                            c++;
                                             }
                            }
                            if(c==0){
                                     printf("\n\nmarca indisponivel");
                            }
                       break;
                       case 3:
                            printf("\n\nEntre com a cor: ");
                            gets(aux);
                            c=0;
                            for(i=0;i<n;i++){
                                             if(strcmp(carro[i].cor,aux)==0){
                                                                            printf("\n\nCarro: %03d",i+1);
                                                                            printf("\nModelo: %s",carro[i].modelo);
                                                                            printf("\nMarca: %s",carro[i].marca);
                                                                            printf("\nCor: %s",carro[i].cor);
                                                                            c++;
                                             }
                            }
                            if(c==0){
                                     printf("\n\nMarca indisponivel");
                            }
                       break;
                       case 4:
                       break;
                       default:
                               printf("\n\nNumero indisponivel");
            }
    }
    printf("\n\n");
    free(carro);
    system("PAUSE");
    return 0;
}

