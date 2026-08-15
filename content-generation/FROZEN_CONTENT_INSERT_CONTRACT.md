# FROZEN CONTENT INSERT CONTRACT

NAPLANPrep -- field-level insertion instructions for the content-generation engine.
Source: Flyway migrations V1-V57 + Java entity/scoring strategy files (read 2026-08-14).
  V57 adds: questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE
DO NOT MODIFY -- regenerate if schema or business rules change.

This document describes exactly how to insert one complete exam unit:
1 stimulus -> 1 question -> 1 exam -> 1 exam section -> 1 testlet -> 1 exam_question -> (optional) 1 testlet_transition

Insert in the order shown. FK dependencies prevent out-of-order inserts.

---

## Prerequisites

- PostgreSQL with Flyway migrations V1-V57 applied.
- `uuid-ossp` extension enabled (installed by V1).
- `users` table has a content-author row whose UUID you will use as `created_by`.
  If no author tracking is needed, pass `NULL` for all `created_by` columns.
- All enum values are stored as plain VARCHAR -- pass the string exactly as listed (case-sensitive, uppercase).

---

## Step 1 -- Insert a stimulus (optional)

Skip this step if the question is standalone (no shared passage, audio, or image).

```sql
INSERT INTO stimuli (
    id,                    -- UUID -- generate with gen_random_uuid() or supply
    stimulus_type,         -- REQUIRED  VARCHAR(20)   TEXT | IMAGE | AUDIO | WRITING_PROMPT
    title,                 -- optional  VARCHAR(200)  human label for admin UI
    content,               -- see rules below
    asset_url,             -- see rules below
    transcript,            -- AUDIO only; admin/authoring only -- NEVER expose to students
    audio_duration_seconds,-- AUDIO only; integer seconds
    year_level,            -- optional  INTEGER       3 | 5 | 7 | 9
    domain,                -- optional  VARCHAR(50)   NUMERACY|READING|WRITING|SPELLING|GRAMMAR_PUNCTUATION
    status,                -- REQUIRED  VARCHAR(20)   DRAFT (start here; PUBLISHED when ready)
    created_by             -- optional  UUID FK users
)
VALUES (
    gen_random_uuid(),
    'TEXT',         -- or IMAGE | AUDIO | WRITING_PROMPT
    'Passage title',
    'The full passage text goes here...',
    NULL,           -- no asset_url for TEXT stimuli
    NULL,           -- no transcript for TEXT stimuli
    NULL,           -- no audio_duration for TEXT stimuli
    5,
    'READING',
    'DRAFT',
    NULL            -- or a valid users.id UUID
);
```

### Field rules -- stimuli

| Field | TEXT | IMAGE | AUDIO | WRITING_PROMPT |
|-------|------|-------|-------|----------------|
| `content` | The passage (required) | Alt-text description (required for accessibility) | Optional accompanying text | The prompt text shown to student (required) |
| `asset_url` | NULL | S3/CDN URL (required) | S3/CDN audio URL (required) | NULL |
| `transcript` | NULL | NULL | Admin transcript (optional, NEVER sent to students) | NULL |
| `audio_duration_seconds` | NULL | NULL | Duration in seconds (required) | NULL |

---

## Step 2 -- Insert a question

```sql
INSERT INTO questions (
    id,                  -- UUID -- generate or supply
    question_type,       -- REQUIRED  VARCHAR(50)   see QuestionType enum
    year_level,          -- REQUIRED  INTEGER       3 | 5 | 7 | 9
    domain,              -- REQUIRED  VARCHAR(50)   NUMERACY|READING|WRITING|SPELLING|GRAMMAR_PUNCTUATION
    topic,               -- REQUIRED  VARCHAR(200)  specific topic label e.g. 'Main idea and purpose'
    difficulty_band,     -- REQUIRED  INTEGER       1-10
    stimulus_text,       -- optional  TEXT          short inline hint only; full passages use stimulus_id
    stimulus_type,       -- optional  VARCHAR(20)   TEXT|IMAGE|AUDIO|WRITING_PROMPT -- only if stimulus_text is set
    question_text,       -- REQUIRED  TEXT          the question stem shown to students
    options,             -- conditional JSONB        required for MULTIPLE_CHOICE and MULTI_SELECT; NULL otherwise
    correct_answer,      -- REQUIRED  JSONB          structure depends on question_type (see below)
    explanation,         -- optional  TEXT          shown to student after submission
    status,              -- REQUIRED  VARCHAR(50)   DRAFT (set to PUBLISHED when ready)
    created_by,          -- optional  UUID FK users
    package_type,        -- REQUIRED  VARCHAR(20)   FREE | ADVANCED | PREMIUM
    difficulty,          -- REQUIRED  VARCHAR(20)   EASY | MEDIUM | HARD
    marks,               -- REQUIRED  INTEGER >= 1   point value; DEFAULT 1
    cognitive_skill,     -- optional  VARCHAR(50)   RECALL|COMPREHENSION|ANALYSIS|APPLICATION
    curriculum_strand,   -- optional  VARCHAR(100)  e.g. 'Number and Algebra'
    audio_url,           -- conditional VARCHAR(500) S3/CDN URL for AUDIO_RESPONSE questions only
    stimulus_id,         -- optional  UUID FK stimuli  link to shared stimulus from Step 1
    calculator_allowed,  -- REQUIRED for Numeracy  BOOLEAN  see business rules below; DEFAULT TRUE
    marking_rubric       -- conditional JSONB          EXTENDED_WRITING only; NULL for all others
)
VALUES (
    gen_random_uuid(),
    'MULTIPLE_CHOICE',
    5,
    'READING',
    'Main idea and purpose',
    4,
    NULL,              -- no inline stimulus_text (using shared stimulus via stimulus_id)
    NULL,              -- no stimulus_type when using stimulus_id
    'What is the main purpose of the passage?',
    '[{"label":"A","text":"To inform the reader about..."},{"label":"B","text":"To persuade..."},{"label":"C","text":"To entertain..."},{"label":"D","text":"To describe..."}]'::jsonb,
    '{"value":"A"}'::jsonb,
    'The passage uses factual language and presents information without bias, indicating an informational purpose.',
    'DRAFT',
    NULL,
    'FREE',
    'EASY',
    1,
    'COMPREHENSION',
    'Literacy -- Reading for meaning',
    NULL,              -- no audio_url for MULTIPLE_CHOICE
    '<stimulus_uuid_from_step_1>',  -- or NULL for standalone
    TRUE,              -- READING: default TRUE; see Numeracy rules below
    NULL               -- no marking_rubric for auto-marked types
);
```

### calculator_allowed field rules (V57 -- MANDATORY for Numeracy)

This column is **authoritative**. The frontend renders the calculator widget only when
`calculatorAllowed === true` in the question's snapshot. It overrides section and testlet settings.

| domain | year_level | question position | calculator_allowed value |
|--------|------------|-------------------|--------------------------|
| `NUMERACY` | 3 | all questions | **`FALSE`** (explicit -- never omit) |
| `NUMERACY` | 5 | all questions | **`FALSE`** (explicit -- never omit) |
| `NUMERACY` | 7 | A-stage Q1-8 (question_order 1-8 in testlet_order=1) | **`FALSE`** (explicit) |
| `NUMERACY` | 7 | A-stage Q9-16 (question_order 9-16 in testlet_order=1) | **`TRUE`** (explicit) |
| `NUMERACY` | 9 | A-stage Q1-8 (question_order 1-8 in testlet_order=1) | **`FALSE`** (explicit) |
| `NUMERACY` | 9 | A-stage Q9-16 (question_order 9-16 in testlet_order=1) | **`TRUE`** (explicit) |
| `READING`, `WRITING`, `SPELLING`, `GRAMMAR_PUNCTUATION` | any | all | `TRUE` (default; may omit) |

**Do NOT rely on the column default for Y3/Y5 Numeracy.** The V57 backfill UPDATE fixed
existing rows, but new INSERT statements for Y3/Y5 Numeracy MUST supply `FALSE` explicitly
to avoid silent regression if the backfill is not re-run in a fresh environment.

### correct_answer structures by question_type

| question_type | correct_answer JSONB |
|---------------|----------------------|
| `MULTIPLE_CHOICE` | `{"value": "A"}` -- must match a `label` in `options` |
| `MULTI_SELECT` | `{"values": ["A", "C"]}` -- each must match a `label` in `options` |
| `SHORT_ANSWER` | `{"value": "exact answer text"}` -- compared case-insensitively after normalisation |
| `FILL_BLANK` | `{"value": "missing word"}` |
| `AUDIO_RESPONSE` | `{"value": "correctly spelled word"}` -- case-insensitive, internal spaces preserved |
| `EXTENDED_WRITING` | `{"value": null}` -- human-marked; populate `marking_rubric` |
| `REORDER` | `{"value": "serialised expected order string"}` |
| `MATCHING` | `{"value": "serialised match pairs string"}` |
| `DRAG_DROP` | `{"value": "serialised position state"}` |
| `IMAGE_INTERACTION` | `{"value": "serialised region/click state"}` |

### Scoring normalisation rules

- `MULTIPLE_CHOICE`: `given.toString().trim().equalsIgnoreCase(expected.toString().trim())`
- `MULTI_SELECT`: sets of values compared after `.trim().toUpperCase()` -- order does not matter
- `SHORT_ANSWER` / `FILL_BLANK`: `trim().toLowerCase()` + collapse consecutive whitespace
- `AUDIO_RESPONSE` / `SPELLING`: `trim().equalsIgnoreCase()` -- internal spaces preserved
- `EXTENDED_WRITING`: always returns `null` -> `pending_review = TRUE` on exam_results

### marks field guidance

| question_type | Typical marks value |
|---------------|---------------------|
| MULTIPLE_CHOICE | 1 |
| MULTI_SELECT | 1-2 |
| SHORT_ANSWER | 1 |
| FILL_BLANK | 1 per blank (use separate questions for multi-blank) |
| AUDIO_RESPONSE | 1 |
| EXTENDED_WRITING | Sum of all rubric maxMarks (e.g. 46 for a 10-criterion rubric) |

---

## Step 3 -- Insert an exam

```sql
INSERT INTO exams (
    id,                  -- UUID -- generate or supply
    title,               -- REQUIRED  VARCHAR(200)
    description,         -- optional  TEXT
    year_level,          -- REQUIRED  INTEGER       3 | 5 | 7 | 9
    domain,              -- REQUIRED  VARCHAR(50)   NUMERACY|READING|WRITING|SPELLING|GRAMMAR_PUNCTUATION
    time_limit_seconds,  -- REQUIRED  INTEGER > 0   e.g. 1800 = 30 minutes
    available_from,      -- optional  TIMESTAMPTZ   NULL = always available
    available_until,     -- optional  TIMESTAMPTZ   NULL = always available
    status,              -- REQUIRED  VARCHAR(50)   DRAFT | PUBLISHED
    created_by,          -- optional  UUID FK users
    package_type,        -- REQUIRED  VARCHAR(20)   FREE | ADVANCED | PREMIUM
    scoring_config       -- optional  JSONB          NULL = platform defaults
)
VALUES (
    gen_random_uuid(),
    'Year 5 Reading -- Comprehension Practice 1',
    'Practice exam covering main idea, inference, and vocabulary questions.',
    5,
    'READING',
    2700,              -- 45 minutes
    NULL,
    NULL,
    'DRAFT',
    NULL,
    'FREE',
    NULL               -- or '{"weightByMarks":true,"passMark":60,"showBand":true}'::jsonb
);
```

### Exam count constraints (FROZEN business rules)

| package_type | Target count per domain per year level | Platform total |
|--------------|----------------------------------------|----------------|
| `FREE` | 1 | 5 (1 x 5 domains) |
| `ADVANCED` | 5 | 25 (5 x 5 domains) |
| `PREMIUM` | 10 | 50 (10 x 5 domains) |

**These counts are frozen.** Do not add exams that violate the 5/30/80 total counts without updating the entitlement unit tests in `ExamEntitlementTest.java`.

---

## Step 4 -- Insert an exam section

Required only for exams with multiple sections (e.g. Calculator / Non-Calculator in Numeracy, or multiple reading passages). For single-section flat exams, still insert one section with `section_order = 1`.

```sql
INSERT INTO exam_sections (
    id,                  -- UUID -- generate or supply
    exam_id,             -- REQUIRED  UUID FK exams  from Step 3
    title,               -- REQUIRED  VARCHAR(200)
    section_order,       -- REQUIRED  INTEGER >= 1   1-based
    time_limit_seconds,  -- optional  INTEGER        NULL = inherit exam limit
    calculator_allowed,  -- REQUIRED  BOOLEAN        FALSE for most domains; TRUE for some Numeracy
    navigation_locked,   -- REQUIRED  BOOLEAN        FALSE for most; TRUE prevents return to section
    domain,              -- optional  VARCHAR(50)    override only for cross-domain (COL) exams
    instructions         -- optional  TEXT
)
VALUES (
    gen_random_uuid(),
    '<exam_uuid_from_step_3>',
    'Reading Comprehension',
    1,
    NULL,              -- inherit exam's 45-minute limit
    FALSE,
    FALSE,
    NULL,              -- no domain override (inherits from exam)
    'Read the passage carefully before answering the questions.'
);
```

**Note on section.calculator_allowed vs question.calculator_allowed:**
`exam_sections.calculator_allowed` is the section-level default inherited by testlets that have
`testlets.calculator_allowed = NULL`. It does NOT override `questions.calculator_allowed`.
The per-question value (V57) is always authoritative. Set section-level to FALSE for Numeracy
non-calculator sections and TRUE for calculator sections; this is used by the transition UI hint
only.

---

## Step 5 -- Insert a testlet

A testlet groups questions within a section, optionally sharing a stimulus. For flat non-branching exams, insert one testlet per section with `is_branching_node = FALSE`.

```sql
INSERT INTO testlets (
    id,                  -- UUID -- generate or supply
    section_id,          -- REQUIRED  UUID FK exam_sections  from Step 4
    stimulus_id,         -- optional  UUID FK stimuli         shared stimulus for all questions in testlet
    title,               -- optional  VARCHAR(200)
    testlet_order,       -- REQUIRED  INTEGER >= 1   1-based within the section
    is_branching_node,   -- REQUIRED  BOOLEAN        FALSE for linear exams
    navigation_locked,   -- REQUIRED  BOOLEAN        FALSE unless student must not return
    calculator_allowed,  -- optional  BOOLEAN        NULL = inherit from section
    instructions         -- optional  TEXT
)
VALUES (
    gen_random_uuid(),
    '<section_uuid_from_step_4>',
    '<stimulus_uuid_from_step_1>',    -- or NULL if no shared passage
    'The Ocean Migration',            -- descriptive label (not shown to students unless used as section title)
    1,
    FALSE,
    FALSE,
    NULL,
    NULL
);
```

---

## Step 6 -- Insert an exam_question

Links a question to an exam (and optionally to a section and testlet). `question_order` is 1-based.

```sql
INSERT INTO exam_questions (
    exam_id,        -- REQUIRED  UUID FK exams      from Step 3
    question_id,    -- REQUIRED  UUID FK questions   from Step 2
    question_order, -- REQUIRED  INTEGER >= 1        position within the exam (or testlet if testlet_id set)
    section_id,     -- optional  UUID FK exam_sections  NULL for flat exams
    testlet_id      -- optional  UUID FK testlets       NULL for flat exams
)
VALUES (
    '<exam_uuid_from_step_3>',
    '<question_uuid_from_step_2>',
    1,
    '<section_uuid_from_step_4>',   -- or NULL
    '<testlet_uuid_from_step_5>'    -- or NULL
)
ON CONFLICT (exam_id, question_id) DO NOTHING;
-- ON CONFLICT guard: V40 seed uses this pattern; safe to copy for idempotent imports.
```

Repeat this insert for each question in the exam, incrementing `question_order`.

---

## Step 7 -- Insert a testlet_transition (branching exams only)

Skip this step for linear exams (all questions in a fixed order). Only required when `is_branching_node = TRUE` on the source testlet.

```sql
INSERT INTO testlet_transitions (
    id,              -- UUID -- generate or supply
    exam_id,         -- REQUIRED  UUID FK exams    must match the testlets' exam
    source_testlet,  -- REQUIRED  UUID FK testlets  the testlet students are completing
    target_testlet,  -- REQUIRED  UUID FK testlets  the testlet to route them to
    condition_type,  -- REQUIRED  VARCHAR(30)       ALWAYS | SCORE_ABOVE | SCORE_BELOW
    condition_value, -- conditional JSONB            {"threshold": 0.6} for SCORE_ABOVE/BELOW; NULL for ALWAYS
    priority         -- REQUIRED  INTEGER           higher = evaluated first; ALWAYS fallback = 0
)
VALUES
    -- Route high scorers (>70%) to harder testlet
    (gen_random_uuid(), '<exam_uuid>', '<source_testlet_uuid>', '<hard_testlet_uuid>',
     'SCORE_ABOVE', '{"threshold": 0.7}'::jsonb, 10),
    -- Fallback: everyone else goes to standard testlet
    (gen_random_uuid(), '<exam_uuid>', '<source_testlet_uuid>', '<standard_testlet_uuid>',
     'ALWAYS', NULL, 0);
```

### Branching rules

- All transitions for a `source_testlet` are evaluated in `priority DESC` order.
- First matching condition wins. Branching engine does NOT fall through.
- Always include at least one `ALWAYS` transition (priority 0) as a fallback for every branching node.
- `source_testlet != target_testlet` is enforced by DB constraint -- no self-loops.
- Threshold values are proportions (0.0-1.0), not percentages.

---

## Publish an exam (final step)

After all inserts are complete and content is verified:

```sql
-- Publish the stimulus
UPDATE stimuli SET status = 'PUBLISHED' WHERE id = '<stimulus_uuid>';

-- Publish all questions in the exam
UPDATE questions
SET    status = 'PUBLISHED'
WHERE  id IN (
    SELECT question_id FROM exam_questions WHERE exam_id = '<exam_uuid>'
);

-- Publish the exam
UPDATE exams SET status = 'PUBLISHED' WHERE id = '<exam_uuid>';
```

Only `PUBLISHED` questions appear in exam sessions. The exam engine filters `questions.status = 'PUBLISHED'` at session start.

---

## Insert order summary

```
stimuli          (optional -- insert before questions if using shared passage/audio)
  |-- questions   (FK: stimulus_id -> stimuli.id)
       |-- exams
            |-- exam_sections  (FK: exam_id -> exams.id)
                 |-- testlets   (FK: section_id -> exam_sections.id,
                 |                   stimulus_id -> stimuli.id)
                 |-- exam_questions (FK: exam_id, question_id, section_id, testlet_id)
                 |-- testlet_transitions (FK: exam_id, source_testlet, target_testlet)
```

---

## Validation checklist before publishing

- [ ] `questions.year_level` matches `exams.year_level`
- [ ] `questions.domain` matches `exams.domain`
- [ ] `questions.package_type` matches `exams.package_type`
- [ ] `questions.status = 'PUBLISHED'` for all questions in the exam
- [ ] `stimuli.status = 'PUBLISHED'` for all referenced stimuli
- [ ] `exam_questions` has at least 1 row for this exam
- [ ] `question_order` values are contiguous starting at 1 with no gaps
- [ ] For `MULTIPLE_CHOICE`: `correct_answer.value` exists as a `label` in `options`
- [ ] For `MULTI_SELECT`: all values in `correct_answer.values` exist in `options`
- [ ] For `EXTENDED_WRITING`: `marking_rubric` is present and `totalMarks` is correct
- [ ] For `AUDIO_RESPONSE`: `audio_url` is set on question OR `stimuli.asset_url` is set on linked stimulus
- [ ] Exam count totals still comply with FREE=5 / ADVANCED=30 / PRO=80 business rule
- [ ] No branching testlet left without an `ALWAYS` fallback transition
- [ ] **[V57] Y3/Y5 Numeracy questions: `calculator_allowed = FALSE` (explicit in INSERT)**
- [ ] **[V57] Y7/Y9 Numeracy A-stage Q1-8: `calculator_allowed = FALSE` (explicit in INSERT)**
- [ ] **[V57] Y7/Y9 Numeracy A-stage Q9-16: `calculator_allowed = TRUE` (explicit in INSERT)**
