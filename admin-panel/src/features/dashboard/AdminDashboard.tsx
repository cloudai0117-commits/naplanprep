import { useQuery } from '@tanstack/react-query'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import apiClient from '@/api/client'

interface DashboardData {
  totalUsers: number
  activeSubscribers: number
  trialUsers: number
  mrr: number
  publishedQuestions: number
  draftQuestions: number
  totalExams: number
}

function MetricCard({ label, value, sub, color }: { label: string; value: string | number; sub?: string; color?: string }) {
  return (
    <div className="card">
      <div className="text-sm font-medium text-gray-500 mb-1">{label}</div>
      <div className={`text-3xl font-bold ${color || 'text-gray-900'}`}>{value}</div>
      {sub && <div className="text-xs text-gray-400 mt-1">{sub}</div>}
    </div>
  )
}

export default function AdminDashboard() {
  const { data: dashboard, isLoading } = useQuery<DashboardData>({
    queryKey: ['admin-dashboard'],
    queryFn: () => apiClient.get('/admin/dashboard').then((r) => r.data.data),
  })

  const { data: subAnalytics } = useQuery({
    queryKey: ['sub-analytics'],
    queryFn: () => apiClient.get('/admin/subscriptions/analytics').then((r) => r.data.data),
  })

  if (isLoading) return <div className="text-gray-500">Loading dashboard...</div>

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard label="Total Users" value={dashboard?.totalUsers || 0} />
        <MetricCard label="Active Subscribers" value={dashboard?.activeSubscribers || 0} color="text-green-600" />
        <MetricCard
          label="MRR"
          value={`$${Number(dashboard?.mrr || 0).toLocaleString('en-AU', { minimumFractionDigits: 0 })}`}
          sub="Monthly Recurring Revenue"
          color="text-primary-600"
        />
        <MetricCard label="Total Exams" value={dashboard?.totalExams || 0} />
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard label="Trial Users" value={dashboard?.trialUsers || 0} />
        <MetricCard label="Published Questions" value={dashboard?.publishedQuestions || 0} color="text-green-600" />
        <MetricCard label="Draft Questions" value={dashboard?.draftQuestions || 0} color="text-yellow-600" />
        {subAnalytics && (
          <MetricCard
            label="Churn Rate"
            value={`${subAnalytics.churnRate}%`}
            color={subAnalytics.churnRate > 10 ? 'text-red-600' : 'text-green-600'}
          />
        )}
      </div>

      {subAnalytics && (
        <div className="card">
          <h2 className="text-base font-semibold text-gray-800 mb-4">Subscription Overview</h2>
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center p-4 bg-gray-50 rounded-lg">
              <div className="text-2xl font-bold text-green-600">{subAnalytics.activeSubscriptions}</div>
              <div className="text-xs text-gray-500 mt-1">Active</div>
            </div>
            <div className="text-center p-4 bg-gray-50 rounded-lg">
              <div className="text-2xl font-bold text-red-500">{subAnalytics.cancelledSubscriptions}</div>
              <div className="text-xs text-gray-500 mt-1">Cancelled</div>
            </div>
            <div className="text-center p-4 bg-gray-50 rounded-lg">
              <div className="text-2xl font-bold text-yellow-600">{subAnalytics.pastDueSubscriptions}</div>
              <div className="text-xs text-gray-500 mt-1">Past Due</div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
