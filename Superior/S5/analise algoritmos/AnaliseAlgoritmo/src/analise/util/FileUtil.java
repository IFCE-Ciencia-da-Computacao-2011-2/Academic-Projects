package analise.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class FileUtil {
	public static int[] lerArquivo(String endereco) throws IOException {
		List<Integer> elementos = new ArrayList<>();

		Stream<String> lines = Files.lines(Paths.get(endereco));
		lines.forEach(elemento -> elementos.add(Integer.parseInt(elemento)));
	    lines.close();

	    int[] retorno = new int[elementos.size()];
	    int i = 0;
	    for (Integer elemento : elementos) {
	    	retorno[i] = elemento;
	    	i++;
		}
	    
	    return retorno;
	}
}
