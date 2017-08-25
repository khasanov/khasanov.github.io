/* Замените все пробелы в строке символами '%20'.
 */

class ReplaceSpaces {
    public void replaceSpaces(String str) {
        StringBuffer buff = new StringBuffer();
        char space = ' ';
        for (int i = 0; i < str.length(); i++) {
            if (str.charAt(i) == space) {
	        buff.append(new String("%20"));
            }
            else {
	        buff.append(str.charAt(i));
            }
	}
        System.out.println(buff);
    }
}

class ReplaceSpacesDemo {
    public static void main(String [] args) {

        String str = "Hello, World!";

        ReplaceSpaces rp = new ReplaceSpaces();
        rp.replaceSpaces(str);
    }
}
