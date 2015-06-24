#include <stdio.h>
#include <stdlib.h>
#define TAM 101
char aux[TAM];
void troca_caractere(char *s,char a,char b);
int main() {
    char str[TAM],a,b;
    printf("\nEntre com uma string de ate %d caracters: ",TAM-1);
    gets(str);
    printf("\nEntre com o caractere que deve ser substituido na string: ");
    a=getchar();
    printf("\nEntre com o caractere que deve substituir %c na string: ",a);
    getchar();
    b=getchar();
    troca_caractere(str,a,b);
    printf("\n\nString digitada: ");
    puts(str);
    printf("\nString com os caracteres trocados: ");
    puts(aux);
    printf("\n\n");
    system("PAUSE");
    return 0;
}
void troca_caractere(char *s,char a,char b){
     int i;
     for(i=0;s[i]!='\0';i++){
                             aux[i]=s[i];
     }
     aux[i]='\0';
     for(i=0;aux[i]!='\0';i++){
                               if(aux[i]==a){
                                             aux[i]=b;
                               }
     }
}
