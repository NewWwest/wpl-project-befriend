package nativejava;

import java.util.Collections;
import java.util.List;

public class JavaProxy {
	public static <T> List<T> j_shuffle(List<T> input) {
		Collections.shuffle(input);
		return input;
	}
	public static String j_uuid() {
		return java.util.UUID.randomUUID().toString();
	}
}
