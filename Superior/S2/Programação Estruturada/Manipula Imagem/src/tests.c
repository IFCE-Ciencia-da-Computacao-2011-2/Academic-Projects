#include "lib/tests/thc.h"
#include "lib/utils/MatematicaTest.h"
#include "lib/utils/GetTest.h"
#include "lib/FiltrosTest.h"
#include "lib/MatrizBidimensionalTest.h"
#include "lib/TilePGMTest.h"
#include "lib/ImagemPGMTest.h"

int main_tests() {
	matematica_test();
	get_test();

	matriz_test();
	tile_test();
	imagem_test();
	filtros_test();

    return thc_run(THC_VERBOSE);
}
