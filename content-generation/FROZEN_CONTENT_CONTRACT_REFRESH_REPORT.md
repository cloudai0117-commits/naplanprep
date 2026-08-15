# FROZEN CONTENT CONTRACT REFRESH REPORT

**Date:** 2026-08-14
**Triggered by:** P0 architecture change -- V57 adds `questions.calculator_allowed`
**Blocking:** V215 generation was BLOCKED until this report was complete

---

## Files regenerated

| File | Status |
|------|--------|
| `content-generation/FROZEN_CONTENT_SCHEMA.sql` | REGENERATED |
| `content-generation/FROZEN_CONTENT_ENUMS.md` | REGENERATED |
| `content-generation/FROZEN_CONTENT_INSERT_CONTRACT.md` | REGENERATED |

---

## Source files read

| Source | Purpose |
|--------|---------|
| `backend/src/main/resources/db/migration/V2__create_content_tables.sql` | Base questions table schema |
| `backend/src/main/resources/db/migration/V43__create_stimuli.sql` | stimuli table |
| `backend/src/main/resources/db/migration/V45__create_exam_sections.sql` | exam_sections table |
| `backend/src/main/resources/db/migration/V46__create_testlets.sql` | testlets table |
| `backend/src/main/resources/db/migration/V47__create_testlet_transitions.sql` | testlet_transitions table |
| `backend/src/main/resources/db/migration/V49__session_question_snapshots.sql` | snapshot table schema |
| `backend/src/main/resources/db/migration/V57__add_question_calculator_flag.sql` | P0 DDL -- calculator_allowed |
| `backend/src/main/java/au/com/naplanprep/content/entity/Question.java` | Entity fields + enums |
| `backend/src/main/java/au/com/naplanprep/content/dto/QuestionRequest.java` | Insert DTO |
| `backend/src/main/java/au/com/naplanprep/exam/dto/QuestionSummary.java` | API response DTO |
| `backend/src/main/java/au/com/naplanprep/exam/entity/Exam.java` | Exam entity |
| `backend/src/main/java/au/com/naplanprep/exam/entity/PackageType.java` | Package enum |
| `backend/src/main/java/au/com/naplanprep/exam/service/ExamSnapshotService.java` | Snapshot build logic |
| `backend/src/main/java/au/com/naplanprep/exam/service/ExamService.java` | studentView() + calculator flow |
| `frontend/src/features/exam/ExamPlayer.tsx` | Frontend calculator rendering |

---

## Cross-check results

### 1. Schema (FROZEN_CONTENT_SCHEMA.sql)

| Check | Result |
|-------|--------|
| `questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE` present | PASS |
| Column positioned after `stimulus_id`, before `marking_rubric` | PASS -- matches V57 ALTER TABLE |
| V57 backfill rule documented in column comment | PASS |
| Section 10 snapshot comment updated to include `calculatorAllowed` | PASS |
| All other columns match V2-V53 migrations | PASS (unchanged) |

### 2. Enums (FROZEN_CONTENT_ENUMS.md)

| Check | Result |
|-------|--------|
| New `calculator_allowed` section added | PASS |
| Y3/Y5 Numeracy = FALSE rule documented | PASS |
| Y7/Y9 A-stage Q1-8 = FALSE / Q9-16 = TRUE rule documented | PASS |
| V57 backfill UPDATE statement reproduced | PASS |
| Calculator control flow chain documented | PASS |
| Snapshot JSONB example updated: `calculatorAllowed` field present | PASS |
| `audioUrl` added to snapshot JSONB example (was absent in old file) | PASS |
| `questionId` added to snapshot JSONB example (was absent in old file) | PASS |
| All pre-existing enums unchanged | PASS |

### 3. Insert contract (FROZEN_CONTENT_INSERT_CONTRACT.md)

| Check | Result |
|-------|--------|
| `calculator_allowed` added to Step 2 field list with inline rules | PASS |
| Business rules table (domain x year_level x position) present | PASS |
| Y3/Y5 Numeracy explicit FALSE warning ("do NOT rely on default") | PASS |
| Y7/Y9 A-stage split rule (Q1-8 FALSE / Q9-16 TRUE) documented | PASS |
| Step 4 (exam_sections): note added clarifying section vs question precedence | PASS |
| Validation checklist: 3 new V57 calculator_allowed items added | PASS |
| All pre-existing steps unchanged | PASS |

### 4. End-to-end calculator flow verification

Traced from V57 migration through to frontend:

```
V57 DDL: questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE
  -> Question.java: @Column(name="calculator_allowed") Boolean calculatorAllowed
  -> QuestionRequest.java: Boolean calculatorAllowed (API insert field)
  -> ExamSnapshotService.buildSnapshot(): s.put("calculatorAllowed", q.getCalculatorAllowed() != null ? q.getCalculatorAllowed() : true)
  -> ExamService.studentView(): view keys NOT removed (calculatorAllowed IS sent to student)
  -> ExamService.snapshotToQuestionSummary(): Boolean calcAllowed = s.get("calculatorAllowed") instanceof Boolean b ? b : true
  -> QuestionSummary.java: Boolean calculatorAllowed (DTO field)
  -> ExamPlayer.tsx line 306: {currentQuestion.calculatorAllowed === true && <CalculatorWidget key={currentQuestionId} />}
```

All links in chain: PASS. No gap between DB column and frontend render.

### 5. studentView() field stripping verified

`ExamService.studentView()` removes exactly three fields before sending to student:
- `correctAnswer` -- STRIPPED (grading only)
- `markingRubric` -- STRIPPED (admin marking only)
- `explanation` -- STRIPPED (shown post-submission only)

`calculatorAllowed` is NOT stripped -- correctly sent to student. PASS.

### 6. QuestionSummary DTO verified

`QuestionSummary.java` record includes `Boolean calculatorAllowed` as last field.
Populated in all three code paths in ExamService:
- Snapshot path (snapshotToQuestionSummary)
- Flat exam path (examQuestionRepository.findByExamIdOrdered)
- Practice session path (questionRepository.findAllById)

All three paths: PASS.

---

## Changes from previous frozen contracts

Previous frozen contracts (source: V1-V53) were missing:

1. **`questions.calculator_allowed` column** -- not present in FROZEN_CONTENT_SCHEMA.sql
2. **Calculator enum/rules** -- not present in FROZEN_CONTENT_ENUMS.md
3. **`calculator_allowed` insert instruction** -- not present in FROZEN_CONTENT_INSERT_CONTRACT.md
4. **Snapshot JSONB fields `questionId`, `audioUrl`, `calculatorAllowed`** -- absent from enums snapshot example

No other schema changes were found between V53 and V57. V54-V56 are content (seed data) migrations. V57 is the only DDL change.

---

## Conclusion

```
FROZEN_CONTENT_CONTRACTS_CURRENT = YES
SOURCE_MIGRATIONS_RANGE          = V1-V57
REGENERATED_AT                   = 2026-08-14
NEXT_FLYWAY_VERSION              = V215
V215_GENERATION_UNBLOCKED        = YES
```
