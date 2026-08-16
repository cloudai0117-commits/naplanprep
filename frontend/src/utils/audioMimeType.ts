/**
 * Returns the MIME type for a known audio file extension, or undefined if the
 * format cannot be determined from the URL. Callers should omit the `type`
 * attribute entirely when undefined rather than guessing — browsers handle
 * format detection better than a wrong MIME declaration.
 *
 * Strips query strings and fragments before inspecting the extension so that
 * signed/presigned URLs (e.g. `s3.amazonaws.com/...S1_01.wav?X-Amz-...`) are
 * handled correctly.
 */
export function audioMimeType(url: string): string | undefined {
  const ext = url.split('?')[0].split('#')[0].split('.').pop()?.toLowerCase()
  switch (ext) {
    case 'wav':  return 'audio/wav'
    case 'mp3':  return 'audio/mpeg'
    case 'ogg':  return 'audio/ogg'
    default:     return undefined
  }
}
