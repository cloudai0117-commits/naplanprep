import { vi } from 'vitest'

// Provide a minimal localStorage implementation for zustand/persist in node test environment
const _store: Record<string, string> = {}

vi.stubGlobal('localStorage', {
  getItem: (key: string) => _store[key] ?? null,
  setItem: (key: string, value: string) => { _store[key] = value },
  removeItem: (key: string) => { delete _store[key] },
  clear: () => { Object.keys(_store).forEach((k) => { delete _store[k] }) },
  length: 0,
  key: (_index: number) => null,
} satisfies Storage)
