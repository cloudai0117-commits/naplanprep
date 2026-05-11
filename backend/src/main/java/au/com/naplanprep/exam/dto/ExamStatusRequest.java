package au.com.naplanprep.exam.dto;

import au.com.naplanprep.exam.entity.Exam;
import jakarta.validation.constraints.NotNull;

public record ExamStatusRequest(@NotNull Exam.ExamStatus status) {}
