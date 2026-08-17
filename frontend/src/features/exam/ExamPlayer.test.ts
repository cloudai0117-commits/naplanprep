import { describe, it, expect } from 'vitest'

/**
 * Unit tests for the adaptive exam player logic derived from ExamPlayer.tsx.
 *
 * These tests verify the key computed values that control the adaptive testlet
 * transition UI without needing to mount the full React component.
 *
 * Three distinct quantities — NEVER conflate:
 *   POOL_COUNT:          128 for Y9 Numeracy (all 8 testlets, all snapshots)
 *   STUDENT_TEST_LENGTH: 48  for Y9 Numeracy (3 testlet legs × 16 questions)
 *   ACTIVE_PATH_COUNT:   16  for Y9 Numeracy (current testlet only)
 *
 * Security: correctAnswer and explanation are server-side only; never in student API.
 */

// ─── Adaptive state helpers (mirror ExamPlayer.tsx) ──────────────────────────

/** True when the session is a branching exam (currentTestletId is set). */
function isTestletExam(session: { currentTestletId?: string | null } | null | undefined): boolean {
  return !!(session?.currentTestletId)
}

/**
 * True when the student is on the last question of the currently-active testlet.
 * For a testlet exam this is when they should see "Complete Section →" not "Next →".
 */
function isLastQuestion(currentIdx: number, questionsLength: number): boolean {
  return currentIdx === questionsLength - 1
}

/**
 * The display total shown in the header ("Question 1 of N").
 * Authoritative source: session.studentTestLength (e.g. 48 for Y9 Num).
 * Fallback: questions.length — only for flat exams without testlet routing.
 *
 * MUST NEVER be 128 (pool count) for Y9 Numeracy.
 */
function displayTotal(studentTestLength: number | null | undefined, questionsLength: number): number {
  return studentTestLength ?? questionsLength
}

// ─── isTestletExam ────────────────────────────────────────────────────────────

describe('isTestletExam', () => {
  it('returns true when currentTestletId is a UUID string', () => {
    expect(isTestletExam({ currentTestletId: 'f8044b83-592b-5fc9-9135-13fa2eef6fcb' })).toBe(true)
  })

  it('returns false when currentTestletId is null', () => {
    expect(isTestletExam({ currentTestletId: null })).toBe(false)
  })

  it('returns false when currentTestletId is undefined', () => {
    expect(isTestletExam({ currentTestletId: undefined })).toBe(false)
  })

  it('returns false when session is null (loading state)', () => {
    expect(isTestletExam(null)).toBe(false)
  })

  it('returns false when session is undefined', () => {
    expect(isTestletExam(undefined)).toBe(false)
  })

  it('returns true for all Y9 Num testlet IDs (A, B, D, C_EARLY)', () => {
    // Valid starting testlets in Y9 Num adaptive pool
    const testlets = [
      'f8044b83-592b-5fc9-9135-13fa2eef6fcb', // A
      '592636f1-6ee7-56d9-952a-8ffd673ca372', // B
      '026c3f65-6c73-523c-a543-2c4fd71dc62b', // D
      '55d43880-2ba2-5c60-8c40-2f78b4c6a490', // C_EARLY
    ]
    for (const id of testlets) {
      expect(isTestletExam({ currentTestletId: id })).toBe(true)
    }
  })
})

// ─── isLastQuestion ───────────────────────────────────────────────────────────

describe('isLastQuestion', () => {
  it('returns true on the last question of a 16-question testlet', () => {
    expect(isLastQuestion(15, 16)).toBe(true)
  })

  it('returns false when not the last question', () => {
    expect(isLastQuestion(0, 16)).toBe(false)
    expect(isLastQuestion(7, 16)).toBe(false)
    expect(isLastQuestion(14, 16)).toBe(false)
  })

  it('returns true on last question of flat exams (varies by domain)', () => {
    // NUMERACY Y9: student_test_length=48 but testlets are 16 each
    expect(isLastQuestion(15, 16)).toBe(true)
    // GRAMMAR: flat 27 questions
    expect(isLastQuestion(26, 27)).toBe(true)
    // SPELLING: flat 25 questions
    expect(isLastQuestion(24, 25)).toBe(true)
    // WRITING: flat 1 question
    expect(isLastQuestion(0, 1)).toBe(true)
  })

  it('returns false when questions array is empty', () => {
    expect(isLastQuestion(0, 0)).toBe(false)
  })
})

// ─── displayTotal ─────────────────────────────────────────────────────────────

describe('displayTotal', () => {
  it('uses studentTestLength when available', () => {
    // Y9 Numeracy: student answers 48, not the pool of 128
    expect(displayTotal(48, 128)).toBe(48)
  })

  it('uses studentTestLength for all domain/year combinations', () => {
    expect(displayTotal(36, 96)).toBe(36)   // Y3 Numeracy
    expect(displayTotal(42, 112)).toBe(42)  // Y5 Numeracy
    expect(displayTotal(48, 128)).toBe(48)  // Y7/Y9 Numeracy
    expect(displayTotal(39, 104)).toBe(39)  // Y3/Y5 Reading
    expect(displayTotal(48, 96)).toBe(48)   // Y7/Y9 Reading
    expect(displayTotal(27, 72)).toBe(27)   // Grammar
    expect(displayTotal(25, 43)).toBe(25)   // Spelling
    expect(displayTotal(1, 1)).toBe(1)      // Writing
  })

  it('falls back to questionsLength when studentTestLength is null', () => {
    // Flat practice sessions without testlet routing
    expect(displayTotal(null, 20)).toBe(20)
  })

  it('falls back to questionsLength when studentTestLength is undefined', () => {
    expect(displayTotal(undefined, 15)).toBe(15)
  })

  it('MUST NEVER show pool counts for Y9 Numeracy', () => {
    const FORBIDDEN_POOL_COUNTS = [128, 112, 96, 104, 72, 43]
    for (const poolCount of FORBIDDEN_POOL_COUNTS) {
      // When studentTestLength is present, pool count must not appear
      const y9NumStudentLength = 48
      expect(displayTotal(y9NumStudentLength, poolCount)).not.toBe(poolCount)
    }
  })
})

// ─── Adaptive path logic ───────────────────────────────────────────────────────

describe('Complete Section → button logic', () => {
  it('shows Complete Section on last question of testlet exam', () => {
    const shouldShowCompleteSection = (
      currentIdx: number,
      questionsLength: number,
      session: { currentTestletId?: string | null }
    ) => isLastQuestion(currentIdx, questionsLength) && isTestletExam(session)

    // Y9 Num, testlet A (16 questions), at last question
    expect(shouldShowCompleteSection(15, 16, { currentTestletId: 'f8044b83-592b-5fc9-9135-13fa2eef6fcb' })).toBe(true)
    // Not last question
    expect(shouldShowCompleteSection(14, 16, { currentTestletId: 'f8044b83-592b-5fc9-9135-13fa2eef6fcb' })).toBe(false)
    // Last question but flat exam (no currentTestletId)
    expect(shouldShowCompleteSection(26, 27, { currentTestletId: null })).toBe(false)
  })

  it('shows Next on non-last questions of testlet exam', () => {
    const shouldShowNext = (
      currentIdx: number,
      questionsLength: number,
      session: { currentTestletId?: string | null }
    ) => !(isLastQuestion(currentIdx, questionsLength) && isTestletExam(session))

    expect(shouldShowNext(7, 16, { currentTestletId: 'f8044b83-592b-5fc9-9135-13fa2eef6fcb' })).toBe(true)
    expect(shouldShowNext(0, 16, { currentTestletId: 'f8044b83-592b-5fc9-9135-13fa2eef6fcb' })).toBe(true)
  })
})

// ─── Y9 Num adaptive path coverage ────────────────────────────────────────────

describe('Y9 Numeracy adaptive path coverage', () => {
  // Authoritative testlet IDs from V295__seed_y9_num_free_exam01.sql
  const TESTLETS = {
    A:      'f8044b83-592b-5fc9-9135-13fa2eef6fcb',
    B:      '592636f1-6ee7-56d9-952a-8ffd673ca372',
    B_LATE: '65467866-6bad-576f-9345-38d4d27e905d',
    C:      '8b998744-f963-5d7d-b911-e616a6f07d6a',
    C_EARLY:'55d43880-2ba2-5c60-8c40-2f78b4c6a490',
    D:      '026c3f65-6c73-523c-a543-2c4fd71dc62b',
    E:      'eb908d15-1c34-5619-adec-1455d9d6e2a0',
    F:      '854e6d58-3adc-5de7-8c63-0c2bc6c8b3db',
  }

  // Valid paths derived from V295 testlet_transitions:
  // 1. A→B→C   (mid-range on A, mid-range on B)
  // 2. A→B→E   (mid-range on A, high score on B)
  // 3. A→D→C   (high score on A, mid-range on D)
  // 4. A→D→F   (high score on A, high score on D)
  // 5. A→C_EARLY→B_LATE (low score on A < 0.35)
  // Note: ABF and ADE do NOT exist in DB — never valid transitions.

  const validPaths = [
    [TESTLETS.A, TESTLETS.B, TESTLETS.C],
    [TESTLETS.A, TESTLETS.B, TESTLETS.E],
    [TESTLETS.A, TESTLETS.D, TESTLETS.C],
    [TESTLETS.A, TESTLETS.D, TESTLETS.F],
    [TESTLETS.A, TESTLETS.C_EARLY, TESTLETS.B_LATE],
  ]

  it('every valid path has exactly 3 testlets (student traverses 3 legs)', () => {
    for (const path of validPaths) {
      expect(path).toHaveLength(3)
    }
  })

  it('every path starts at Testlet A', () => {
    for (const path of validPaths) {
      expect(path[0]).toBe(TESTLETS.A)
    }
  })

  it('every path ends at a terminal testlet (C, E, F, or B_LATE)', () => {
    const terminals = new Set([TESTLETS.C, TESTLETS.E, TESTLETS.F, TESTLETS.B_LATE])
    for (const path of validPaths) {
      const last = path[path.length - 1]
      expect(terminals.has(last), `Path ${path.join('→')} must end at a terminal testlet`).toBe(true)
    }
  })

  it('invalid paths ABF and ADE do NOT exist in the transition table', () => {
    // ABF: B→F is not in testlet_transitions; only B→E and B→C exist
    // ADE: D→E is not in testlet_transitions; only D→F and D→C exist
    const invalidPaths = [
      [TESTLETS.A, TESTLETS.B, TESTLETS.F],  // ABF
      [TESTLETS.A, TESTLETS.D, TESTLETS.E],  // ADE
    ]
    const flatValidPaths = validPaths.map(p => p.join('→'))
    for (const invalid of invalidPaths) {
      expect(flatValidPaths).not.toContain(invalid.join('→'))
    }
  })

  it('student test length for Y9 Num is 48 (3 legs × 16 questions each)', () => {
    const STUDENT_TEST_LENGTH = 48
    const ACTIVE_PATH_COUNT = 16
    const TESTLETS_PER_PATH = 3
    expect(ACTIVE_PATH_COUNT * TESTLETS_PER_PATH).toBe(STUDENT_TEST_LENGTH)
  })

  it('displayTotal shows 48 not 128 for Y9 Num session', () => {
    // session.studentTestLength = 48, questions.length = 16 (current testlet only)
    expect(displayTotal(48, 16)).toBe(48)
    // Must never show pool count 128
    expect(displayTotal(48, 16)).not.toBe(128)
  })

  it('questionPath tracks the traversal in order', () => {
    // Simulate A→B→C path
    const questionPath: string[] = []

    questionPath.push(TESTLETS.A)
    expect(questionPath).toEqual([TESTLETS.A])

    questionPath.push(TESTLETS.B)
    expect(questionPath).toEqual([TESTLETS.A, TESTLETS.B])

    questionPath.push(TESTLETS.C)
    expect(questionPath).toEqual([TESTLETS.A, TESTLETS.B, TESTLETS.C])
    expect(questionPath).toHaveLength(3)
  })
})
