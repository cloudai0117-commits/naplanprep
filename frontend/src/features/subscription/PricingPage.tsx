import { useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import apiClient from '@/api/client'
import { useAuthStore } from '@/store/authStore'

interface Plan {
  id: string
  name: string
  slug: string
  monthlyPrice: number
}

export default function PricingPage() {
  const [checkoutError, setCheckoutError] = useState<string | null>(null)
  const { isAuthenticated } = useAuthStore()
  const navigate = useNavigate()

  const { data: plans, isLoading } = useQuery<Plan[]>({
    queryKey: ['plans'],
    queryFn: () => apiClient.get('/subscriptions/plans').then((r) => r.data.data),
  })

  const { data: currentSub } = useQuery({
    queryKey: ['current-subscription'],
    queryFn: () => apiClient.get('/subscriptions/current').then((r) => r.data.data),
    enabled: isAuthenticated,
  })

  const { mutate: checkout, isPending } = useMutation({
    mutationFn: (planSlug: string) =>
      apiClient.post('/subscriptions/checkout', { planSlug }),
    onSuccess: (res) => {
      setCheckoutError(null)
      const url = res.data.data?.checkoutUrl
      if (url) window.location.href = url
      else setCheckoutError('No checkout URL returned. Please try again.')
    },
    onError: (error: any) => {
      console.error('[Checkout] error:', {
        message: error?.message,
        code: error?.code,
        status: error?.response?.status,
        data: error?.response?.data,
      })
      const backendMsg = error?.response?.data?.errors?.[0] || error?.response?.data?.message
      const networkMsg = !error?.response
        ? `Cannot reach payment server — check network or CORS (${error?.message ?? 'unknown'})`
        : null
      const msg = backendMsg || networkMsg || `Checkout failed (HTTP ${error?.response?.status ?? '?'})`
      setCheckoutError(msg)
    },
  })

  if (isLoading) return <div className="text-gray-500">Loading plans...</div>

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-3xl font-bold text-gray-900">Choose Your Plan</h1>
        <p className="text-gray-600 mt-2">One-time purchase · Valid for 1 year · No subscription</p>
      </div>

      {currentSub && (
        <div className="card bg-blue-50 border border-blue-200">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-semibold text-blue-900">Current Plan: {currentSub.plan?.name}</div>
              <div className="text-blue-700 text-sm">
                Status: {currentSub.status} ·
                Valid until: {
                  (currentSub.expiresAt ?? currentSub.currentPeriodEnd)
                    ? new Date(currentSub.expiresAt ?? currentSub.currentPeriodEnd).toLocaleDateString()
                    : '—'
                }
              </div>
            </div>
          </div>
        </div>
      )}

      {checkoutError && (
        <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm text-center">
          {checkoutError}
          {checkoutError.includes('not configured') && (
            <span className="block mt-1 text-red-500">Stripe payment keys need to be configured. Contact support.</span>
          )}
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {plans?.filter((p) => p.slug !== 'family').map((plan) => {
          const isCurrentPlan = currentSub?.plan?.id === plan.id
          const isPremium = plan.slug === 'pro' || plan.slug === 'premium'

          return (
            <div
              key={plan.id}
              className={`card relative flex flex-col ${isPremium ? 'border-2 border-primary-500 shadow-md' : ''}`}
            >
              {isPremium && (
                <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-primary-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                  MOST POPULAR
                </span>
              )}
              <h3 className="text-xl font-bold text-gray-900">{plan.name}</h3>
              <div className="mt-2 mb-4">
                {plan.monthlyPrice === 0 ? (
                  <span className="text-3xl font-bold text-gray-900">Free</span>
                ) : (
                  <>
                    <span className="text-3xl font-bold text-gray-900">${plan.monthlyPrice.toFixed(2)}</span>
                    <div className="text-xs text-gray-500 mt-1">One-time · Valid 1 year</div>
                  </>
                )}
              </div>

              <ul className="space-y-2 flex-1 mb-6 text-sm text-gray-600">
                {(plan.slug === 'free' || plan.slug === 'basic') && (
                  <>
                    <li className="flex items-start"><span className="text-green-500 mr-2 mt-0.5">✓</span><strong>5 Exams</strong></li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">1 Numeracy</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">1 Reading</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">1 Writing</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">1 Grammar & Punctuation</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">1 Spelling</li>
                  </>
                )}
                {plan.slug === 'advanced' && (
                  <>
                    <li className="flex items-start"><span className="text-green-500 mr-2 mt-0.5">✓</span><strong>30 Exams total</strong></li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">5 FREE + 25 Advanced</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">6 Numeracy</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">6 Reading</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">6 Writing</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">6 Grammar & Punctuation</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">6 Spelling</li>
                  </>
                )}
                {(plan.slug === 'pro' || plan.slug === 'premium') && (
                  <>
                    <li className="flex items-start"><span className="text-green-500 mr-2 mt-0.5">✓</span><strong>80 Exams total</strong></li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">5 FREE + 25 Advanced + 50 Premium</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">16 Numeracy</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">16 Reading</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">16 Writing</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">16 Grammar & Punctuation</li>
                    <li className="flex items-start text-sm text-gray-500 ml-5">16 Spelling</li>
                  </>
                )}
              </ul>

              {isCurrentPlan ? (
                <div className="text-center py-2 px-4 rounded-lg bg-green-50 text-green-700 text-sm font-medium border border-green-200">
                  Current Plan ✓
                </div>
              ) : plan.monthlyPrice === 0 ? (
                <div className="text-center py-2 px-4 rounded-lg bg-gray-50 text-gray-500 text-sm">
                  Free forever
                </div>
              ) : (
                <button
                  onClick={() => {
                    setCheckoutError(null)
                    if (!isAuthenticated) {
                      navigate('/register')
                      return
                    }
                    checkout(plan.slug)
                  }}
                  disabled={isPending}
                  className={`py-2 px-4 rounded-lg font-semibold text-sm transition-colors ${
                    isPremium
                      ? 'bg-primary-600 text-white hover:bg-primary-700'
                      : 'bg-gray-800 text-white hover:bg-gray-900'
                  }`}
                >
                  {isPending ? 'Loading...' : isAuthenticated ? `Get ${plan.name}` : `Sign up — ${plan.name}`}
                </button>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )
}
