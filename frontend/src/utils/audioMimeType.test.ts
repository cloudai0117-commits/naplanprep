import { describe, it, expect } from 'vitest'
import { audioMimeType } from './audioMimeType'

describe('audioMimeType', () => {
  it('returns audio/wav for .wav URL', () => {
    expect(audioMimeType('s3://naplanprep-content/audio/3/S1_01.wav')).toBe('audio/wav')
  })

  it('returns audio/mpeg for .mp3 URL', () => {
    expect(audioMimeType('https://cdn.example.com/audio/S1_01.mp3')).toBe('audio/mpeg')
  })

  it('returns audio/ogg for .ogg URL', () => {
    expect(audioMimeType('https://cdn.example.com/audio/S1_01.ogg')).toBe('audio/ogg')
  })

  it('returns undefined for an unrecognised extension', () => {
    expect(audioMimeType('https://cdn.example.com/audio/S1_01.aac')).toBeUndefined()
  })

  it('strips query string before reading extension (presigned URL)', () => {
    const presigned =
      'https://s3.amazonaws.com/bucket/audio/S1_01.wav?X-Amz-Signature=abc123&X-Amz-Expires=3600'
    expect(audioMimeType(presigned)).toBe('audio/wav')
  })

  it('strips fragment before reading extension', () => {
    expect(audioMimeType('https://cdn.example.com/audio/S1_01.mp3#t=0')).toBe('audio/mpeg')
  })

  it('returns undefined when URL has no extension', () => {
    expect(audioMimeType('https://cdn.example.com/audio/S1_01')).toBeUndefined()
  })
})
