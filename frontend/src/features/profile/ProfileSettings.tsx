import { useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function ProfileSettings() {
  const [currentPassword, setCurrentPassword] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [changeError, setChangeError] = useState<string | null>(null)
  const [changeSuccess, setChangeSuccess] = useState(false)

  const { data: me } = useQuery({
    queryKey: ['me'],
    queryFn: () => apiClient.get('/auth/me').then((r) => r.data.data),
  })

  const { data: currentSub } = useQuery({
    queryKey: ['current-subscription'],
    queryFn: () => apiClient.get('/subscriptions/current').then((r) => r.data.data),
  })

  const { mutate: changePassword, isPending: changePending } = useMutation({
    mutationFn: (data: { currentPassword: string; newPassword: string; confirmNewPassword: string }) =>
      apiClient.post('/auth/change-password', data),
    onSuccess: () => {
      setChangeSuccess(true)
      setChangeError(null)
      setCurrentPassword('')
      setNewPassword('')
      setConfirmPassword('')
    },
    onError: (error: any) => {
      setChangeError(error?.response?.data?.errors?.[0] || 'Failed to change password. Check your current password.')
    },
  })

  const handleChangePassword = (e: React.FormEvent) => {
    e.preventDefault()
    setChangeError(null)
    setChangeSuccess(false)

    if (!currentPassword || !newPassword || !confirmPassword) {
      setChangeError('All fields are required.')
      return
    }
    if (newPassword.length < 8) {
      setChangeError('New password must be at least 8 characters.')
      return
    }
    if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(newPassword)) {
      setChangeError('New password must contain uppercase, lowercase and a number.')
      return
    }
    if (newPassword !== confirmPassword) {
      setChangeError('New passwords do not match.')
      return
    }
    if (newPassword === currentPassword) {
      setChangeError('New password must differ from your current password.')
      return
    }

    changePassword({ currentPassword, newPassword, confirmNewPassword: confirmPassword })
  }

  const validUntil = currentSub?.expiresAt ?? currentSub?.currentPeriodEnd

  return (
    <div className="max-w-xl mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Profile & Settings</h1>

      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Your Profile</h2>
        {me && (
          <div className="space-y-3">
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-500 text-sm">Name</span>
              <span className="text-gray-900 font-medium text-sm">{me.firstName} {me.lastName}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-500 text-sm">Email</span>
              <span className="text-gray-900 font-medium text-sm">{me.email}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-500 text-sm">Role</span>
              <span className="text-gray-900 font-medium text-sm">{me.role}</span>
            </div>
            {me.yearLevel && (
              <div className={`flex justify-between py-2 ${me.school ? 'border-b border-gray-100' : ''}`}>
                <span className="text-gray-500 text-sm">Year Level</span>
                <span className="text-gray-900 font-medium text-sm">Year {me.yearLevel}</span>
              </div>
            )}
            {me.school && (
              <div className="flex justify-between py-2">
                <span className="text-gray-500 text-sm">School</span>
                <span className="text-gray-900 font-medium text-sm">{me.school}</span>
              </div>
            )}
          </div>
        )}
      </div>

      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Subscription</h2>
        {currentSub ? (
          <div className="space-y-3">
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-500 text-sm">Plan</span>
              <span className="text-gray-900 font-medium text-sm">{currentSub.plan?.name}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-500 text-sm">Status</span>
              <span className="badge badge-green text-sm">{currentSub.status}</span>
            </div>
            <div className="flex justify-between py-2">
              <span className="text-gray-500 text-sm">Valid until</span>
              <span className="text-gray-900 font-medium text-sm">
                {validUntil
                  ? new Date(validUntil).toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' })
                  : '—'}
              </span>
            </div>
          </div>
        ) : (
          <div className="text-center py-4">
            <p className="text-gray-500 text-sm mb-3">You're on the Free plan</p>
            <a href="/pricing" className="btn-primary py-2 px-4 text-sm">Upgrade Plan</a>
          </div>
        )}
      </div>

      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Change Password</h2>
        {changeSuccess ? (
          <div className="p-3 bg-green-50 border border-green-200 rounded-lg text-sm text-green-700">
            Password updated successfully. For security, please sign in again on your next session.
          </div>
        ) : (
          <form onSubmit={handleChangePassword} className="space-y-3">
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Current password</label>
              <input
                type="password"
                autoComplete="current-password"
                value={currentPassword}
                onChange={(e) => setCurrentPassword(e.target.value)}
                className="input-field text-sm"
                placeholder="••••••••"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">New password</label>
              <input
                type="password"
                autoComplete="new-password"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                className="input-field text-sm"
                placeholder="Min 8 chars · Upper + lower + number"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-600 mb-1">Confirm new password</label>
              <input
                type="password"
                autoComplete="new-password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="input-field text-sm"
                placeholder="••••••••"
              />
            </div>
            {changeError && (
              <p className="text-red-600 text-sm">{changeError}</p>
            )}
            <button
              type="submit"
              disabled={changePending}
              className="btn-primary w-full py-2 text-sm"
            >
              {changePending ? 'Updating...' : 'Update Password'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
