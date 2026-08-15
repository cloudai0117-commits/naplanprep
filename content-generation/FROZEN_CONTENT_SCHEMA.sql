-- ================================================================
-- FROZEN CONTENT SCHEMA CONTRACT
-- NAPLANPrep -- machine-readable PostgreSQL schema for content-generation engine
--
-- Source: Flyway migrations V1-V57 (read 2026-08-14)
--   V57 adds: questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE
-- DO NOT MODIFY THIS FILE -- regenerate from migrations if schema changes.
-- DO NOT USE THIS FILE TO RUN MIGRATIONS -- use Flyway.
-- This file reflects the CUMULATIVE final state of all applied migrations.
-- ================================================================

-- ----------------------------------------------------------------
-- PREREQUISITE: uuid-ossp extension (installed by V1)
-- ----------------------------------------------------------------
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================================
-- 1. USERS  (reference only -- do not insert via content engine)
-- ================================================================
--
-- CREATE TABLE users (
--     id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     email                 VARCHAR(255) NOT NULL UNIQUE,
--     password              VARCHAR(255) NOT NULL,
--     role                  VARCHAR(50)  NOT NULL DEFAULT 'STUDENT',
--     status                VARCHAR(50)  NOT NULL DEFAULT 'ACTIVE',
--     stripe_customer_id    VARCHAR(100),
--     failed_login_attempts INTEGER      NOT NULL DEFAULT 0,
--     locked_until          TIMESTAMPTZ,
--     created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--     updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW()
-- );

-- ================================================================
-- 2. STIMULI  (V43 + trigger from V1 update_updated_at_column())
-- ================================================================

CREATE TABLE IF NOT EXISTS stimuli (
    id                     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    stimulus_type          VARCHAR(20) NOT NULL,
    -- Allowed: TEXT | IMAGE | AUDIO | WRITING_PROMPT
    title                  VARCHAR(200),
    content                TEXT,
    -- For TEXT: the passage text.
    -- For IMAGE: alt-text description.
    -- For AUDIO: optional text accompanying the audio.
    -- For WRITING_PROMPT: the prompt text shown to the student.
    asset_url              VARCHAR(500),
    -- S3/CDN URL for IMAGE or AUDIO stimuli. NULL for TEXT/WRITING_PROMPT.
    transcript             TEXT,
    -- AUDIO only. Admin/authoring use. MUST NEVER be sent to the student client.
    audio_duration_seconds INTEGER,
    -- AUDIO only. Declared length of the audio clip in seconds.
    year_level             INTEGER CHECK (year_level IN (3, 5, 7, 9)),
    domain                 VARCHAR(50),
    -- Allowed domain values: NUMERACY | READING | WRITING | SPELLING | GRAMMAR_PUNCTUATION
    status                 VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    -- Allowed: DRAFT | REVIEW | PUBLISHED | ARCHIVED
    created_by             UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_stimuli_year_domain ON stimuli(year_level, domain);
CREATE INDEX IF NOT EXISTS idx_stimuli_type        ON stimuli(stimulus_type);
CREATE INDEX IF NOT EXISTS idx_stimuli_status      ON stimuli(status);

-- ================================================================
-- 3. QUESTIONS  (V2 + V34 + V35_999 + V42 + V44 + V57)
-- ================================================================

CREATE TABLE IF NOT EXISTS questions (
    id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_type    VARCHAR(50) NOT NULL,
    -- Allowed: MULTIPLE_CHOICE | MULTI_SELECT | SHORT_ANSWER | FILL_BLANK |
    --          REORDER | MATCHING | DRAG_DROP | AUDIO_RESPONSE |
    --          EXTENDED_WRITING | IMAGE_INTERACTION
    year_level       INTEGER     NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
    domain           VARCHAR(50) NOT NULL,
    -- Allowed: NUMERACY | READING | WRITING | SPELLING | GRAMMAR_PUNCTUATION
    topic            VARCHAR(200) NOT NULL,
    difficulty_band  INTEGER     NOT NULL CHECK (difficulty_band BETWEEN 1 AND 10),
    stimulus_text    TEXT,
    -- Short inline hint text. Full shared passages go to stimuli table + stimulus_id.
    stimulus_type    VARCHAR(20),
    -- Allowed: TEXT | IMAGE | AUDIO | WRITING_PROMPT | NULL
    -- Added V35_999. Present when stimulus_text carries typed content.
    question_text    TEXT        NOT NULL,
    options          JSONB,
    -- MULTIPLE_CHOICE / MULTI_SELECT:
    --   [{"label":"A","text":"Option text"},{"label":"B","text":"..."}]
    -- FILL_BLANK / REORDER / MATCHING / DRAG_DROP: structure varies by type.
    -- NULL for SHORT_ANSWER, EXTENDED_WRITING, AUDIO_RESPONSE.
    correct_answer   JSONB       NOT NULL,
    -- MULTIPLE_CHOICE / SHORT_ANSWER / AUDIO_RESPONSE / FILL_BLANK:
    --   {"value": "A"}  or  {"value": "exact text"}
    -- MULTI_SELECT:
    --   {"values": ["A","C"]}
    -- EXTENDED_WRITING: {"value": null}  (null signals human marking)
    -- REORDER / MATCHING / DRAG_DROP:
    --   {"value": "serialised expected state"}
    explanation      TEXT,
    status           VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    -- Allowed: DRAFT | REVIEW | PUBLISHED | ARCHIVED
    created_by       UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    package_type     VARCHAR(20) NOT NULL DEFAULT 'FREE',
    -- Allowed: FREE | ADVANCED | PREMIUM
    difficulty       VARCHAR(20) NOT NULL DEFAULT 'EASY',
    -- Allowed: EASY | MEDIUM | HARD
    marks            INTEGER     NOT NULL DEFAULT 1,
    -- Point value for this question. Must be >= 1.
    cognitive_skill  VARCHAR(50),
    -- Allowed: RECALL | COMPREHENSION | ANALYSIS | APPLICATION | NULL
    curriculum_strand VARCHAR(100),
    -- Free-text strand label from the Australian Curriculum. Optional.
    audio_url        VARCHAR(500),
    -- S3/CDN URL for AUDIO_RESPONSE questions. NULL for all other types.
    stimulus_id      UUID REFERENCES stimuli(id) ON DELETE SET NULL,
    -- FK to shared stimulus. NULL for standalone questions.
    calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE,
    -- Per-question calculator gate. Added V57.
    -- FALSE: no calculator must be shown, regardless of section/testlet setting.
    -- TRUE (default): defer to testlet.calculator_allowed -> section.calculator_allowed.
    -- Authoritative rules (must be set explicitly in content migrations):
    --   Y3 Numeracy ALL questions:           FALSE
    --   Y5 Numeracy ALL questions:           FALSE
    --   Y7/Y9 Numeracy A-stage Q1-8:         FALSE
    --   Y7/Y9 Numeracy A-stage Q9-16:        TRUE
    --   All other domains (any year level):  TRUE (default, may omit)
    -- V57 backfill: UPDATE questions SET calculator_allowed = FALSE
    --               WHERE domain = 'NUMERACY' AND year_level IN (3, 5);
    marking_rubric   JSONB
    -- EXTENDED_WRITING only.
    -- Structure: {"criteria":[{"name":"Audience","maxMarks":6},...], "totalMarks":50}
    -- NULL for all auto-marked question types.
);

CREATE INDEX IF NOT EXISTS idx_questions_year_domain ON questions(year_level, domain);
CREATE INDEX IF NOT EXISTS idx_questions_type        ON questions(question_type);
CREATE INDEX IF NOT EXISTS idx_questions_package     ON questions(package_type);
CREATE INDEX IF NOT EXISTS idx_questions_status      ON questions(status);
CREATE INDEX IF NOT EXISTS idx_questions_stimulus    ON questions(stimulus_id);

-- ================================================================
-- 4. EXAMS  (V9 + V32 + V34 + V42 + V51)
-- ================================================================

CREATE TABLE IF NOT EXISTS exams (
    id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    title             VARCHAR(200) NOT NULL,
    description       TEXT,
    year_level        INTEGER     NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
    domain            VARCHAR(50) NOT NULL,
    -- Allowed: NUMERACY | READING | WRITING | SPELLING | GRAMMAR_PUNCTUATION
    time_limit_seconds INTEGER    NOT NULL CHECK (time_limit_seconds > 0),
    available_from    TIMESTAMPTZ,
    available_until   TIMESTAMPTZ,
    status            VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    -- Allowed: DRAFT | REVIEW | PUBLISHED | ARCHIVED
    created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    package_type      VARCHAR(20) NOT NULL,
    -- Allowed: FREE | ADVANCED | PREMIUM
    -- Business rule: FREE=5 exams total (1/domain), ADVANCED=25 exams, PREMIUM=50 exams
    scoring_config    JSONB
    -- Optional per-exam scoring overrides.
    -- Structure: {"weightByMarks": true, "passMark": 60, "showBand": true}
    -- NULL = use platform defaults.
);

CREATE INDEX IF NOT EXISTS idx_exams_year_domain   ON exams(year_level, domain);
CREATE INDEX IF NOT EXISTS idx_exams_package_type  ON exams(package_type);
CREATE INDEX IF NOT EXISTS idx_exams_status        ON exams(status);

-- ================================================================
-- 5. EXAM SECTIONS  (V45)
-- ================================================================

CREATE TABLE IF NOT EXISTS exam_sections (
    id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id            UUID        NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    title              VARCHAR(200) NOT NULL,
    section_order      INTEGER     NOT NULL CHECK (section_order >= 1),
    time_limit_seconds INTEGER,
    -- NULL = section inherits the exam-level time_limit_seconds.
    calculator_allowed BOOLEAN     NOT NULL DEFAULT FALSE,
    navigation_locked  BOOLEAN     NOT NULL DEFAULT FALSE,
    -- TRUE = student cannot return to this section once they advance past it.
    domain             VARCHAR(50),
    -- Optional override for COL (cross-domain) exams.
    instructions       TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (exam_id, section_order)
);

CREATE INDEX IF NOT EXISTS idx_sections_exam ON exam_sections(exam_id);

-- ================================================================
-- 6. TESTLETS  (V46)
-- ================================================================

CREATE TABLE IF NOT EXISTS testlets (
    id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id         UUID        NOT NULL REFERENCES exam_sections(id) ON DELETE CASCADE,
    stimulus_id        UUID        REFERENCES stimuli(id) ON DELETE SET NULL,
    -- Shared stimulus for all questions in this testlet (e.g. a reading passage).
    title              VARCHAR(200),
    testlet_order      INTEGER     NOT NULL CHECK (testlet_order >= 1),
    is_branching_node  BOOLEAN     NOT NULL DEFAULT FALSE,
    -- TRUE = branching engine evaluates testlet_transitions after this testlet.
    navigation_locked  BOOLEAN     NOT NULL DEFAULT FALSE,
    -- TRUE = student cannot return to this testlet once they leave it.
    calculator_allowed BOOLEAN,
    -- NULL = inherit from section. Explicit value overrides section setting.
    -- NOTE: questions.calculator_allowed is the authoritative per-question override.
    --       testlet.calculator_allowed is used only as a section-level hint for the
    --       testlet-transition UI (completeTestlet response). The per-question value wins.
    instructions       TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (section_id, testlet_order)
);

CREATE INDEX IF NOT EXISTS idx_testlets_section  ON testlets(section_id);
CREATE INDEX IF NOT EXISTS idx_testlets_stimulus ON testlets(stimulus_id);

-- ================================================================
-- 7. TESTLET TRANSITIONS  (V47)
-- ================================================================

CREATE TABLE IF NOT EXISTS testlet_transitions (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id         UUID        NOT NULL REFERENCES exams(id)    ON DELETE CASCADE,
    source_testlet  UUID        NOT NULL REFERENCES testlets(id) ON DELETE CASCADE,
    target_testlet  UUID        NOT NULL REFERENCES testlets(id) ON DELETE CASCADE,
    condition_type  VARCHAR(30) NOT NULL DEFAULT 'ALWAYS',
    -- Allowed: ALWAYS | SCORE_ABOVE | SCORE_BELOW
    -- Evaluation: all transitions for a source_testlet are ordered by priority DESC.
    -- The first condition that matches is followed. ALWAYS with priority 0 = fallback.
    condition_value JSONB,
    -- SCORE_ABOVE / SCORE_BELOW: {"threshold": 0.6}  (proportion, 0.0-1.0)
    -- ALWAYS: NULL
    priority        INTEGER     NOT NULL DEFAULT 0,
    -- Higher priority is evaluated first. ALWAYS fallback should be priority 0.
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_no_self_loop   CHECK (source_testlet != target_testlet),
    CONSTRAINT chk_condition_type CHECK (condition_type IN ('ALWAYS','SCORE_ABOVE','SCORE_BELOW'))
);

CREATE INDEX IF NOT EXISTS idx_transitions_source ON testlet_transitions(source_testlet);
CREATE INDEX IF NOT EXISTS idx_transitions_exam   ON testlet_transitions(exam_id);

-- ================================================================
-- 8. EXAM QUESTIONS  (V10 + V48)
-- ================================================================

CREATE TABLE IF NOT EXISTS exam_questions (
    exam_id        UUID    NOT NULL REFERENCES exams(id)     ON DELETE CASCADE,
    question_id    UUID    NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    question_order INTEGER NOT NULL CHECK (question_order >= 1),
    -- 1-based position within the exam (or within the testlet when testlet_id is set).
    section_id     UUID    REFERENCES exam_sections(id) ON DELETE SET NULL,
    -- NULL for flat exams with no sections.
    testlet_id     UUID    REFERENCES testlets(id)      ON DELETE SET NULL,
    -- NULL for flat exams with no testlets.
    PRIMARY KEY (exam_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_exam_questions_exam     ON exam_questions(exam_id);
CREATE INDEX IF NOT EXISTS idx_exam_questions_order    ON exam_questions(exam_id, question_order);
CREATE INDEX IF NOT EXISTS idx_exam_questions_section  ON exam_questions(section_id);
CREATE INDEX IF NOT EXISTS idx_exam_questions_testlet  ON exam_questions(testlet_id);

-- ================================================================
-- 9. EXAM SESSIONS  (V3 + V11 + V42 + V50)
-- ================================================================
-- Created by exam engine at runtime. Shown here for cross-reference only.
-- Content engine does NOT insert into this table.

-- CREATE TABLE IF NOT EXISTS exam_sessions (
--     id                    UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
--     user_id               UUID        NOT NULL REFERENCES users(id),
--     exam_type             VARCHAR(50) NOT NULL,
--     year_level            INTEGER     NOT NULL,
--     domain                VARCHAR(50),
--     question_ids          JSONB       NOT NULL,
--     status                VARCHAR(50) NOT NULL DEFAULT 'IN_PROGRESS',
--     started_at            TIMESTAMPTZ,
--     submitted_at          TIMESTAMPTZ,
--     expires_at            TIMESTAMPTZ,
--     time_limit_seconds    INTEGER,
--     created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     exam_id               UUID        REFERENCES exams(id) ON DELETE SET NULL,    -- V11
--     current_section_id    UUID,                                                   -- V50
--     current_testlet_id    UUID,                                                   -- V50
--     current_question_order INTEGER,                                               -- V50
--     question_path         JSONB       DEFAULT '[]',                               -- V50
--     randomisation_seed    BIGINT,                                                 -- V50
--     flagged_questions     JSONB       DEFAULT '[]',                               -- V50
--     answer_count          INTEGER     NOT NULL DEFAULT 0,                         -- V50
--     has_snapshot          BOOLEAN     NOT NULL DEFAULT FALSE                      -- V50
-- );

-- ================================================================
-- 10. SESSION QUESTION SNAPSHOTS  (V49)
-- ================================================================
-- Immutable snapshot written when a student starts an exam.
-- All question reads during the session use this table, not questions.
-- Content engine does NOT insert into this table -- it is populated by the exam engine.

-- CREATE TABLE IF NOT EXISTS session_question_snapshots (
--     session_id     UUID    NOT NULL REFERENCES exam_sessions(id) ON DELETE CASCADE,
--     question_id    UUID    NOT NULL,
--     -- Intentionally NOT a FK -- snapshot is immutable even if question is deleted.
--     question_order INTEGER NOT NULL,
--     testlet_id     UUID,   -- NULL for flat (non-testlet) sessions
--     section_id     UUID,   -- NULL for flat sessions
--     snapshot       JSONB   NOT NULL,
--     -- Snapshot fields written by ExamSnapshotService.buildSnapshot() (V49 + V57):
--     --   RENDER fields (sent to student via studentView()):
--     --     questionId, questionType, questionText, domain, yearLevel, topic,
--     --     difficultyBand, marks, options, audioUrl, calculatorAllowed,
--     --     stimulusText, stimulusType,
--     --     stimulusId, stimulusSharedType, stimulusContent, stimulusAssetUrl, stimulusTitle,
--     --     cognitiveSkill, curriculumStrand
--     --   SERVER-SIDE ONLY fields (stripped by studentView() before API response):
--     --     correctAnswer  -- used for server-side grading; MUST NEVER reach the student client
--     --     markingRubric  -- used for EXTENDED_WRITING admin marking
--     --     explanation    -- shown to student only AFTER submission
--     -- calculatorAllowed was added to the snapshot by V57; older snapshots lack this field
--     -- and ExamSnapshotService defaults to true when the field is absent.
--     PRIMARY KEY (session_id, question_id)
-- );

-- ================================================================
-- 11. EXAM RESULTS  (V3 + V42 + V53)
-- ================================================================
-- Written by exam engine on submission. Content engine does NOT insert here.

-- CREATE TABLE IF NOT EXISTS exam_results (
--     id               UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
--     session_id       UUID           NOT NULL UNIQUE REFERENCES exam_sessions(id),
--     user_id          UUID           NOT NULL REFERENCES users(id),
--     total_questions  INTEGER        NOT NULL,
--     correct_answers  INTEGER        NOT NULL,
--     score_percentage DOUBLE PRECISION NOT NULL,
--     naplan_band      INTEGER        NOT NULL,
--     domain_breakdown JSONB,
--     topic_breakdown  JSONB,
--     calculated_at    TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
--     exam_id          UUID           REFERENCES exams(id) ON DELETE SET NULL,  -- V42
--     practice_label   VARCHAR(50),                                             -- V42
--     pending_review   BOOLEAN        NOT NULL DEFAULT FALSE                    -- V53
-- );

-- ================================================================
-- 12. PRACTICE SCORE BANDS  (V51)
-- ================================================================
-- Seeded by V51. Content engine does NOT modify this table.
-- Admin API manages band labels/thresholds.

-- CREATE TABLE IF NOT EXISTS practice_score_bands (
--     id          SERIAL  PRIMARY KEY,
--     year_level  INTEGER NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
--     domain      VARCHAR(50) NOT NULL,
--     band        INTEGER NOT NULL CHECK (band BETWEEN 1 AND 10),
--     label       VARCHAR(100) NOT NULL,
--     min_percent NUMERIC(5,2) NOT NULL,
--     max_percent NUMERIC(5,2) NOT NULL,
--     UNIQUE (year_level, domain, band)
-- );

-- ================================================================
-- 13. USER TAGS  (V32 + V42)
-- ================================================================
-- Written by subscription engine on purchase. Content engine does NOT insert here.

-- CREATE TABLE IF NOT EXISTS user_tags (
--     user_id UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
--     tag     VARCHAR(20) NOT NULL,
--     PRIMARY KEY (user_id, tag)
-- );
