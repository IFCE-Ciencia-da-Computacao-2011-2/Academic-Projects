#Trabalho Lab Programação
Trabalho da cadeira S2 - Laboratório de Programação
Problema de acentuação:
https://www.gnu.org/software/gettext/FAQ.html#nonascii_strings

##Executar - Linux
	terminal
	cd src/
	make 
	./ManipulaPGM_(arquitetura).e

##Executar - Windows
	cygwin terminal
	cd src/
	make 
	./ManipulaPGM_(arquitetura).exe

##Executar - Mac
	?
	cd src/
	make
	./ManipulaPGM_(arquitetura).app

### Parâmetros:
* (Sem nenhum): Executar programa normalmente
* debug: Executar testes unitários
* simule: Simular as funcionalidades do sistema
* all: debug + simule

##Biblioteca
A biblioteca de arquivos está organizada do seguinte modo:

* main.c: View do sistema
* tests.h: Execução dos testes unitários
* simulaTrabalho.h: Simulação da execução dos requisitos do sistema
* lib/
 * Filtros.h: Filtros em cima da imagemPGM
 * ImagemPGM: Leitura, manipulação e escrita de arquivos no formato PGM: Ascii (P2) e Binário (P5)
 * Mascara.h: Manipulação em uma parte específica de uma MatrizBidimensional
 * MatrizBidimensional: Manipulação de Matrizes bidimensionais de char's. Criação de Transpostas, espelhos e afins. 
 * TilePGM: Manipulação em uma parte específica de uma ImagemPGM
 * tests/ Biblioteca para os testes
 * utils/ Várias funções variadas que são úteis. Estas estão agrupadas por funcionalidade
  * Get.h: Leitura e escrita de dados na entrada e saída padrão
  * Matemática.h: Funções de matemática variadas
  * Menu.h: Exibição simplificada de menu e seus itens
  * ViewUtils.h: Um Get.h de abstração mais alta. Própria para ImagenPGM's

Observe que quase todos os arquivos possuem um *Test.h e *Test.c. É neles que são listados os testes unitários.

##Tarefas:

### Acesso ao arquivo
[x] Leitura de PGM Binário
[x] Leitura de PGM Ascii
[x] Leitura de arquivos com comentario
[x] Leitura de PGM Binário
[x] Escrita de PGM Binário
[x] Escrita de PGM Ascii

### Requisitos do sistema
[x] Entrada e Saída com arquivos (texto e binário): Pontuação: 2.0
[x] Algoritmo de recorte: Pontuação: 2.0
[x] Filtro da média: Pontuação: 2.0
[x] Identiﬁcação da subimagem na imagem original: Pontuação: 4.0

### UX - Interface ao usuário
[x] Menu
[x] Itens do Menu
[x] Capturar opção do menu
[ ] Sair do menu
[ ] Ir para outro menu

### Testes unitários

#### Testes unitários
A última coisa a ser efetivamente feita
[ ] Filtros.h
[ ] ImagemPGM.h
[ ] Mascara.h
[ ] MatrizBidimensional.h
[ ] TilePGM.h
[ ] utils/Get.h
[x] utils/Matematica.h

#### Simulação do trabalho
[x] Entrada e Saída com arquivos texto
[x] Entrada e Saída com arquivos binário
[x] Algoritmo de recorte
[x] Filtro da média
[x] Identiﬁcação da subimagem na imagem original

### Requisitos adicionais do trabalho
[ ] Comentário DEFINIDO em todos os arquivos
/∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗
/∗ Aluno : Paulo Mateus Moura da Silva
/∗ Matricula : 20132045050248 
/∗ Avaliacao 04: Trabalho Final 
/∗ UDM−255 − 2014.1 − Prof . Daniel Ferreira 
/∗ Compilador : Indepente, segue C ANSI
/∗ Compilador : GCC versão: gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1)
/∗                    cygwin64: gcc version 4.8.3 (GCC)
/∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗/
[x] Salvar arquivos no mesmo formato que são lidos (ASCII ou Binário)
[x] Salvar as imagens junto com seus comentários
[x] Utilizar Matrizes de char's e não de inteiros
[x] Makefile

### Outros
[x] SimulaTrabalho
[ ] Generalizar a população de uma matriz a partir de outra: ImagemPGM, TilePGM, Mascara e MatrizBi são todas iguais. tile_copia, imagem_copia. Tem coisa duplicada! (Para corrigir isso)[http://www.cs.rit.edu/~ats/books/ooc.pdf]

## Agradecimentos
* https://eclipse.org/cdt/
* https://www.cygwin.com/
* E aos infinitos fóruns que responderam os infinitos erros que infinitos programadores tinham

