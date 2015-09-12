package matematica.geral;

import static org.junit.Assert.*;

import org.junit.Test;

public class UtilTest {

	@Test
	public void mmcTest() {
		assertEquals(6.0, Util.mmc(2, 3), 0);
		assertEquals(60.0, Util.mmc(12, 20), 0);
	}
	
	@Test
	public void mdcTest() {
		assertEquals(6.0, Util.mdc(30, 72), 0);
	}
}
