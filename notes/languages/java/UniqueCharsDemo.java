/* Алгоритм, определяющий, все ли символы в строке встречаются один
 * раз. Дополнительные структуры данных использовать нельзя. Допустим,
 * используется набор ASCII (если Unicode, нужно увеличить объем
 * памяти для хранения строки, но логика решения остается той же.
 */

class UniqueChars {
    public boolean isUniqueChars(String str) {
	if (str.length() > 256) return false;

	boolean[] char_set = new boolean[256];
	for (int i = 0; i < str.length(); i++) {
	    int val = str.charAt(i);
	    if (char_set[val]) {    // Символ уже был найден в строке
		return false;
	    }
        
	    char_set[val] = true;
	}
	return true;
    }
}

class UniqueCharsDemo {
    public static void main(String [] args) {

	String str1 = "abcd";
	String str2 = "abbcd";

	UniqueChars uc = new UniqueChars();

	System.out.println(uc.isUniqueChars(str1));
	System.out.println(uc.isUniqueChars(str2));
    }
}
