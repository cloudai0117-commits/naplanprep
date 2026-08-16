import { useState, useEffect } from 'react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from 'recharts'
import apiClient from '@/api/client'
import { useAuthStore } from '@/store/authStore'

const domains = ['NUMERACY', 'READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION']
const domainColors: Record<string, string> = {
  NUMERACY: '#3b82f6',
  READING: '#10b981',
  WRITING: '#f59e0b',
  SPELLING: '#8b5cf6',
  GRAMMAR_PUNCTUATION: '#ef4444',
}

const domainLabel = (d: string) => d.replace(/_/g, ' ')

const tagBadgeClass = (tag: string) => {
  if (tag === 'ADVANCED') return 'badge-green'
  if (tag === 'PREMIUM') return 'badge-blue'
  return 'badge-gray'
}

export default function Dashboard() {
  const { user } = useAuthStore()
  const navigate = useNavigate()
  const location = useLocation()
  const queryClient = useQueryClient()
  const [checkoutSuccess, setCheckoutSuccess] = useState(false)
  const [isNewUser, setIsNewUser] = useState(false)

  useEffect(() => {
    const params = new URLSearchParams(location.search)
    if (params.get('new') === '1') {
      setIsNewUser(true)
      navigate('/dashboard', { replace: true })
      return
    }
    if (params.get('checkout') === 'success') {
      setCheckoutSuccess(true)
      navigate('/dashboard', { replace: true })

      const sessionId = params.get('session_id')
      const invalidateAll = () => {
        queryClient.invalidateQueries({ queryKey: ['current-subscription'] })
        queryClient.invalidateQueries({ queryKey: ['available-exams'] })
        queryClient.invalidateQueries({ queryKey: ['progress-overview'] })
      }

      // Proactively sync the subscription from Stripe so the plan badge updates
      // immediately — no need to wait for the async webhook to arrive.
      if (sessionId) {
        apiClient.post('/subscriptions/verify-checkout', { sessionId })
          .then(invalidateAll)
          .catch(invalidateAll) // fall back to cache invalidation even if sync fails
      } else {
        invalidateAll()
      }

      // Also poll for up to 10s in case the backend sync lags or the session_id
      // was not present (older checkout sessions without the param).
      let attempt = 0
      const timer = setInterval(() => {
        invalidateAll()
        if (++attempt >= 5) clearInterval(timer)
      }, 2000)
      return () => clearInterval(timer)
    }
  }, [location.search, navigate, queryClient])

  const { data: overview, isLoading } = useQuery({
    queryKey: ['progress-overview'],
    queryFn: () => apiClient.get('/progress/overview').then((r) => r.data.data),
  })

  const { data: subscription } = useQuery({
    queryKey: ['current-subscription'],
    queryFn: () => apiClient.get('/subscriptions/current').then((r) => r.data.data),
  })

  const { data: recommendations } = useQuery({
    queryKey: ['recommendations'],
    queryFn: () => apiClient.get('/progress/recommendations').then((r) => r.data.data),
  })

  const { data: availableExams } = useQuery({
    queryKey: ['available-exams'],
    queryFn: () => apiClient.get('/exams/available').then((r) => r.data.data),
  })

  const trendData = overview?.recentTrend || []
  const domainScores = overview?.domainScores || {}

  const domainChartData = Object.entries(domainScores).map(([domain, score]) => ({
    domain: domain.replace('_', ' '),
    score: score as number,
    fill: domainColors[domain] || '#6b7280',
  }))

  return (
    <div className="space-y-6">
      {checkoutSuccess && (
        <div
          data-testid="checkout-success-banner"
          className="flex items-center justify-between p-4 bg-green-50 border border-green-200 rounded-lg text-green-800"
        >
          <span className="font-medium">Payment successful! Your new plan is now active.</span>
          <button
            onClick={() => setCheckoutSuccess(false)}
            className="ml-4 text-green-600 hover:text-green-800 font-bold text-lg leading-none"
            aria-label="Dismiss"
          >
            &times;
          </button>
        </div>
      )}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            {isNewUser
              ? `Welcome to NAPLANPrep, ${user?.firstName}!`
              : `Welcome back, ${user?.firstName}!`}
          </h1>
          <p className="text-gray-600 text-sm mt-1">
            {isNewUser
              ? 'Your account is ready. Start with a free exam below.'
              : `${user?.yearLevel ? `Year ${user.yearLevel} · ` : ''}Ready to practice?`}
          </p>
        </div>
        {subscription && (
          <span className={`badge ${
            subscription.plan?.slug === 'pro' || subscription.plan?.slug === 'premium'
              ? 'badge-blue'
              : subscription.plan?.slug === 'advanced'
              ? 'badge-green'
              : 'badge-gray'
          }`}>
            {subscription.plan?.name || 'Free'} Plan
          </span>
        )}
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Total Exams', value: overview?.totalExams || 0, icon: '📝' },
          { label: 'Avg Score', value: `${overview?.averageScore || 0}%`, icon: '📊' },
          { label: 'NAPLAN Band', value: overview?.lastNaplanBand != null ? `Band ${overview.lastNaplanBand}` : '—', icon: '🎯' },
          { label: 'Streak', value: `${trendData.length > 0 ? trendData.length : 0} exams`, icon: '🔥' },
        ].map((stat) => (
          <div key={stat.label} className="card text-center">
            <div className="text-2xl mb-1">{stat.icon}</div>
            <div className="text-2xl font-bold text-gray-900">{stat.value}</div>
            <div className="text-xs text-gray-500 mt-1">{stat.label}</div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Score trend */}
        {trendData.length > 0 && (
          <div className="card">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Score Trend</h2>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={trendData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis dataKey="date" tick={{ fontSize: 10 }} tickFormatter={(v) => v.split('T')[0]} />
                <YAxis domain={[0, 100]} tick={{ fontSize: 10 }} />
                <Tooltip formatter={(v) => [`${v}%`, 'Score']} />
                <Line type="monotone" dataKey="score" stroke="#3b82f6" strokeWidth={2} dot={{ r: 4 }} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}

        {/* Domain breakdown */}
        {domainChartData.length > 0 && (
          <div className="card">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Performance by Domain</h2>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={domainChartData} layout="vertical">
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis type="number" domain={[0, 100]} tick={{ fontSize: 10 }} />
                <YAxis type="category" dataKey="domain" tick={{ fontSize: 10 }} width={120} />
                <Tooltip formatter={(v) => [`${v}%`, 'Score']} />
                <Bar dataKey="score" radius={4} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      {/* Quick start */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Quick Start Practice</h2>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
          {domains.map((domain) => (
            <Link
              key={domain}
              to={`/exams?domain=${domain}`}
              className="flex flex-col items-center p-3 border border-gray-200 rounded-lg hover:border-primary-300 hover:bg-primary-50 transition-colors text-center"
            >
              <div className="w-3 h-3 rounded-full mb-2" style={{ background: domainColors[domain] }} />
              <span className="text-xs font-medium text-gray-700">
                {domain.replace('_', ' ')}
              </span>
            </Link>
          ))}
        </div>
      </div>

      {/* Recommendations */}
      {recommendations && recommendations.length > 0 && (
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Focus Areas</h2>
          <div className="space-y-3">
            {recommendations.slice(0, 3).map((rec: any) => (
              <div key={rec.domain} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <span className="font-medium text-gray-800">{rec.domain.replace('_', ' ')}</span>
                  <span className="ml-2 text-sm text-gray-500">{rec.score}% avg score</span>
                </div>
                <div className="flex items-center space-x-3">
                  <span className={`badge ${
                    rec.priority === 'HIGH' ? 'badge-red' : rec.priority === 'MEDIUM' ? 'badge-yellow' : 'badge-green'
                  }`}>
                    {rec.priority}
                  </span>
                  <Link
                    to={`/exams?domain=${rec.domain}`}
                    className="btn-primary text-xs py-1 px-3"
                  >
                    Practice
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Available Exams — grouped by tag */}
      {availableExams && availableExams.length > 0 && (
        <div className="space-y-4">
          {(['FREE', 'ADVANCED', 'PREMIUM'] as const).map((tag) => {
            const tagExams = availableExams.filter((e: any) => e.packageType === tag)
            if (tagExams.length === 0) return null
            const readyCount = tagExams.filter((e: any) => e.availability === 'AVAILABLE').length
            const sectionLocked = tagExams.every((e: any) => e.availability === 'UPGRADE_REQUIRED')
            return (
              <div key={tag} className="card">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-2">
                    <span className={`badge ${tagBadgeClass(tag)}`}>{tag}</span>
                    <h2 className="text-lg font-semibold text-gray-900">Exams</h2>
                    {sectionLocked && (
                      <span className="text-xs text-yellow-600 font-medium flex items-center gap-1">
                        <span>🔒</span> Upgrade required
                      </span>
                    )}
                  </div>
                  <span className="text-xs text-gray-500">{readyCount} ready to take</span>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                  {tagExams.map((exam: any) => {
                    const isAvailable = exam.availability === 'AVAILABLE'
                    const isCompleted = exam.alreadyAttempted
                    const isLocked = exam.availability === 'UPGRADE_REQUIRED'
                    return (
                      <div
                        key={exam.id}
                        data-testid={isAvailable && !isCompleted ? 'available-exam-card' : 'exam-card'}
                        data-exam-id={exam.id}
                        className={`border rounded-lg p-4 transition-colors ${
                          isCompleted
                            ? 'border-green-200 bg-green-50'
                            : isAvailable
                            ? 'border-gray-200 hover:border-primary-300 hover:bg-primary-50 cursor-pointer'
                            : 'border-gray-200 bg-gray-50 opacity-70'
                        }`}
                        onClick={() => isAvailable || isCompleted ? navigate(`/exams/${exam.id}`) : undefined}
                      >
                        <div className="flex items-start justify-between mb-2">
                          <h3 className="font-medium text-gray-800 text-sm leading-tight">{exam.title}</h3>
                          <span className={`badge text-xs ml-2 flex-shrink-0 ${tagBadgeClass(exam.packageType)}`}>
                            {exam.packageType}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500 mb-3">
                          Year {exam.yearLevel} · {domainLabel(exam.domain)} · {exam.studentTestLength}Q
                        </p>
                        <div className="flex items-center justify-between">
                          <span className="text-xs text-gray-500">
                            {Math.floor(exam.timeLimitSeconds / 60)}min
                          </span>
                          {isCompleted ? (
                            <Link
                              to={`/exams/${exam.completedSessionId}/results`}
                              onClick={(e) => e.stopPropagation()}
                              className="text-xs text-primary-600 hover:text-primary-800 font-medium"
                            >
                              View Results →
                            </Link>
                          ) : isLocked ? (
                            <span data-testid="upgrade-prompt" className="text-xs text-yellow-600 font-medium flex items-center gap-1">
                              <span data-testid="lock-icon">🔒</span> Upgrade
                            </span>
                          ) : exam.availability === 'UPCOMING' ? (
                            <span className="text-xs text-blue-600 font-medium">Coming soon</span>
                          ) : exam.availability === 'EXPIRED' ? (
                            <span className="text-xs text-gray-500 font-medium">Expired</span>
                          ) : (
                            <span className="text-xs text-primary-600 font-medium">Start →</span>
                          )}
                        </div>
                      </div>
                    )
                  })}
                </div>
              </div>
            )
          })}
        </div>
      )}

      {isLoading && (
        <div className="text-center py-12 text-gray-500">Loading your progress...</div>
      )}
    </div>
  )
}
