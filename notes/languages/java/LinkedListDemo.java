/* Связный список -- структура данных, состоящая из узлов, каждый из
 * которых содержит одну или две ссылки на следующий и/или предыдущий
 * узел списка. 
 */

// "Велосипед"

public class Node {
    private int element;
    private Node next;

    public int getElement() {
	return element;
    }

    public void setElement(int e) {
	element = e;
    }

    public Node getNext() {
	return next;
    }

    public void setNext(Node n) {
	next = n;
    }
}
