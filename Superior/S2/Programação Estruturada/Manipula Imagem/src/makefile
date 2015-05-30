#∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗
#∗ Aluno : Paulo Mateus Moura da Silva
#∗ Matricula : 20132045050248 
#∗ Avaliacao 04: Trabalho Final 
#∗ UDM−255 − 2014.1 − Prof . Daniel Ferreira 
#∗ 
#∗ Roda em:
#∗ Linux : GNU Make 3.81
#∗ Windows : (cygwin64) make (GNU texinfo) 5.2
#∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗∗/

# Como gerar um makefile simples
# https://aulasdec.wordpress.com/2011/07/28/utilitarios-make-makefiles-e-sua-importancia/
# Pseudo Wildcard recursivo
# http://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make#answer-2483203
# Detecção de sistema operacional
# http://stackoverflow.com/questions/714100/os-detecting-makefile
# Variáveis
# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_6.html

####################################
# Parâmetros principais
####################################
COMPILADOR = gcc
NOME_PROGRAMA := ManipulaPGM

EXTENSAO_WINDOWS = exe
EXTENSAO_LINUX   = e
EXTENSAO_MAC	 = app

PARAMETROS = -lm
# http://www.faqs.org/faqs/C-faq/faq/ 
# "a longstanding bug in Unix and Linux systems, you usually need to use an explicit -lm flag"

####################################
# Configurando programa
####################################
ifeq ($(OS), Windows_NT)
	ARQUITETURA := $(PROCESSOR_ARCHITECTURE)
	EXTENSAO := $(EXTENSAO_WINDOWS)

else
	SYSTEM := $(shell uname -s)

	ifeq ($(SYSTEM), Linux)
		EXTENSAO := $(EXTENSAO_LINUX)
	endif
	ifeq ($(SYSTEM), Darwin)
		EXTENSAO := $(EXTENSAO_MAC)
	endif

	ARQUITETURA := $(shell uname -p)
endif

NOME_PROGRAMA := $(NOME_PROGRAMA)_$(ARQUITETURA).$(EXTENSAO)


####################################
# Compilando e limpando
####################################

# Buscar todas as imagens que possuem... neste diretório
#HEADERS=$(wildcard *.h)
#FONTES=$(wildcard *.c)
#OBJECTS=$(wildcard *.o)

# Buscar todas as imagens que possuem... (recursivo: Neste e em outros subdiretórios)
HEADERS=$(shell find -type f -name '*.h')
FONTES=$(shell find -type f -name '*.c')
OBJECTS=$(shell find -type f -name '*.o')

# Para cada arquivo .c encontrado, vai chamar o %.o
all: $(FONTES:.c=.o) $(NOME_PROGRAMA) clean

$(NOME_PROGRAMA): $(OBJECTS)
	$(COMPILADOR) -o $(NOME_PROGRAMA) $(OBJECTS) $(PARAMETROS)

%.o: %.c $(HEADERS)
	$(COMPILADOR) -c $< -o $@

clean:
	rm -f $(OBJECTS)



####################################
# Compilando em utf8
####################################
# Execute no terminal
#find -name \*.c -type f | \
#        (while read file; do
#            iconv -f ISO-8859-15 -t UTF-8 "$file" > "${file%.c}.cutf8";
#        done)

FONTES_UTF8=$(shell find -type f -name '*.cutf8')

utf8: $(FONTES_UTF8:.cutf8=.o) NOME_PROGRAMA_UTF8 clean_utf8 clean

NOME_PROGRAMA_UTF8: $(OBJECTS)
	$(COMPILADOR) -o $(NOME_PROGRAMA) $(OBJECTS) $(PARAMETROS)

clean_utf8:
	rm -f $(FONTES_UTF8)
