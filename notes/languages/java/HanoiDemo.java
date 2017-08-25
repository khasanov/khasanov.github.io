/* Ханойская башня. Даны три стержня, на один из которых нанизаны N
 * колец, причем кольца отличаются размером и лежат меньшее на
 * большем. Задача состоит в том, чтобы перенести пирамиду из N колец
 * за наименьшее число ходов. За один ход разрешается переносить
 * только одно кольцо, причём нельзя класть большее кольцо на
 * меньшее. */

/* 
 * N = 3
 * Move disc 1 from A to C
 * Move disc 2 from A to B
 * Move disc 1 from C to B
 * Move disc 3 from A to C
 * Move disc 1 from B to A
 * Move disc 2 from B to C
 * Move disc 1 from A to C
 */

class HanoiDemo {
    // move n smallest discs from one pole to another, using the temp pole
    public static void hanoi(int n, String from, String temp, String to) {
	if (n == 0) return;
	hanoi(n-1, from, to, temp);
	System.out.println("Move disc " + n + " from " + from + " to " + to);
	hanoi(n-1, temp, from, to);
    }

    public static void main(String[] args) {
	int N = Integer.parseInt(args[0]);
	hanoi(N, "A", "B", "C");
    }
}
