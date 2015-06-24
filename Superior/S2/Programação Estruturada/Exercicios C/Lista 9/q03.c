#include <stdio.h>
#include <stdlib.h>
#define TAM 101
void converte(char *pstr);
int main() {
    char str[TAM];
    printf("\nEntre com uma string de ate %d caracteres que tenha so letras minusculas: ",TAM-1);
    gets(str);
    converte(str);
    printf("\n\nString convertida para so letras maiusculas: ");
    puts(str);
    printf("\n\n");
    system("PAUSE");
    return 0;
}

void converte(char *pstr){
     int i;
     for(i=0;pstr[i]!='\0';i++){
                                if(pstr[i]>='a'&&pstr[i]<='z'){
                                                               pstr[i]-=32;
                                }
     }
}
