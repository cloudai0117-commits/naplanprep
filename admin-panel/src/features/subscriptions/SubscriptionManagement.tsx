import { useQuery } from '@tanstack/react-query'
import { format } from 'date-fns'
import apiClient from '@/api/client'

export default function SubscriptionManagement() {
  const { data: analytics } = useQuery({
    queryKey: ['sub-analytics'],
    queryFn: () => apiClient.get('/admin/subscriptions/analytics').then((r) => r.data.data),
  })

  const { data: subscriptions, isLoading } = useQuery({
    queryKey: ['admin-subscriptions'],
    queryFn: () => apiClient.get('/subscriptions/plans').then((r) => r.data.data),
  })

  return (
    <div className="space-y-6">
      {analytics && (
        <div className="grid grid-cols-2 lg:grid-cols-5 gap-4">
          {[
            { label: 'MRR', value: `$${Number(analytics.mrr).toFixed(0)}`, color: 'text-primary-600' },
            { label: 'Active', value: analytics.activeSubscriptions, color: 'text-green-600' },
            { label: 'Cancelled', value: analytics.cancelledSubscriptions, color: 'text-red-500' },
            { label: 'Past Due', value: analytics.pastDueSubscriptions, color: 'text-yellow-600' },
            { label: 'Churn Rate', value: `${analytics.churnRate}%`, color: analytics.churnRate > 10 ? 'text-red-600' : 'text-green-600' },
          ].map((m) => (
            <div key={m.label} className="card text-center">
              <div className={`text-2xl font-bold ${m.color}`}>{m.value}</div>
              <div className="text-xs text-gray-500 mt-1">{m.label}</div>
            </div>
          ))}
        </div>
      )}

      <div className="card">
        <h2 className="text-base font-semibold text-gray-800 mb-4">Available Plans</h2>
        {isLoading ? (
          <div className="text-gray-500">Loading...</div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                <th className="table-th">Plan</th>
                <th className="table-th">Monthly</th>
                <th className="table-th">Annual</th>
                <th className="table-th">Stripe Monthly ID</th>
                <th className="table-th">Stripe Annual ID</th>
                <th className="table-th">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {subscriptions?.map((plan: any) => (
                <tr key={plan.id}>
                  <td className="table-td font-medium">{plan.name}</td>
                  <td className="table-td">${plan.monthlyPrice}</td>
                  <td className="table-td">{plan.annualPrice ? `$${plan.annualPrice}` : '—'}</td>
                  <td className="table-td font-mono text-xs text-gray-500 truncate max-w-xs">{plan.stripeMonthlyPriceId || '—'}</td>
                  <td className="table-td font-mono text-xs text-gray-500 truncate max-w-xs">{plan.stripeAnnualPriceId || '—'}</td>
                  <td className="table-td">
                    <span className={`badge ${plan.active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-500'}`}>
                      {plan.active ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
