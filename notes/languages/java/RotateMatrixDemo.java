/* Дано изображение в виде матрицы размером NxN, где каждый пиксель
 * занимает 4 байта. Напишите метод, поворачивающий изобрражение на
 * 90 */

/* Реализуем последовательную замену элемента за элементом:
  for i = 0 to n
    temp = top[i]
    top[i] = left[i]
    left[i] = bottom[i]
    bottom[i] = right[i]
    right[i] = temp
*/

class RotateMatrixDemo {
    public static void showMatrix(int[][] matrix) {
	for (int i = 0; i < matrix.length; i++) {
	    for (int j = 0; j < matrix[i].length; j++) {
		System.out.print(matrix[i][j] + "\t");
	    } 
	    System.out.println();
	}
    }

    public static void rotate(int[][] matrix, int n) {
        for (int layer = 0; layer < n/2; ++layer) {
	    int first = layer;
	    int last = n - 1 - layer;

	    showMatrix(matrix);
	    for (int i = first; i < last; ++i) {
		int offset = i - first;
		// сохраняем вершину
		int top = matrix[first][i];
		// левая -> верхняя
		matrix[first][i] = matrix[last - offset][first];
		// нижняя-> левая
		matrix[last-offset][first] = matrix[last][last - offset];
		// правая-> нижняя
		matrix[last][last-offset] = matrix[i][last];
		// верхняя-> правая
		matrix[i][last] = top;
	    }
            showMatrix(matrix);
	}
    }

    public static void main(String [] args) {
        int[][] matrix = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
        rotate(matrix, 3);
        System.out.println("Ok");
    }
}
