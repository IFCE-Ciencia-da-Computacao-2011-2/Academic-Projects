#include "../tests/tests_utils.h"
#include "../tests/thc.h"
#include "Get.h"

/****************************************
 * Testes relacionados a Get.h
 ****************************************/
static void extensaoValidaTest() {
	cabecalho("extensaoValidaTest()");
	ENSURE(extensaoValida("teste.xml", "xml"));
	ENSURE(extensaoValida("teste.xml", "XML"));
	ENSURE(extensaoValida("teste.XML", "xml"));
	ENSURE(extensaoValida("teste.XML", "XML"));
	ENSURE(extensaoValida("teste.JPg", "jpG"));

	ENSURE(!extensaoValida("teste.Uml", "xml"));
	ENSURE(!extensaoValida("macarronada.Uml", "xml"));

	ENSURE(extensaoValida("macarronada.png", "PnG"));
	ENSURE(!extensaoValida("macarronada", "PnG"));

	ENSURE(!extensaoValida("cmd", "cmd"));
	ENSURE(extensaoValida(".cmd", "cmd"));

	ENSURE(!extensaoValida("macarronada.png", ""));
	ENSURE(!extensaoValida("", ""));
	ENSURE(!extensaoValida("cmd", ""));
	ENSURE(!extensaoValida("a", "cmd"));
}


/****************************************
 * Main - Para fins de teste
 ****************************************/
void get_test() {
	thc_addtest(extensaoValidaTest);
}
