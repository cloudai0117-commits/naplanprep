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
  annualPrice: number
  maxChildren: number | null
  dailyQuestionLimit: number
  annualMockExamLimit: number
  adaptiveLearning: boolean
  parentDashboard: boolean
  detailedAnalytics: boolean
}

export default function PricingPage() {
  const [interval, setInterval] = useState<'monthly' | 'annual'>('monthly')
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
      apiClient.post('/subscriptions/checkout', { planSlug, interval }),
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

  const { mutate: openPortal } = useMutation({
    mutationFn: () => apiClient.post('/subscriptions/portal'),
    onSuccess: (res) => {
      const url = res.data.data?.portalUrl
      if (url) window.location.href = url
    },
    onError: () => {
      setCheckoutError('Unable to open billing portal. Please try again.')
    },
  })

  if (isLoading) return <div className="text-gray-500">Loading plans...</div>

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-3xl font-bold text-gray-900">Choose Your Plan</h1>
        <p className="text-gray-600 mt-2">Start free, upgrade anytime. Cancel anytime.</p>

        <div className="mt-6 inline-flex items-center bg-gray-100 rounded-lg p-1">
          {(['monthly', 'annual'] as const).map((i) => (
            <button
              key={i}
              onClick={() => setInterval(i)}
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                interval === i ? 'bg-white shadow text-gray-900' : 'text-gray-600 hover:text-gray-800'
              }`}
            >
              {i === 'monthly' ? 'Monthly' : 'Annual (save ~15%)'}
            </button>
          ))}
        </div>
      </div>

      {currentSub && (
        <div className="card bg-blue-50 border border-blue-200">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-semibold text-blue-900">Current Plan: {currentSub.plan?.name}</div>
              <div className="text-blue-700 text-sm">
                Status: {currentSub.status} ·
                Renews: {currentSub.currentPeriodEnd ? new Date(currentSub.currentPeriodEnd).toLocaleDateString() : '—'}
              </div>
            </div>
            <button onClick={() => openPortal()} className="btn-secondary text-sm py-1.5">
              Manage Billing
            </button>
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
          const price = interval === 'annual' && plan.annualPrice
            ? (plan.annualPrice / 12).toFixed(2)
            : plan.monthlyPrice.toFixed(2)
          const isCurrentPlan = currentSub?.plan?.id === plan.id
          const isPremium = plan.slug === 'premium'

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
                    <span className="text-3xl font-bold text-gray-900">${price}</span>
                    <span className="text-gray-500">/mo</span>
                    {interval === 'annual' && plan.annualPrice && (
                      <div className="text-xs text-green-600 font-medium">
                        ${plan.annualPrice}/year (billed annually)
                      </div>
                    )}
                  </>
                )}
              </div>

              <ul className="space-y-2 flex-1 mb-6 text-sm text-gray-600">
                <li className="flex items-start">
                  <span className="text-green-500 mr-2 mt-0.5">✓</span>
                  {plan.dailyQuestionLimit === -1 ? 'Unlimited questions/day' : `${plan.dailyQuestionLimit} questions/day`}
                </li>
                <li className="flex items-start">
                  <span className="text-green-500 mr-2 mt-0.5">✓</span>
                  {plan.annualMockExamLimit === -1 ? 'Unlimited mock exams' : `${plan.annualMockExamLimit} mock exams/year`}
                </li>
                {plan.adaptiveLearning && (
                  <li className="flex items-start">
                    <span className="text-green-500 mr-2 mt-0.5">✓</span>
                    Adaptive learning
                  </li>
                )}
                {plan.parentDashboard && (
                  <li className="flex items-start">
                    <span className="text-green-500 mr-2 mt-0.5">✓</span>
                    Parent dashboard
                  </li>
                )}
                {plan.detailedAnalytics && (
                  <li className="flex items-start">
                    <span className="text-green-500 mr-2 mt-0.5">✓</span>
                    Detailed analytics
                  </li>
                )}
                {plan.maxChildren && plan.maxChildren > 1 && (
                  <li className="flex items-start">
                    <span className="text-green-500 mr-2 mt-0.5">✓</span>
                    Up to {plan.maxChildren} children
                  </li>
                )}
                {plan.slug === 'premium' && (
                  <li className="flex items-start text-blue-600 font-medium">
                    <span className="mr-2 mt-0.5">🎁</span>
                    7-day free trial
                  </li>
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
