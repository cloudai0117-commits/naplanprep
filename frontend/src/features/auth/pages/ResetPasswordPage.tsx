import { useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function ResetPasswordPage() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token') || ''
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [validationError, setValidationError] = useState<string | null>(null)

  const { mutate, isPending, isSuccess, error } = useMutation({
    mutationFn: (data: { token: string; newPassword: string; confirmNewPassword: string }) =>
      apiClient.post('/auth/reset-password', data),
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setValidationError(null)

    if (!token) {
      setValidationError('Invalid or missing reset token. Please request a new password reset link.')
      return
    }
    if (newPassword.length < 8) {
      setValidationError('Password must be at least 8 characters.')
      return
    }
    if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(newPassword)) {
      setValidationError('Password must contain uppercase, lowercase and a number.')
      return
    }
    if (newPassword !== confirmPassword) {
      setValidationError('Passwords do not match.')
      return
    }

    mutate({ token, newPassword, confirmNewPassword: confirmPassword })
  }

  const apiError = (error as any)?.response?.data?.errors?.[0] || (error ? 'Reset link is invalid or has expired. Please request a new one.' : null)

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <Link to="/" className="block text-center text-2xl font-bold text-primary-600 mb-6">
          NAPLANPrep
        </Link>
        <h2 className="text-center text-3xl font-bold text-gray-900">Set new password</h2>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="card py-8 px-4 shadow sm:rounded-xl sm:px-10">
          {isSuccess ? (
            <div className="space-y-4 text-center">
              <div className="text-4xl">✅</div>
              <p className="text-sm text-gray-700 font-medium">
                Password reset successfully!
              </p>
              <p className="text-sm text-gray-500">You can now sign in with your new password.</p>
              <Link to="/login" className="btn-primary block w-full py-3 text-center">
                Sign in
              </Link>
            </div>
          ) : (
            <form className="space-y-6" onSubmit={handleSubmit}>
              {!token && (
                <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
                  Invalid reset link. Please{' '}
                  <Link to="/login" className="underline">request a new one</Link>.
                </div>
              )}

              {(validationError || apiError) && (
                <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
                  {validationError || apiError}
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">New password</label>
                <input
                  type="password"
                  autoComplete="new-password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  className="input-field"
                  placeholder="Min 8 chars · Upper + lower + number"
                  disabled={!token}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Confirm new password</label>
                <input
                  type="password"
                  autoComplete="new-password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  className="input-field"
                  placeholder="••••••••"
                  disabled={!token}
                />
              </div>

              <button
                type="submit"
                disabled={isPending || !token}
                className="btn-primary w-full py-3"
              >
                {isPending ? 'Resetting...' : 'Set new password'}
              </button>

              <div className="text-center">
                <Link to="/login" className="text-sm text-gray-500 hover:text-gray-700">
                  ← Back to Sign in
                </Link>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}
