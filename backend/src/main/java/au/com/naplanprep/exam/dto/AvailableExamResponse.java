package au.com.naplanprep.exam.dto;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.PackageType;

import java.time.Instant;
import java.util.UUID;

public record AvailableExamResponse(
    UUID id,
    String title,
    String description,
    Question.Domain domain,
    Integer yearLevel,
    Integer timeLimitSeconds,
    Instant availableFrom,
    Instant availableUntil,
    int questionCount,
    PackageType packageType,
    /** AVAILABLE | UPCOMING | EXPIRED | UPGRADE_REQUIRED */
    String availability,
    boolean alreadyAttempted,
    UUID completedSessionId
) {}
