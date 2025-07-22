class ThreadTest implements Runnable {
  String msg;

  public ThreadTest(String s) { msg = s; }

  public void run() {
    while (true) {
      System.out.println(msg);
    }
  }

  public static void main(String... args) {
    /*
    var t1 = new Thread(new ThreadTest("hello"));
    var t2 = new Thread(new ThreadTest("world"));

    t1.start();
    t2.start();
    */

    Runnable r1 = () -> { while (true) { System.out.println("hello"); } };
    Runnable r2 = () -> { while (true) { System.out.println("world"); } };

    new Thread(r1).start();
    new Thread(r2).start();
  }
}
