import { describe, it, expect } from 'vitest'
import { shortAnswerPlaceholder, showSpellingHint } from './examPlayerUtils'

describe('shortAnswerPlaceholder', () => {
  it('returns spelling-specific placeholder for SPELLING domain', () => {
    expect(shortAnswerPlaceholder('SPELLING')).toBe('Type the missing word here')
  })

  it('returns neutral placeholder for NUMERACY domain', () => {
    expect(shortAnswerPlaceholder('NUMERACY')).toBe('Type your answer here')
  })

  it('returns neutral placeholder for READING domain', () => {
    expect(shortAnswerPlaceholder('READING')).toBe('Type your answer here')
  })

  it('returns neutral placeholder for WRITING domain', () => {
    expect(shortAnswerPlaceholder('WRITING')).toBe('Type your answer here')
  })

  it('returns neutral placeholder for GRAMMAR_PUNCTUATION domain', () => {
    expect(shortAnswerPlaceholder('GRAMMAR_PUNCTUATION')).toBe('Type your answer here')
  })

  it('returns neutral placeholder for undefined domain', () => {
    expect(shortAnswerPlaceholder(undefined)).toBe('Type your answer here')
  })
})

describe('showSpellingHint', () => {
  it('returns true for SPELLING domain — hint must be visible', () => {
    expect(showSpellingHint('SPELLING')).toBe(true)
  })

  it('returns false for NUMERACY domain — spelling hint must NOT appear', () => {
    expect(showSpellingHint('NUMERACY')).toBe(false)
  })

  it('returns false for READING domain', () => {
    expect(showSpellingHint('READING')).toBe(false)
  })

  it('returns false for WRITING domain', () => {
    expect(showSpellingHint('WRITING')).toBe(false)
  })

  it('returns false for GRAMMAR_PUNCTUATION domain', () => {
    expect(showSpellingHint('GRAMMAR_PUNCTUATION')).toBe(false)
  })

  it('returns false for undefined domain', () => {
    expect(showSpellingHint(undefined)).toBe(false)
  })
})
