import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { format } from 'date-fns'
import apiClient from '@/api/client'

const STATUS_STYLES: Record<string, string> = {
  ACTIVE: 'bg-green-100 text-green-800',
  TRIALING: 'bg-blue-100 text-blue-800',
  PAST_DUE: 'bg-yellow-100 text-yellow-800',
  CANCELLED: 'bg-red-100 text-red-800',
  UNPAID: 'bg-orange-100 text-orange-800',
}

export default function SubscriptionManagement() {
  const [page, setPage] = useState(0)

  const { data: analytics } = useQuery({
    queryKey: ['sub-analytics'],
    queryFn: () => apiClient.get('/admin/subscriptions/analytics').then((r) => r.data.data),
  })

  const { data: subsPage, isLoading } = useQuery({
    queryKey: ['admin-subscriptions', page],
    queryFn: () =>
      apiClient.get(`/admin/subscriptions?page=${page}&size=20`).then((r) => r.data.data),
  })

  const subscriptions: any[] = subsPage?.content ?? []
  const totalPages: number = subsPage?.totalPages ?? 0
  const totalElements: number = subsPage?.totalElements ?? 0

  return (
    <div className="space-y-6">
      {/* Analytics strip */}
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

      {/* Customer subscriptions table */}
      <div className="card">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-base font-semibold text-gray-800">
            Customer Subscriptions
            {totalElements > 0 && <span className="ml-2 text-sm font-normal text-gray-500">({totalElements} total)</span>}
          </h2>
        </div>

        {isLoading ? (
          <div className="text-gray-500 py-8 text-center">Loading...</div>
        ) : subscriptions.length === 0 ? (
          <div className="text-gray-400 py-8 text-center">No subscriptions yet.</div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="table-th">Customer</th>
                    <th className="table-th">Plan</th>
                    <th className="table-th">Status</th>
                    <th className="table-th">Billing</th>
                    <th className="table-th">Amount</th>
                    <th className="table-th">Renews / Ends</th>
                    <th className="table-th">Started</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {subscriptions.map((sub: any) => {
                    const amount = sub.billingInterval === 'ANNUAL' && sub.annualPrice
                      ? `$${Number(sub.annualPrice).toFixed(2)}/yr`
                      : `$${Number(sub.monthlyPrice).toFixed(2)}/mo`

                    const periodEnd = sub.cancelledAt
                      ? sub.cancelledAt
                      : sub.trialEnd && sub.status === 'TRIALING'
                        ? sub.trialEnd
                        : sub.currentPeriodEnd

                    return (
                      <tr key={sub.id} className="hover:bg-gray-50">
                        <td className="table-td">
                          <div className="font-medium text-gray-900">{sub.userName || '—'}</div>
                          <div className="text-xs text-gray-500">{sub.userEmail || sub.userId}</div>
                        </td>
                        <td className="table-td font-medium capitalize">{sub.planName}</td>
                        <td className="table-td">
                          <span className={`badge ${STATUS_STYLES[sub.status] ?? 'bg-gray-100 text-gray-600'}`}>
                            {sub.status}
                          </span>
                        </td>
                        <td className="table-td text-gray-600 capitalize">
                          {sub.billingInterval?.toLowerCase() ?? '—'}
                        </td>
                        <td className="table-td font-medium">{amount}</td>
                        <td className="table-td text-gray-600">
                          {periodEnd ? format(new Date(periodEnd), 'dd MMM yyyy') : '—'}
                          {sub.status === 'TRIALING' && (
                            <span className="ml-1 text-xs text-blue-600">(trial end)</span>
                          )}
                          {sub.cancelledAt && (
                            <span className="ml-1 text-xs text-red-500">(cancelled)</span>
                          )}
                        </td>
                        <td className="table-td text-gray-500">
                          {sub.createdAt ? format(new Date(sub.createdAt), 'dd MMM yyyy') : '—'}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between mt-4 pt-4 border-t border-gray-100">
                <button
                  onClick={() => setPage((p) => Math.max(0, p - 1))}
                  disabled={page === 0}
                  className="btn-secondary text-sm py-1.5 disabled:opacity-40"
                >
                  Previous
                </button>
                <span className="text-sm text-gray-500">Page {page + 1} of {totalPages}</span>
                <button
                  onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
                  disabled={page >= totalPages - 1}
                  className="btn-secondary text-sm py-1.5 disabled:opacity-40"
                >
                  Next
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
