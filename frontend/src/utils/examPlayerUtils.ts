/** Returns the SHORT_ANSWER input placeholder for the given question domain. */
export function shortAnswerPlaceholder(domain: string | undefined): string {
  return domain === 'SPELLING' ? 'Type the missing word here' : 'Type your answer here'
}

/** Returns true when the "Type one word. Spelling counts." hint should be shown. */
export function showSpellingHint(domain: string | undefined): boolean {
  return domain === 'SPELLING'
}
