package au.com.naplanprep;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableAsync
@EnableScheduling
public class NaplanprepApplication {
    public static void main(String[] args) {
        SpringApplication.run(NaplanprepApplication.class, args);
    }
}
