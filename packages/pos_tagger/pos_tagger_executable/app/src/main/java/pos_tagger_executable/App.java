package pos_tagger_executable;

import java.nio.file.*;

public class App {
    public String getGreeting() {
        return "Hello World!";
    }

    public static void main(String[] args) {
        Path cacheDir = Paths.get(System.getProperty("java.io.tmpdir"));
        System.out.println("System's default application cache directory: " + cacheDir);
        System.out.println(new App().getGreeting());
    }
}
