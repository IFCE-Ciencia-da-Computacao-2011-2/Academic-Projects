package interpolacao.util;

import static org.junit.Assert.*;

import org.junit.Test;

public class MatTest {

	@Test
	public void mmcTest() {
		assertEquals(6.0, Mat.mmc(2, 3), 0);
		assertEquals(60.0, Mat.mmc(12, 20), 0);
	}
	
	@Test
	public void mdcTest() {
		assertEquals(6.0, Mat.mdc(30, 72), 0);
	}
}
