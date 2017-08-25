import java.util.Scanner;

class EasterEggs {
    static int aa = 0;

    private String paintOnEgg() {
	String[] colors = {"R", "G", "B", "C", "M", "Y", "B"};
	aa++;
	return colors[aa % 7];
    }

    public String easterEgg(int n) {
	StringBuffer buff = new StringBuffer();

	for (int i = 0; i < n; i++) {
	    buff.append(paintOnEgg());
	}
	return buff.toString();
    }

    public static void main(String[] args) throws java.io.IOException {
	Scanner sc = new Scanner(System.in);
	int n = sc.nextInt();
	
	if (n < 7 || n > 10000)
	    return;

	EasterEggs egg = new EasterEggs();
	System.out.println(egg.easterEgg(n));
    }
}
