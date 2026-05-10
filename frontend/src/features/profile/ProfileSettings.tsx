import { useQuery, useMutation } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import apiClient from '@/api/client'

export default function ProfileSettings() {
  const { data: me } = useQuery({
    queryKey: ['me'],
    queryFn: () => apiClient.get('/auth/me').then((r) => r.data.data),
  })

  const { data: currentSub } = useQuery({
    queryKey: ['current-subscription'],
    queryFn: () => apiClient.get('/subscriptions/current').then((r) => r.data.data),
  })

  const { mutate: openPortal } = useMutation({
    mutationFn: () => apiClient.post('/subscriptions/portal'),
    onSuccess: (res) => {
      window.open(res.data.data.portalUrl, '_blank')
    },
  })

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
              <div className="flex justify-between py-2">
                <span className="text-gray-500 text-sm">Year Level</span>
                <span className="text-gray-900 font-medium text-sm">Year {me.yearLevel}</span>
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
              <span className="text-gray-500 text-sm">Next billing</span>
              <span className="text-gray-900 font-medium text-sm">
                {currentSub.currentPeriodEnd
                  ? new Date(currentSub.currentPeriodEnd).toLocaleDateString('en-AU')
                  : '—'}
              </span>
            </div>
            <button onClick={() => openPortal()} className="btn-secondary w-full mt-2">
              Manage Billing & Subscription
            </button>
          </div>
        ) : (
          <div className="text-center py-4">
            <p className="text-gray-500 text-sm mb-3">You're on the Free plan</p>
            <a href="/pricing" className="btn-primary py-2 px-4 text-sm">Upgrade Plan</a>
          </div>
        )}
      </div>
    </div>
  )
}
