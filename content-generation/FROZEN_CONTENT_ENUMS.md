# FROZEN CONTENT ENUMS

NAPLANPrep -- authoritative enum values for all content-facing columns.
Source: Flyway migrations V1-V57 + Java entity enums (read 2026-08-14).
  V57 adds: questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE
DO NOT MODIFY -- update only when a new migration changes the source.

---

## year_level

Applies to: `questions.year_level`, `exams.year_level`, `stimuli.year_level`, `practice_score_bands.year_level`

| Value | Description |
|-------|-------------|
| `3` | Year 3 |
| `5` | Year 5 |
| `7` | Year 7 |
| `9` | Year 9 |

DB constraint: `CHECK (year_level IN (3, 5, 7, 9))`

---

## domain

Applies to: `questions.domain`, `exams.domain`, `stimuli.domain`, `exam_sections.domain`, `practice_score_bands.domain`

| Value | Description |
|-------|-------------|
| `NUMERACY` | Mathematics / numeracy domain |
| `READING` | Reading comprehension |
| `WRITING` | Extended writing / composition |
| `SPELLING` | Spelling (audio-response) |
| `GRAMMAR_PUNCTUATION` | Grammar and punctuation |

Source: `Question.Domain` enum (Java).

---

## question_type

Applies to: `questions.question_type`

| Value | Auto-marked | Scoring strategy | Notes |
|-------|------------|-----------------|-------|
| `MULTIPLE_CHOICE` | Yes | `MultipleChoiceScoringStrategy` | Single answer from labelled options (A/B/C/D). `correct_answer`: `{"value":"A"}` |
| `MULTI_SELECT` | Yes | `MultiSelectScoringStrategy` | Multiple correct options. `correct_answer`: `{"values":["A","C"]}` |
| `SHORT_ANSWER` | Yes | `ShortAnswerScoringStrategy` | Typed text, normalised (trim + lowercase + collapse spaces). `correct_answer`: `{"value":"exact answer"}` |
| `FILL_BLANK` | Yes | `ShortAnswerScoringStrategy` | One or more blanks within a sentence. `correct_answer`: `{"value":"word"}` |
| `REORDER` | Yes | `ShortAnswerScoringStrategy` (fallback) | Drag items into correct sequence. `correct_answer`: `{"value":"serialised order"}` |
| `MATCHING` | Yes | `ShortAnswerScoringStrategy` (fallback) | Match left-column to right-column items. |
| `DRAG_DROP` | Yes | `ShortAnswerScoringStrategy` (fallback) | Generic positional drag-and-drop. |
| `AUDIO_RESPONSE` | Yes | `SpellingScoringStrategy` | Student types the word heard in an audio clip. Case-insensitive, preserve internal spaces. |
| `EXTENDED_WRITING` | **NO** | `WritingScoringStrategy` (returns `null`) | Long-form writing. Session set to `PENDING_REVIEW`. Human reviewer assigns marks via admin marking interface. `correct_answer`: `{"value":null}` |
| `IMAGE_INTERACTION` | Yes | `ShortAnswerScoringStrategy` (fallback) | Click/mark regions on an image. |

Source: `Question.QuestionType` enum + `ScoringStrategyFactory.java`.

**Scoring return contract:**
- `true` -> student answer matches (full marks awarded)
- `false` -> student answer does not match (zero marks)
- `null` -> cannot be auto-marked (`EXTENDED_WRITING` only) -> session enters `PENDING_REVIEW`

---

## package_type

Applies to: `questions.package_type`, `exams.package_type`

| Value | Plan slug | Entitlement (cumulative) | Exam count |
|-------|-----------|--------------------------|-----------|
| `FREE` | `basic` | {FREE} | 5 total (1 per domain) |
| `ADVANCED` | `advanced` | {FREE, ADVANCED} | 25 exams (total 30 with FREE) |
| `PREMIUM` | `pro` | {FREE, ADVANCED, PREMIUM} | 50 exams (total 80 with FREE + ADVANCED) |

Business rule (FROZEN -- do not modify):
- Plan `basic` -> tags `{FREE}` -> accesses FREE exams only (5 total)
- Plan `advanced` -> tags `{FREE, ADVANCED}` -> accesses FREE + ADVANCED (30 total)
- Plan `pro` -> tags `{FREE, ADVANCED, PREMIUM}` -> accesses all tiers (80 total -- NOT 55)

Source: V34 migration + `resolvePlanToPackageTiers()` in `SubscriptionService.java`.

---

## difficulty

Applies to: `questions.difficulty`

| Value | Description |
|-------|-------------|
| `EASY` | Low difficulty (default) |
| `MEDIUM` | Medium difficulty |
| `HARD` | High difficulty |

Source: `Question.Difficulty` enum (Java).

---

## difficulty_band

Applies to: `questions.difficulty_band`

Integer 1-10. DB constraint: `CHECK (difficulty_band BETWEEN 1 AND 10)`

| Range | Interpretation |
|-------|----------------|
| 1-3 | Below year-level expectation |
| 4-6 | At year-level expectation |
| 7-10 | Above year-level expectation |

---

## question_status / exam_status / stimulus_status

Applies to: `questions.status`, `exams.status`, `stimuli.status`

| Value | Description |
|-------|-------------|
| `DRAFT` | In authoring; not visible to students (default) |
| `REVIEW` | Submitted for content review |
| `PUBLISHED` | Live; visible to students with appropriate package |
| `ARCHIVED` | Retired; excluded from all queries |

Source: `Question.QuestionStatus` enum (Java). Exams and stimuli use the same values by convention.

---

## stimulus_type

Applies to: `stimuli.stimulus_type`, `questions.stimulus_type`

| Value | Use case | Required fields |
|-------|----------|----------------|
| `TEXT` | Reading passage or written prompt | `content` (the passage text) |
| `IMAGE` | Diagram, graph, or picture | `asset_url` (S3/CDN), `content` (alt-text) |
| `AUDIO` | Spelling domain audio clip | `asset_url` (S3/CDN audio file), `audio_duration_seconds` |
| `WRITING_PROMPT` | Extended writing prompt shown to student | `content` (the prompt text) |

Source: V43 migration inline comment.

**Important:** `stimuli.transcript` (AUDIO only) is admin/authoring data -- NEVER send it to the student API.

---

## cognitive_skill

Applies to: `questions.cognitive_skill`

| Value | Description |
|-------|-------------|
| `RECALL` | Retrieval of learned facts |
| `COMPREHENSION` | Understanding and interpretation |
| `ANALYSIS` | Breaking down and examining |
| `APPLICATION` | Applying knowledge to new contexts |
| `NULL` | Not classified |

Source: `Question.CognitiveSkill` enum (Java).

---

## calculator_allowed

Applies to: `questions.calculator_allowed`

Added: V57 (`ALTER TABLE questions ADD COLUMN calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE`).

Type: `BOOLEAN NOT NULL DEFAULT TRUE`

| Value | Meaning |
|-------|---------|
| `TRUE` (default) | Defer to `testlets.calculator_allowed` -> `exam_sections.calculator_allowed` inheritance chain |
| `FALSE` | Override -- no calculator permitted for this question, regardless of testlet/section setting |

**This column is the authoritative source for per-question calculator control.**
The frontend (`ExamPlayer.tsx`) renders the calculator widget only when
`currentQuestion.calculatorAllowed === true` (server-authoritative, from snapshot).

### Business rules (FROZEN)

| Year level | Domain | Question position | calculator_allowed |
|------------|--------|-------------------|--------------------|
| 3 | NUMERACY | all | **FALSE** |
| 5 | NUMERACY | all | **FALSE** |
| 7 | NUMERACY | A-stage Q1-8 (testlet_order=1, question_order 1-8) | **FALSE** |
| 7 | NUMERACY | A-stage Q9-16 (testlet_order=1, question_order 9-16) | **TRUE** |
| 9 | NUMERACY | A-stage Q1-8 (testlet_order=1, question_order 1-8) | **FALSE** |
| 9 | NUMERACY | A-stage Q9-16 (testlet_order=1, question_order 9-16) | **TRUE** |
| 3, 5, 7, 9 | READING, WRITING, SPELLING, GRAMMAR_PUNCTUATION | all | **TRUE** (default, may omit) |

### V57 backfill applied

```sql
-- Applied by V57 to all existing Y3/Y5 Numeracy questions (V54-V56 canonical content)
UPDATE questions
SET    calculator_allowed = FALSE
WHERE  domain = 'NUMERACY'
  AND  year_level IN (3, 5);
```

Y7/Y9 Numeracy content migrations must set `calculator_allowed` explicitly per-question.
The column default (TRUE) is NOT safe for Y7/Y9 Numeracy A-stage questions 1-8.

### Calculator control flow (V57)

```
questions.calculator_allowed (authoritative)
  -> ExamSnapshotService.buildSnapshot()  [writes calculatorAllowed into snapshot JSONB]
  -> ExamService.studentView()            [preserves calculatorAllowed; strips correctAnswer/markingRubric/explanation]
  -> QuestionSummary.calculatorAllowed    [DTO field]
  -> React ExamPlayer.tsx                 [renders <CalculatorWidget> iff currentQuestion.calculatorAllowed === true]
```

---

## condition_type  (testlet branching)

Applies to: `testlet_transitions.condition_type`

| Value | Description | condition_value |
|-------|-------------|-----------------|
| `ALWAYS` | Unconditional -- linear path or fallback | `null` |
| `SCORE_ABOVE` | Follow if score in source testlet > threshold | `{"threshold": 0.7}` (proportion 0.0-1.0) |
| `SCORE_BELOW` | Follow if score in source testlet <= threshold | `{"threshold": 0.5}` |

DB constraint: `CHECK (condition_type IN ('ALWAYS','SCORE_ABOVE','SCORE_BELOW'))`

Evaluation order: all transitions for a `source_testlet` sorted by `priority DESC`; first match wins. `ALWAYS` with `priority=0` acts as the fallback/default path.

---

## purchase_type  (subscriptions -- reference only)

Applies to: `subscriptions.purchase_type` (V52 migration)

| Value | Description |
|-------|-------------|
| `ONE_TIME` | One-time payment; `expires_at = purchase_date + 365 days` |

Only `ONE_TIME` is supported in the current architecture. Recurring subscriptions are not offered.

---

## practice score band labels  (V51 seed data)

Applies to: `practice_score_bands.label`, `exam_results.practice_label`

| Band | Label |
|------|-------|
| 1 | Foundation Level 1 (0-9.99%) |
| 2 | Foundation Level 2 (10-19.99%) |
| 3 | Developing Level 1 (20-29.99%) |
| 4 | Developing Level 2 (30-44.99%) |
| 5 | Meeting Standard 1 (45-54.99%) |
| 6 | Meeting Standard 2 (55-64.99%) |
| 7 | Exceeding Standard 1 (65-74.99%) |
| 8 | Exceeding Standard 2 (75-84.99%) |
| 9 | Advanced Level 1 (85-92.99%) |
| 10 | Advanced Level 2 (93-100%) |

Labels are deliberately non-NAPLAN to avoid misrepresentation of official bands. Same thresholds applied across all year levels and domains. Admins can override via the admin API.

---

## JSONB field structures

### `questions.options`

MULTIPLE_CHOICE / MULTI_SELECT:
```json
[
  {"label": "A", "text": "Option text"},
  {"label": "B", "text": "Option text"},
  {"label": "C", "text": "Option text"},
  {"label": "D", "text": "Option text"}
]
```

### `questions.correct_answer`

| question_type | Structure |
|---------------|-----------|
| MULTIPLE_CHOICE, SHORT_ANSWER, FILL_BLANK, AUDIO_RESPONSE, REORDER, MATCHING, DRAG_DROP, IMAGE_INTERACTION | `{"value": "A"}` or `{"value": "exact text"}` |
| MULTI_SELECT | `{"values": ["A", "C"]}` |
| EXTENDED_WRITING | `{"value": null}` |

### `questions.marking_rubric`  (EXTENDED_WRITING only)

```json
{
  "criteria": [
    {"name": "Audience", "maxMarks": 6},
    {"name": "Text structure", "maxMarks": 4},
    {"name": "Ideas", "maxMarks": 5},
    {"name": "Persuasive devices", "maxMarks": 4},
    {"name": "Vocabulary", "maxMarks": 5},
    {"name": "Cohesion", "maxMarks": 4},
    {"name": "Paragraphing", "maxMarks": 2},
    {"name": "Sentence structure", "maxMarks": 6},
    {"name": "Punctuation", "maxMarks": 5},
    {"name": "Spelling", "maxMarks": 5}
  ],
  "totalMarks": 46
}
```

### `exams.scoring_config`  (optional)

```json
{"weightByMarks": true, "passMark": 60, "showBand": true}
```

### `testlet_transitions.condition_value`

```json
{"threshold": 0.6}
```

### `session_question_snapshots.snapshot`  (engine-populated, reference only)

Written by `ExamSnapshotService.buildSnapshot()`. Fields added by V57 are marked.

```json
{
  "questionId":         "uuid-string",
  "questionType":       "MULTIPLE_CHOICE",
  "questionText":       "...",
  "domain":             "READING",
  "yearLevel":          5,
  "topic":              "Main idea and purpose",
  "difficultyBand":     4,
  "marks":              1,
  "options":            [{"label":"A","text":"..."}],
  "audioUrl":           null,
  "calculatorAllowed":  false,
  "stimulusText":       null,
  "stimulusType":       null,
  "stimulusId":         null,
  "stimulusSharedType": null,
  "stimulusContent":    null,
  "stimulusAssetUrl":   null,
  "stimulusTitle":      null,
  "cognitiveSkill":     "COMPREHENSION",
  "curriculumStrand":   "Literacy -- Reading for meaning",

  "correctAnswer":  {"value": "A"},
  "markingRubric":  null,
  "explanation":    "The passage uses factual language..."
}
```

**Server-side only fields** (stripped by `ExamService.studentView()` before any API response to students):
- `correctAnswer` -- grading only; MUST NEVER reach the student client
- `markingRubric` -- EXTENDED_WRITING admin marking only
- `explanation` -- shown post-submission only

`calculatorAllowed` IS sent to the student (it is a render field, not a grading field).
