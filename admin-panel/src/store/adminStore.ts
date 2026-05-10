import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AdminUser {
  id: string
  email: string
  firstName: string
  role: string
}

interface AdminStore {
  user: AdminUser | null
  accessToken: string | null
  isAuthenticated: boolean
  setAuth: (user: AdminUser, token: string) => void
  logout: () => void
}

export const useAdminStore = create<AdminStore>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      isAuthenticated: false,
      setAuth: (user, accessToken) => {
        localStorage.setItem('admin-token', accessToken)
        set({ user, accessToken, isAuthenticated: true })
      },
      logout: () => {
        localStorage.removeItem('admin-token')
        set({ user: null, accessToken: null, isAuthenticated: false })
      },
    }),
    { name: 'naplanprep-admin' }
  )
)
