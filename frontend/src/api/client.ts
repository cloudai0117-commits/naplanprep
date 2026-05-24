import axios from 'axios'
import { useAuthStore } from '@/store/authStore'

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().accessToken
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config
    // Skip token refresh for auth endpoints — a 401 from /auth/login is a bad-credentials
    // error that must surface to the caller, not trigger a refresh cycle.
    const isAuthEndpoint = originalRequest.url?.includes('/auth/')
    if (error.response?.status === 401 && !originalRequest._retry && !isAuthEndpoint) {
      originalRequest._retry = true
      const refreshToken = useAuthStore.getState().refreshToken
      if (refreshToken) {
        try {
          const response = await axios.post(
            `${import.meta.env.VITE_API_URL}/auth/refresh`,
            { refreshToken }
          )
          const { accessToken } = response.data.data
          useAuthStore.getState().setTokens(accessToken, refreshToken)
          originalRequest.headers.Authorization = `Bearer ${accessToken}`
          return apiClient(originalRequest)
        } catch {
          useAuthStore.getState().logout()
          window.location.href = '/login'
        }
      } else {
        useAuthStore.getState().logout()
        window.location.href = '/login'
      }
    }
    return Promise.reject(error)
  }
)

export default apiClient
