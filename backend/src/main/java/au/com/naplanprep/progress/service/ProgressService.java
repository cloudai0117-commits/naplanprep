package au.com.naplanprep.progress.service;

import au.com.naplanprep.auth.entity.ParentChildLink;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.ParentChildLinkRepository;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.ExamResult;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.repository.ExamResultRepository;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProgressService {

    private final ExamResultRepository resultRepository;
    private final ExamSessionRepository sessionRepository;
    private final ParentChildLinkRepository parentChildLinkRepository;
    private final UserRepository userRepository;

    public Map<String, Object> getOverview(UUID userId) {
        List<ExamResult> results = resultRepository.findByUserIdOrderByCalculatedAtDesc(userId);

        Map<String, Object> overview = new HashMap<>();
        overview.put("totalExams", results.size());

        if (results.isEmpty()) {
            overview.put("averageScore", 0);
            overview.put("domainScores", Map.of());
            overview.put("recentTrend", List.of());
            return overview;
        }

        double avgScore = results.stream()
            .mapToDouble(ExamResult::getScorePercentage)
            .average()
            .orElse(0);
        overview.put("averageScore", Math.round(avgScore * 10.0) / 10.0);
        overview.put("lastNaplanBand", results.get(0).getNaplanBand());

        Map<String, List<Double>> domainScores = new HashMap<>();
        for (ExamResult result : results) {
            if (result.getDomainBreakdown() == null) continue;
            result.getDomainBreakdown().forEach((key, val) -> {
                if (key.endsWith("_correct") || key.endsWith("_total")) {
                    String domain = key.substring(0, key.lastIndexOf('_'));
                    domainScores.computeIfAbsent(domain, k -> new ArrayList<>());
                }
            });
        }
        overview.put("domainScores", computeDomainAverages(results));

        List<Map<String, Object>> trend = results.stream()
            .limit(10)
            .map(r -> {
                Map<String, Object> m = new HashMap<>();
                m.put("date", r.getCalculatedAt().toString());
                m.put("score", r.getScorePercentage());
                m.put("band", r.getNaplanBand());
                return m;
            })
            .collect(Collectors.toList());
        Collections.reverse(trend);
        overview.put("recentTrend", trend);

        return overview;
    }

    public Map<String, Object> getDomainProgress(UUID userId, String domain) {
        Question.Domain domainEnum = Question.Domain.valueOf(domain.toUpperCase());
        List<ExamResult> allResults = resultRepository.findByUserIdOrderByCalculatedAtDesc(userId);

        List<Map<String, Object>> history = new ArrayList<>();
        for (ExamResult result : allResults) {
            if (result.getDomainBreakdown() == null) continue;
            String totalKey = domainEnum.name() + "_total";
            String correctKey = domainEnum.name() + "_correct";
            Object total = result.getDomainBreakdown().get(totalKey);
            Object correct = result.getDomainBreakdown().get(correctKey);
            if (total != null && (int)total > 0) {
                double score = correct != null ? ((int)correct * 100.0) / (int)total : 0;
                Map<String, Object> entry = new HashMap<>();
                entry.put("date", result.getCalculatedAt().toString());
                entry.put("score", score);
                entry.put("questionsAnswered", total);
                history.add(entry);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("domain", domain);
        result.put("history", history);
        result.put("questionsAnswered", history.stream().mapToInt(h -> (int) h.get("questionsAnswered")).sum());
        return result;
    }

    public List<Map<String, Object>> getRecommendations(UUID userId) {
        List<ExamResult> results = resultRepository.findByUserIdOrderByCalculatedAtDesc(userId);

        if (results.isEmpty()) {
            return List.of(Map.of("domain", "NUMERACY", "reason", "Start with a diagnostic exam to identify weak areas"));
        }

        Map<String, double[]> domainTotals = new HashMap<>();
        for (ExamResult result : results) {
            if (result.getDomainBreakdown() == null) continue;
            result.getDomainBreakdown().forEach((key, val) -> {
                if (key.endsWith("_total")) {
                    String domain = key.substring(0, key.lastIndexOf('_'));
                    domainTotals.computeIfAbsent(domain, k -> new double[]{0, 0});
                    domainTotals.get(domain)[1] += (int) val;
                } else if (key.endsWith("_correct")) {
                    String domain = key.substring(0, key.lastIndexOf('_'));
                    domainTotals.computeIfAbsent(domain, k -> new double[]{0, 0});
                    domainTotals.get(domain)[0] += (int) val;
                }
            });
        }

        return domainTotals.entrySet().stream()
            .map(e -> {
                double score = e.getValue()[1] > 0 ? (e.getValue()[0] / e.getValue()[1]) * 100 : 0;
                Map<String, Object> rec = new HashMap<>();
                rec.put("domain", e.getKey());
                rec.put("score", Math.round(score * 10.0) / 10.0);
                rec.put("questionsAnswered", (int) e.getValue()[1]);
                rec.put("priority", score < 50 ? "HIGH" : score < 70 ? "MEDIUM" : "LOW");
                return rec;
            })
            .sorted(Comparator.comparingDouble(m -> (double) m.get("score")))
            .limit(5)
            .collect(Collectors.toList());
    }

    public Map<String, Object> getChildProgress(UUID parentId, UUID childId) {
        User parent = userRepository.findById(parentId)
            .orElseThrow(() -> new ResourceNotFoundException("User", parentId.toString()));
        User child = userRepository.findById(childId)
            .orElseThrow(() -> new ResourceNotFoundException("Child", childId.toString()));

        boolean linked = parentChildLinkRepository.existsByParentAndChild(parent, child);
        if (!linked) {
            throw new BusinessException("Not authorized to view this child's progress");
        }

        return getOverview(childId);
    }

    private Map<String, Object> computeDomainAverages(List<ExamResult> results) {
        Map<String, double[]> totals = new HashMap<>();
        for (ExamResult result : results) {
            if (result.getDomainBreakdown() == null) continue;
            result.getDomainBreakdown().forEach((key, val) -> {
                String suffix = key.endsWith("_total") ? "_total" : "_correct";
                String domain = key.substring(0, key.lastIndexOf('_'));
                totals.computeIfAbsent(domain, k -> new double[]{0, 0});
                if (key.endsWith("_total")) totals.get(domain)[1] += (int) val;
                else if (key.endsWith("_correct")) totals.get(domain)[0] += (int) val;
            });
        }

        Map<String, Object> averages = new HashMap<>();
        totals.forEach((domain, arr) -> {
            double score = arr[1] > 0 ? (arr[0] / arr[1]) * 100 : 0;
            averages.put(domain, Math.round(score * 10.0) / 10.0);
        });
        return averages;
    }
}
