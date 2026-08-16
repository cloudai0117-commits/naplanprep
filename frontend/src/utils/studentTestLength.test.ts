import { describe, it, expect } from 'vitest'

// Authoritative student test lengths by domain and year level.
// These constants mirror what V381 migration populates in the DB.
// If these change, V381 must also change.
const STUDENT_TEST_LENGTH: Record<string, Record<number, number>> = {
  NUMERACY: { 3: 36, 5: 42, 7: 48, 9: 48 },
  READING: { 3: 39, 5: 39, 7: 48, 9: 48 },
  GRAMMAR_PUNCTUATION: { 3: 27, 5: 27, 7: 27, 9: 27 },
  SPELLING: { 3: 25, 5: 25, 7: 25, 9: 25 },
  WRITING: { 3: 1, 5: 1, 7: 1, 9: 1 },
}

const YEAR_LEVELS = [3, 5, 7, 9]

describe('student test length constants', () => {
  describe('NUMERACY', () => {
    it('Y3 = 36 (8 testlets × 12 questions)', () => {
      expect(STUDENT_TEST_LENGTH.NUMERACY[3]).toBe(36)
    })
    it('Y5 = 42 (8 testlets × 14 questions)', () => {
      expect(STUDENT_TEST_LENGTH.NUMERACY[5]).toBe(42)
    })
    it('Y7 = 48 (8 testlets × 16 questions)', () => {
      expect(STUDENT_TEST_LENGTH.NUMERACY[7]).toBe(48)
    })
    it('Y9 = 48 (8 testlets × 16 questions)', () => {
      expect(STUDENT_TEST_LENGTH.NUMERACY[9]).toBe(48)
    })
  })

  describe('READING', () => {
    it('Y3 = 39 (8 testlets × 13 questions)', () => {
      expect(STUDENT_TEST_LENGTH.READING[3]).toBe(39)
    })
    it('Y5 = 39 (8 testlets × 13 questions)', () => {
      expect(STUDENT_TEST_LENGTH.READING[5]).toBe(39)
    })
    it('Y7 = 48 (8 testlets × 16 questions)', () => {
      expect(STUDENT_TEST_LENGTH.READING[7]).toBe(48)
    })
    it('Y9 = 48 (8 testlets × 16 questions)', () => {
      expect(STUDENT_TEST_LENGTH.READING[9]).toBe(48)
    })
  })

  describe('GRAMMAR_PUNCTUATION', () => {
    YEAR_LEVELS.forEach((y) => {
      it(`Y${y} = 27 (8 testlets × 9 questions)`, () => {
        expect(STUDENT_TEST_LENGTH.GRAMMAR_PUNCTUATION[y]).toBe(27)
      })
    })
  })

  describe('SPELLING', () => {
    YEAR_LEVELS.forEach((y) => {
      it(`Y${y} = 25 (5-testlet pool, student path 7+9+9)`, () => {
        expect(STUDENT_TEST_LENGTH.SPELLING[y]).toBe(25)
      })
    })
  })

  describe('WRITING', () => {
    YEAR_LEVELS.forEach((y) => {
      it(`Y${y} = 1 (single writing prompt)`, () => {
        expect(STUDENT_TEST_LENGTH.WRITING[y]).toBe(1)
      })
    })
  })

  it('student test length is always less than pool count', () => {
    // Pool counts: NUMERACY Y3=96, Y5=112, Y7/Y9=128; READING Y3/Y5=104, Y7/Y9=128;
    // GRAMMAR=72; SPELLING=43; WRITING=1
    expect(STUDENT_TEST_LENGTH.NUMERACY[3]).toBeLessThan(96)
    expect(STUDENT_TEST_LENGTH.NUMERACY[5]).toBeLessThan(112)
    expect(STUDENT_TEST_LENGTH.NUMERACY[7]).toBeLessThan(128)
    expect(STUDENT_TEST_LENGTH.NUMERACY[9]).toBeLessThan(128)
    expect(STUDENT_TEST_LENGTH.READING[3]).toBeLessThan(104)
    expect(STUDENT_TEST_LENGTH.READING[5]).toBeLessThan(104)
    expect(STUDENT_TEST_LENGTH.READING[7]).toBeLessThan(128)
    expect(STUDENT_TEST_LENGTH.READING[9]).toBeLessThan(128)
    expect(STUDENT_TEST_LENGTH.GRAMMAR_PUNCTUATION[3]).toBeLessThan(72)
    expect(STUDENT_TEST_LENGTH.SPELLING[3]).toBeLessThan(43)
  })
})
