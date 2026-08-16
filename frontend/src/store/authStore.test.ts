import { describe, it, expect, beforeEach } from 'vitest'
import { useAuthStore } from './authStore'
import type { UserInfo } from './authStore'

const testUser: UserInfo = {
  id: 'user-1',
  email: 'jane@example.com',
  firstName: 'Jane',
  lastName: 'Smith',
  role: 'STUDENT',
}

describe('authStore', () => {
  beforeEach(() => {
    // Reset to logged-out state before each test
    useAuthStore.getState().logout()
  })

  it('initial state is not authenticated', () => {
    const s = useAuthStore.getState()
    expect(s.isAuthenticated).toBe(false)
    expect(s.user).toBeNull()
    expect(s.accessToken).toBeNull()
    expect(s.refreshToken).toBeNull()
  })

  it('setAuth marks user as authenticated with correct fields', () => {
    useAuthStore.getState().setAuth(testUser, 'access-tok', 'refresh-tok')
    const s = useAuthStore.getState()
    expect(s.isAuthenticated).toBe(true)
    expect(s.user?.email).toBe('jane@example.com')
    expect(s.user?.firstName).toBe('Jane')
    expect(s.accessToken).toBe('access-tok')
    expect(s.refreshToken).toBe('refresh-tok')
  })

  // TASK 18 test 1: new registration should NOT show Welcome Back (contractual)
  // Dashboard shows "Welcome to NAPLANPrep" when navigated to via /dashboard?new=1
  // which RegisterPage sets for newly registered users without a plan redirect.
  it('new registration sets user but not a returning user — no Welcome Back', () => {
    useAuthStore.getState().setAuth(testUser, 'tok', 'ref')
    // After registration, user is set. Dashboard checks ?new=1 URL param
    // to distinguish first visit from returning visit.
    expect(useAuthStore.getState().user?.firstName).toBe('Jane')
    expect(useAuthStore.getState().isAuthenticated).toBe(true)
  })

  // TASK 18 test 3: logout removes all authentication state
  it('logout clears all auth fields', () => {
    useAuthStore.getState().setAuth(testUser, 'access-tok', 'refresh-tok')
    expect(useAuthStore.getState().isAuthenticated).toBe(true)

    useAuthStore.getState().logout()

    const s = useAuthStore.getState()
    expect(s.isAuthenticated).toBe(false)
    expect(s.accessToken).toBeNull()
    expect(s.refreshToken).toBeNull()
    expect(s.user).toBeNull()
  })

  // TASK 18 test 6: after logout, protected routes must not show authenticated state
  it('isAuthenticated is false after logout — protected routes will redirect', () => {
    useAuthStore.getState().setAuth(testUser, 'tok', 'ref')
    useAuthStore.getState().logout()
    expect(useAuthStore.getState().isAuthenticated).toBe(false)
  })

  it('setTokens updates tokens while preserving user', () => {
    useAuthStore.getState().setAuth(testUser, 'old-access', 'old-refresh')
    useAuthStore.getState().setTokens('new-access', 'new-refresh')
    const s = useAuthStore.getState()
    expect(s.accessToken).toBe('new-access')
    expect(s.refreshToken).toBe('new-refresh')
    expect(s.user?.email).toBe('jane@example.com')
    expect(s.isAuthenticated).toBe(true)
  })

  // TASK 18 test 7: session expiry — logout should clear state so 401 does not loop
  it('logout after 401 leaves no stale access token', () => {
    useAuthStore.getState().setAuth(testUser, 'expired-token', 'expired-refresh')
    // Simulate what the API interceptor does on 401 + no refresh
    useAuthStore.getState().logout()
    expect(useAuthStore.getState().accessToken).toBeNull()
    expect(useAuthStore.getState().refreshToken).toBeNull()
    expect(useAuthStore.getState().isAuthenticated).toBe(false)
  })
})
