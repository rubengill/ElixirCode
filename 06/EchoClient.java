import java.io.*;
import java.net.*;

class EchoClient {
  public static void main(String... args) throws IOException {
    var host = "127.0.0.1";
    var port = 1234;
    try ( 
      var s = new Socket(host, port);
      var in = 
        new BufferedReader(new InputStreamReader(s.getInputStream()));
      var out =
        new PrintWriter(new OutputStreamWriter(s.getOutputStream()), true);
      var stdin =
        new BufferedReader(new InputStreamReader(System.in));
    ) {
      String line, reply;

      while (true) {
        System.out.print("> ");
        if ((line = stdin.readLine()) == null) {
          break;
        }
        out.println(line);
        if ((reply = in.readLine()) == null) {
          break;
        }
        System.out.println(reply);
      }
    }
  }
}
