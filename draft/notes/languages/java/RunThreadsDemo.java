public class RunThreadsDemo implements Runnable {

    public static void main(String[] args) {
  RunThreadsDemo runner = new RunThreadsDemo(); // создаем один экземпляр Runnable
	Thread alpha = new Thread(runner);
	Thread beta = new Thread(runner);   //создаем два потока с одним заданием
	alpha.setName("thread alpha");
	beta.setName("thread beta");  // имена потоков
	alpha.start();
	beta.start();  // запускаем потоки
    }

    public void run() {
	for (int i = 0; i < 25; i++) {
	    String threadName = Thread.currentThread().getName();
	    System.out.println("Сейчас работает " + threadName);
	}
    }
}
