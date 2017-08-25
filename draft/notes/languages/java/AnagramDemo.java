/* Для двух строк напишите метод, определяющий, является ли одна
 * строка перестановкой другой. 
 */

class Anagram {
    public String sort(String s) {
        char[] ch = s.toCharArray();
        java.util.Arrays.sort(ch);
        return new String(ch);
    }

    public boolean isAnagram(String str1, String str2) {
        if (str1.length() != str2.length()) {
            return false;
	}

        return sort(str1).equals(sort(str2));

    }
}

class AnagramDemo {
    public static void main(String[] args) {
        Anagram a = new Anagram();

	String s1 = "abcd";
        String s2 = "dcab";

        System.out.println(a.isAnagram(s1, s2));
    }
}
