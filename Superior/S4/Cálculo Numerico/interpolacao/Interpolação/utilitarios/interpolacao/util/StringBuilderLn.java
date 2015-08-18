package interpolacao.util;

public class StringBuilderLn {
	private StringBuilder builder = new StringBuilder();

	public void appendLn() {
		appendLn("");
	}

	public void appendLn(Object object) {
		appendLn(object.toString());
	}

	public void appendLn(String string) {
		append(string);
		append("\n");
	}
	
	public void append(Object object) {
		append(object.toString());
	}

	public void append(String string) {
		builder.append(string);
	}

	@Override
	public String toString() {
		return builder.toString();
	}
}