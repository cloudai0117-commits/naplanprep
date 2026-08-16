package au.com.naplanprep.auth.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Sends transactional emails for auth flows (password reset).
 *
 * When spring.mail.host is not configured (MAIL_HOST env var absent), JavaMailSender
 * autoconfiguration is skipped and this service logs the reset URL for UAT testers instead.
 * Configure MAIL_HOST, MAIL_USERNAME, MAIL_PASSWORD for email delivery in production.
 */
@Slf4j
@Service
public class EmailService {

    private final Optional<JavaMailSender> mailSender;

    public EmailService(Optional<JavaMailSender> mailSender) {
        this.mailSender = mailSender;
    }

    public void sendPasswordResetEmail(String toEmail, String resetUrl) {
        if (mailSender.isEmpty()) {
            log.warn("MAIL_NOT_CONFIGURED — email not sent. Configure MAIL_HOST to enable delivery.");
            log.warn("RESET_URL_UAT_ONLY — token URL for UAT testing (not logged in production).");
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setSubject("NAPLANPrep — Password Reset");
            message.setText(
                "Hi,\n\n" +
                "A password reset was requested for your NAPLANPrep account.\n\n" +
                "Click the link below to reset your password (valid for 1 hour):\n\n" +
                resetUrl + "\n\n" +
                "If you did not request this, you can safely ignore this email.\n\n" +
                "— The NAPLANPrep Team"
            );
            mailSender.get().send(message);
            log.info("PASSWORD_RESET_EMAIL_SENT — recipient=<redacted>");
        } catch (MailException ex) {
            log.error("PASSWORD_RESET_EMAIL_FAILED — {}", ex.getMessage());
        }
    }
}
