import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.File;
import java.io.IOException;

/**
 * User: tulskiy
 * Date: 12/26/12
 */
public class TestJSoup {
    public static void main(String[] args) throws IOException {
        long time = System.currentTimeMillis();
        File file = new File(args[0]);
        int iterations = Integer.parseInt(args[1]);
        for (int i = 0; i < iterations; i++) {
            Document document = Jsoup.parse(file, "utf-8");
        }
        System.out.println((System.currentTimeMillis() - time) / 1000f);
    }
}
