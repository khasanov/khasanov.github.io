
public class FactorialDemo {
    public int factorial(int n) { // рекурсивно
	return (n == 0) ? 1 : n * factorial(n-1);
    }

    public int fact(int n) { // итеративно
	int f = 1;
	for (int i = 1; i <= n; i++) {
	    f *= i;
	}
	return f;
    }
    
    public static void main(String [] args) {
        FactorialDemo f = new FactorialDemo();
	System.out.println(f.factorial(10));
	System.out.println(f.fact(10));
    }
}
