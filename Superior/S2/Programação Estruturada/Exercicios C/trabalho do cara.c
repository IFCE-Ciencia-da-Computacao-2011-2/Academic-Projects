//ÚLTIMA EDIÇÃO 14/05/2014 00:30

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//ESTRUTURA
struct Imagem{
	int altura;		//ALTURA DA IMAGEM
	int largura;	//LARGURA DA IMAGEM
	int *ponteiro;	//PONTEIRO COM ENDEREÇO DA IMAGEM
};

struct Recorte{
	int altura;		//ALTURA DO RECORTE
	int largura;	//LARGURA DO RECORTE
	int pontoX;		//COORDENADA DA COLUNA DE INICIO DE RECORTE
	int pontoY;		//COORDENADA DA ALTURA DE INICIO DE RECORTE
	int *ponteiro;	//PONTEIRO CONTENDO ENDEREÇO DO RECORTE
};

//PROTOTIPOS DE FUNÇÕES

void preencherDados(struct Recorte *localRecorte , struct Imagem *imagem , int *camada); //PREENCHIMENTO DOS DADOS NESCESSARIOS

void *recorteRegiao(struct Imagem *imagem, struct Recorte *localRecorte); 			// RECORTE DA IMAGEM

void imprimirMatriz(int *ponteiroMatriz , int alturaMatriz , int larguraMatriz); 	//IMPRIMIR MATRIZES

void espelhamento(struct Imagem *imagem, struct Imagem *espelho, int camadas);		//ESPELHAMENTO

void filtroMedia(struct Imagem *novaImagem , struct Imagem *espelho , int camadas);	//FILTRO DA MEDIA

//MAIN

int main ()
{
	int camadas;	//QUANTIDADE DE CAMADAS DO ESPELHAMENTO
	int *camadasPtr = &camadas;	//PONTEIRO DA QUANTIDADE DE CAMADAS DO ESPELHAMENTO
	
	int matrizImagem[3][3] = { {1, 2, 3} , {4,5,6,} , {7, 8, 9} } ;
	
	struct Imagem imagem;	//ESTRUTURA IMAGEM
	imagem.altura = 3;
	imagem.largura = 3;
	imagem.ponteiro = matrizImagem[0];
 	
 	struct Imagem espelho;	//ESTRUTRA ESPELHO
	
	struct Imagem novaImagem;			//ESTRUTRA DA IMAGEM JA FILTRADA
	novaImagem.altura = imagem.altura;	//ALTURA DA NOVA IMAGEM == ALTURA ORIGINAL
	novaImagem.largura = imagem.largura;//LARGURA DA NOVA IMAGEM == LARGURA ORIGINAL
	
	
 	struct Recorte localRecorte; //ESTRUTURA RECORTE
	
	
	preencherDados(&localRecorte, &imagem, camadasPtr ); //PREENCHIMENTO DE DADOS NECESSARIOS

	espelho.ponteiro = (int*)malloc( espelho.altura * espelho.largura * sizeof(int)); //ALOCA MEMORIA PARA O ESPELHO
	
	localRecorte.ponteiro = malloc(localRecorte.altura * localRecorte.largura * sizeof(int)); //ALOCAÇÃO DA MEMORIA DA MATRIZ RECORTE
	
	novaImagem.ponteiro = malloc(novaImagem.altura * novaImagem.largura * sizeof(int));
	
	recorteRegiao (&imagem, &localRecorte);	//RECORTE DA IMAGEM

	espelhamento( &imagem, &espelho, camadas);	 //ESPELHAMENTO
	
	filtroMedia(&novaImagem ,  &espelho , camadas);	//FILTRO DA MEDIA
	
	imprimirMatriz(imagem.ponteiro, imagem.altura, imagem.largura);	//IMPRIMIR MATRIZ PRINCIPAL
	
	imprimirMatriz(localRecorte.ponteiro, localRecorte.altura, localRecorte.largura);	//IMPRIMIR RECORTE	
	
	imprimirMatriz(espelho.ponteiro, espelho.altura, espelho.largura); // IMPRIME MATRIZ ESPELHO
	
	imprimirMatriz(novaImagem.ponteiro, novaImagem.altura, novaImagem.largura);
	
	return 0;
}

//PREENCHER DADOS

void preencherDados(struct Recorte *localRecorte , struct Imagem *imagem , int *camadas) //RECEBE ESTRUTURA DA IMAGEM, ESTRUTURA DO RECORTE E ENDEREÇO A SER ARMAZENADO O VALOR DA QUANTIDADE CAMADAS
{


//--------------------------------------------- ** PONTO Y **----------------------------------------------------------------	

	
	printf("\nDIGITE A COORDENADA DO EIXO Y DE INICIO DO RECORTE:\n");
	scanf("%d" , &localRecorte->pontoY);
	
	//VALIDAÇÃO DA COORDENADA DE INICIO DO RECORTE NO EIXO Y
	
	do{		
		if(localRecorte->pontoY > (imagem->altura)){ // SE O EIXO Y FOR MAIOR QUE ALTURA DO RECORTE
			
			printf("\nDESCULPE, A COORDENADA DIGITADA PARA O EIXO Y  EXCEDE A ALTURA DA IMAGEM!\n");
			printf("\nDIGITE NOVAMENTE A COORDENADA DE INICIO DE RECORTE DO EIXO Y COM NO MAXIMO %d:\n", (imagem->altura - 1)); // -1 POIS COMEÇA DE (0,0)
			
			scanf("%d" , &localRecorte->pontoY); //	USUARIO REESCREVE A COORDENADA DE INCIO DE RECORTE DO EIXO Y
		}
		
	}while (localRecorte->pontoY > (imagem->altura)); //ENQUANTO A COORDENADA DE INICIO DE RECORTE DO EIXO Y FOR MAIOR QUE ALTURA DO RECORTE
	
	
//---------------------------------------------- ** PONTO X **-----------------------------------------------------------------
	
	
	printf("\nDIGITE A COORDENADA DO EIXO X DE INICIO DO RECORTE:\n");
	scanf("%d" , &localRecorte->pontoX);
	
	//VALIDAÇÃO DA COORDENADA DE INICIO DO RECORTE NO EIXO X
	
	do{		
		if(localRecorte->pontoX > (imagem->largura)){ // SE O EIXO X FOR MAIOR QUE ALTURA DO RECORTE
			
			printf("\nDESCULPE, A COORDENADA DIGITADA PARA O EIXO X  EXCEDE A ALTURA DA IMAGEM!\n");
			printf("\nDIGITE NOVAMENTE A COORDENADA DE INICIO DE RECORTE DO EIXO X COM NO MAXIMO %d:\n", (imagem->largura - 1)); // -1 POIS COMEÇA DE (0,0)
			
			scanf("%d" , &localRecorte->pontoX); //	USUARIO REESCREVE A COORDENADA DE INCIO DE RECORTE DO EIXO X
		}
		
	}while (localRecorte->pontoX > (imagem->largura)); //ENQUANTO A COORDENADA DE INICIO DE RECORTE DO EIXO X FOR MAIOR QUE ALTURA DO RECORTE

	
//-----------------------------------------------** ALTURA DO RECORTE **--------------------------------------------------------------------
	
	
	printf("\nDIGITE A ALTURA DO RECORTE:\n"); 
	scanf("%d" , &localRecorte->altura);
	
	do{ //VALIDAÇÃO DA ALTURA DO RECORTE
	
		if(localRecorte->altura > (imagem->altura - localRecorte->pontoY)){ // SE A ALTURA DA ORIGINAL FOR MAIOR QUE ALTURA DO RECORTE
			
			printf("\nDESCULPE, ALTURA DO RECORTE EXCEDE O TAMANHO DA IMAGEM!\n");
			printf("\nDIGITE NOVAMENTE O TAMANHO DO RECORTE COM NO MAXIMO %d DE ALTURA:\n", (imagem->altura - localRecorte->pontoY));
			
			scanf("%d" , &localRecorte->altura); // USUÁRIO REESCREVE ALTURA DO RECORTE
		
		}
		
	} while (localRecorte->altura > (imagem->altura - localRecorte->pontoY)); //ENQUANTO A ALTURA DA ORIGINAL FOR MAIOR QUE ALTURA DO RECORTE
	
	
//-----------------------------------------------** LARGURA DO RECORTE **--------------------------------------------------------------------
	
	
	printf("\nDIGITE A LARGURA DO RECORTE:\n");
	scanf("%d" , &localRecorte->largura);
	
	do{ //VALIDAÇÃO DA LARGURA DO RECORTE
	
		if(localRecorte->largura > (imagem->largura - localRecorte->pontoX)){ //SE LARGURA DA ORIGINAL FOR MAIOR QUE LARGURA DO RECORTE
			
			printf("\nDESCULPE, LARGURA DO RECORTE EXCEDE O TAMANHO DA IMAGEM!");
			printf("\nDIGITE NOVAMENTE O TAMANHO DO RECORTE COM NO MAXIMO %d DE ALTURA:\n", (imagem->largura - localRecorte->pontoX));
			
			scanf("%d" , &localRecorte->largura);
		
		}
		
	} while (localRecorte->largura > (imagem->largura - localRecorte->pontoX));	//ENQUANTO A LARGURA DA ORIGINAL FOR MAIOR QUE LARGURA DO RECORTE

	
//-----------------------------------------------** QUANTIDADE DE CAMADAS DO ESPELHAMENTO **--------------------------------------------------------------------


	printf("\nDIGITE A QUANTIDADE DE CAMADAS DO ESPELHAMENTO:\n");
	scanf("%d" , camadas);
	
	do{ // VALIDAÇÃO DA QUANTIDADE DE CAMADAS DO ESPELHAMENTO
	
		if(*camadas > imagem->altura){ //SE A QUANTIDADE DE CAMADAS FOR MAIOR QUE ALTURA DO RECORTE
			
			printf("\nDESCULPE, O NUMERO DE CAMADAS EXCEDE O TAMANHO DA IMAGEM!");
			printf("\nDIGITE VALORES ENTRE 0 E %d.\n" , imagem->altura);
			scanf("%d" , camadas);
		}
		
	}while (*camadas > imagem->altura); //ENQUANTO A QUANTIDADE DE CAMADAS FOR MAIOR QUE ALTURA DO RECORTE
}


//RECORTE REGIÃO 


void *recorteRegiao (struct Imagem *imagem, struct Recorte *localRecorte){	//RECEBE ESTRUTURA DA IMAGEM E ESTRUTRA DO RECORTE
	
	int i;	//CONTADOR DA COLUNA
	int j;	//CONTADOR DA LINHA
	int w;	// CONTADOR PARA PERCORRER LINHA
	
	for (w = 0 , i = 0 ; i < (localRecorte->altura); i++){ // CONTADOR DE COLUNA
		
		for(j = 0 ; j < (localRecorte->largura) ; w++ , j++){	//CONTADOR DE LINHA
			
			*(localRecorte->ponteiro + w)
			  = 
			 *(imagem->ponteiro + localRecorte->pontoX + j + (imagem->altura) * (localRecorte->pontoY) + (i * imagem->largura) );
		
		}
	}	
}

//IMPRIMIR MATRIZ

void imprimirMatriz(int *ponteiroMatriz , int alturaMatriz , int larguraMatriz){ //RECEBE ENDEREÇO DA MATRIZ A SER EXIBIDA, DEPOIS ALTURA E LARGURA
	
	int i;	//CONTADOR DA COLUNA
	int j;	//CONTADOR DA LINHA
	int w;	// CONTADOR PARA PERCORRER LINHA
	
	for (w = 0 , i = 0 ; i < alturaMatriz ; i++){	// LAÇO DA COLUNA
		
		for(j = 0 ; j < larguraMatriz ; w++ , j++){	//LINHA DA LINHA
			
			printf("%5d" , *(ponteiroMatriz + w));	//EXIBE LINHA POR LINHA
		
		}
		
		printf("\n"); // QUEBRA A LINHA PARA PODER EXIBIR A PRÓXIMA
	
	}
	
	printf("\n"); //PULA MAIS UMA LINHA PARA NÃO EMENDAR MATRIZES DIFERENTES 

}

//ESPELHAMENTO

void espelhamento( struct Imagem *imagem, struct Imagem *espelho , int camadas) //PRIMEIRO RECEBE ESTRUTURA DE QUEM ESPELHAR, ENDEREÇO A SER ARMAZENADO ESPELHO E QTD DE CAMADAS DO ESPELHO
{
	
	int w; //CONTADOR PARA PERCORRER A LINHA
	int y; // CONTADOR PARA PULAR LINHA
	int x; // CONTADOR PARA SUBIR LINHA
	
	espelho->largura = ( 2 * camadas + imagem->largura); //ALTURA E LARGURA DA IMAGEM ESPELHADA
	espelho->altura = espelho->largura;
	
	for( y = 0 ; y < imagem->altura ; y++ ){ // MID
	
		for( w = 0 ; w < imagem->largura ; w++){ // ENQUANTO CONTADOR W FOR MENOR QUE LARGURA DA IMAGEM A SER ESPELHADA 
		
			*(espelho->ponteiro + camadas + w + (y + camadas) * espelho->largura ) = *(imagem->ponteiro + w + (y * imagem->largura)); //
		}
	
	}


	for (y = 0 ; y < camadas ; y++){ //TOP DOWN
	
		for(w = 0 ; w < (imagem->largura) ; w++){ // ENQUANTO CONTADOR W FOR MENOR QUE LARGURA DA IMAGEM A SER ESPELHADA
		
			//TOP
			*(espelho->ponteiro + w + camadas + y * espelho->largura)  = *(espelho->ponteiro + w + camadas +  espelho->largura * (2 * camadas - y - 1) );
			
			//DOWN
			*(espelho->ponteiro + w + camadas + (espelho->largura * (imagem->altura + camadas)) + y * espelho->largura) 
			=
			*(espelho->ponteiro + w  + camadas + (espelho->largura * (imagem->altura + camadas - 1)) - y * espelho->largura) ;
			
		}
	
	}

	for ( y = 0 ; y < espelho->largura ; y++){ //LEFT RIGHT

		for (w = 0 ; w < camadas ; w++) { // ENQUANTO CONTADOR W FOR MENOR QUE QUANTIDADE DE CAMADA DE ESPELHO
	
			*(espelho->ponteiro + w + y * espelho->largura) = *(espelho->ponteiro + camadas + (y * espelho->largura) + (camadas - w - 1)); //LEFT
		
			*(espelho->ponteiro + w + camadas + imagem->largura + y * espelho->largura) //RIGHT
			=
			*(espelho->ponteiro - w + imagem->largura + (camadas - 1) + (y * espelho->largura));
		
		}
	}

}


void filtroMedia(struct Imagem *novaImagem , struct Imagem *espelho , int camadas)
{

	int soma;	// GUARDA A SOMA DOS ELEMENTOS EM TORNO DO PIXEL
	int y;		//COLOCA O CONTADOR NA PROXIMA LINHA
	int x;		//PERCORRE A LINHA
	int i;		//OCOLOCA O CONTADOR NA PROXIMA DA LINHA DA REGIÃO QUE ESTÁ SENDO FILTRADA
	int j;		//CONTADOR QUE ACRESCENTA UM UNIDADE, A CADA INTERAÇÃO, PARA SOMAR OS ELEMENTOS DA LINHA DA REGIÃO QUE ESTÁ SENDO FILTRADA
	int w = 0;	//ACRESCENTA UMA UNIDADE PARA PODER COLOCAR OS VALORES NOS LOCAIS CORRETOS DOS ELEMENTOS DA IMAGEM
	
	int dimFiltro = ((camadas * 2) + 1);	//CADA LINHA DA REGIÃO A SER FILTRADA, DUAS VEZES A QTD DE CAMADAS DO ESPELHO + 1( OS ELEMENTOS DO MEIO)

	int dim = (novaImagem->largura * novaImagem->altura); // ALTURA == LARGURA, ALTURA * LARGURA == TAMANHO DA IMAGEM COMPLETA
	
	for ( y = 0 ; y < novaImagem->altura ; y++ ){		//"PULA LINHA" DA IMAGEM ESPELHADA
		
		for( x = 0; x < novaImagem->largura ; x++){		//PARA PEGAR TODOS OS PIXELs DE CADA LINHA
			
			soma = 0;									//SOMA INICIAL IGUAL A ZERO
			
			for( i = 0 ; i < dimFiltro ; i++){			//"PULA LINHA" DA REGIÃO EM TORNO DO PIXEL, QUE ESTÁ SENDO ESPELHADA
				
				for( j = 0 ; j < dimFiltro ; j++){		//SOMADOR PRIMARIO, PARA ACRESCENTAR OS VALORES EM TORNO DO PIXEL NA SOMA
		
					soma = soma + *(espelho->ponteiro + j + i * ( espelho->largura) + x + y * ( espelho->largura)); //OPERAÇÃO
				}
			}
		*(novaImagem->ponteiro + w) =  soma / (dimFiltro * dimFiltro) ; //GERA A NOVA IMAGEM COM A MEDIA NOS PIXELS 
		printf("\n%d\n" , (dimFiltro * dimFiltro));
		++w;	//SOMADOR DA NOVA IMAGEM, PARA COLOCAR VALORES EM CADA ELEMENTO DA IMAGEM
		}
	}
	
	
}


