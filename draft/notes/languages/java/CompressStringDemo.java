/* Реализуйте метод, осуществляющий сжатие строки, на основе счётчика
 * повторяющихся символов. Например, строка aabcccccaaa должна
 * превратиться в a2b1c5a3. Если "сжатая" строка оказывается длиннее
 * исходной, метод должен вернуть исходную строку. 
 */

class CompressString {
    public String compressString(String s) {

        char last = s.charAt(0);
        int count = 1;
        StringBuffer buff = new StringBuffer();

        for (int i = 1; i < s.length(); i++) {
            if (s.charAt(i) == last) { // найден повторяющийся символ
                count++;
	    } else {
                buff.append(last);
                buff.append(count);
		count = 1;
                last = s.charAt(i);
	    }
	}

        // самый последний символ еще не был установлен
        buff.append(last);
        buff.append(count);

        if (buff.toString().length() <= s.length()) {
	    return buff.toString();
	}
        else {
	    return s;
	}

    }
}

class CompressStringDemo {
    public static void main(String [] args) {

        String s = args[0]; //"aabcccccaaa";

        CompressString cs = new CompressString();
        System.out.println(cs.compressString(s));
    }
}
   
