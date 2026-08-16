import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Link, useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'
import { useAuthStore } from '@/store/authStore'

const loginSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(1, 'Password is required'),
})

type LoginData = z.infer<typeof loginSchema>

export default function LoginPage() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)
  const [showForgotPassword, setShowForgotPassword] = useState(false)
  const [forgotEmail, setForgotEmail] = useState('')
  const [forgotSubmitted, setForgotSubmitted] = useState(false)
  const [forgotError, setForgotError] = useState<string | null>(null)

  const { register, handleSubmit, formState: { errors } } = useForm<LoginData>({
    resolver: zodResolver(loginSchema),
  })

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: LoginData) => apiClient.post('/auth/login', data),
    onSuccess: (res) => {
      const { accessToken, refreshToken, user } = res.data.data
      setAuth(user, accessToken, refreshToken)
      navigate('/dashboard')
    },
  })

  const { mutate: sendForgotPassword, isPending: forgotPending } = useMutation({
    mutationFn: (email: string) => apiClient.post('/auth/forgot-password', { email }),
    onSuccess: () => {
      setForgotSubmitted(true)
      setForgotError(null)
    },
    onError: () => {
      // Always show generic success — do not reveal whether email exists
      setForgotSubmitted(true)
      setForgotError(null)
    },
  })

  const handleForgotSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setForgotError(null)
    if (!forgotEmail || !/\S+@\S+\.\S+/.test(forgotEmail)) {
      setForgotError('Please enter a valid email address.')
      return
    }
    sendForgotPassword(forgotEmail)
  }

  if (showForgotPassword) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
        <div className="sm:mx-auto sm:w-full sm:max-w-md">
          <Link to="/" className="block text-center text-2xl font-bold text-primary-600 mb-6">
            NAPLANPrep
          </Link>
          <h2 className="text-center text-3xl font-bold text-gray-900">Reset your password</h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            Enter your email and we'll send you a reset link.
          </p>
        </div>

        <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
          <div className="card py-8 px-4 shadow sm:rounded-xl sm:px-10">
            {forgotSubmitted ? (
              <div className="space-y-4 text-center">
                <div className="text-4xl">📧</div>
                <p className="text-sm text-gray-700">
                  If an account exists for that email address, a password reset link has been sent.
                  Please check your inbox (and spam folder).
                </p>
                <button
                  onClick={() => {
                    setShowForgotPassword(false)
                    setForgotSubmitted(false)
                    setForgotEmail('')
                  }}
                  className="btn-secondary w-full py-2 text-sm"
                >
                  Back to Sign in
                </button>
              </div>
            ) : (
              <form className="space-y-6" onSubmit={handleForgotSubmit}>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Email address</label>
                  <input
                    type="email"
                    autoComplete="email"
                    value={forgotEmail}
                    onChange={(e) => setForgotEmail(e.target.value)}
                    className="input-field"
                    placeholder="you@example.com"
                  />
                  {forgotError && <p className="mt-1 text-xs text-red-600">{forgotError}</p>}
                </div>

                <button type="submit" disabled={forgotPending} className="btn-primary w-full py-3">
                  {forgotPending ? 'Sending...' : 'Send reset link'}
                </button>

                <button
                  type="button"
                  onClick={() => setShowForgotPassword(false)}
                  className="w-full text-sm text-gray-500 hover:text-gray-700 text-center"
                >
                  ← Back to Sign in
                </button>
              </form>
            )}
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <Link to="/" className="block text-center text-2xl font-bold text-primary-600 mb-6">
          NAPLANPrep
        </Link>
        <h2 className="text-center text-3xl font-bold text-gray-900">Sign in to your account</h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Don't have an account?{' '}
          <Link to="/register" className="font-medium text-primary-600 hover:text-primary-500">
            Create account
          </Link>
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="card py-8 px-4 shadow sm:rounded-xl sm:px-10">
          {error && (
            <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
              {(error as any)?.response?.data?.errors?.[0] || 'Invalid email or password'}
            </div>
          )}

          <form className="space-y-6" onSubmit={handleSubmit((d) => mutate(d))}>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                {...register('email')}
                type="email"
                autoComplete="email"
                required
                className="input-field"
                placeholder="you@example.com"
              />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email.message}</p>}
            </div>

            <div>
              <div className="flex items-center justify-between mb-1">
                <label className="block text-sm font-medium text-gray-700">Password</label>
                <button
                  type="button"
                  onClick={() => setShowForgotPassword(true)}
                  className="text-xs text-primary-600 hover:text-primary-500 hover:underline"
                >
                  Forgot password?
                </button>
              </div>
              <input
                {...register('password')}
                type="password"
                autoComplete="current-password"
                className="input-field"
                placeholder="••••••••"
              />
              {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password.message}</p>}
            </div>

            <button type="submit" disabled={isPending} className="btn-primary w-full py-3">
              {isPending ? 'Signing in...' : 'Sign in'}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
