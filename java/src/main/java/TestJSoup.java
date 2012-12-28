import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

/**
 * User: tulskiy
 * Date: 12/26/12
 */
public class TestJSoup {
    public static void main(String[] args) throws IOException {
        Scanner fi = new Scanner(new File(args[0]));
        StringBuilder sb = new StringBuilder();
        while (fi.hasNextLine()) {
            sb.append(fi.nextLine()).append("\n");
        }
        String html = sb.toString();
        long time = System.currentTimeMillis();
        int iterations = Integer.parseInt(args[1]);
        for (int i = 0; i < iterations; i++) {
            Document document = Jsoup.parse(html);
        }
        System.out.println((System.currentTimeMillis() - time) / 1000f);
    }
}
