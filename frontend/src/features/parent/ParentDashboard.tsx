import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import apiClient from '@/api/client'

export default function ParentDashboard() {
  const [selectedChildId, setSelectedChildId] = useState<string | null>(null)

  const { data: children } = useQuery({
    queryKey: ['children'],
    queryFn: () => apiClient.get('/auth/me').then((r) => r.data.data),
  })

  const { data: childProgress, isLoading } = useQuery({
    queryKey: ['child-progress', selectedChildId],
    queryFn: () =>
      apiClient.get(`/progress/children/${selectedChildId}`).then((r) => r.data.data),
    enabled: !!selectedChildId,
  })

  const domainData = childProgress?.domainScores
    ? Object.entries(childProgress.domainScores).map(([domain, score]) => ({
        domain: domain.replace('_', ' '),
        score: score as number,
      }))
    : []

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold text-gray-900">Parent Dashboard</h1>
      </div>

      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Select Child</h2>
        <p className="text-gray-600 text-sm">
          To add children to your account, have them register and then contact support with both email addresses.
          Parent-child linking via invitation will be available soon.
        </p>

        {selectedChildId && childProgress && (
          <div className="mt-4 space-y-4">
            <div className="grid grid-cols-3 gap-4">
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <div className="text-2xl font-bold text-gray-900">{childProgress.totalExams}</div>
                <div className="text-xs text-gray-500 mt-1">Total Exams</div>
              </div>
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <div className="text-2xl font-bold text-primary-600">{childProgress.averageScore}%</div>
                <div className="text-xs text-gray-500 mt-1">Avg Score</div>
              </div>
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <div className="text-2xl font-bold text-green-600">Band {childProgress.lastNaplanBand || '—'}</div>
                <div className="text-xs text-gray-500 mt-1">Last Band</div>
              </div>
            </div>

            {domainData.length > 0 && (
              <div>
                <h3 className="font-semibold text-gray-800 mb-2">Domain Performance</h3>
                <ResponsiveContainer width="100%" height={180}>
                  <BarChart data={domainData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                    <XAxis dataKey="domain" tick={{ fontSize: 10 }} />
                    <YAxis domain={[0, 100]} tick={{ fontSize: 10 }} />
                    <Tooltip formatter={(v) => [`${v}%`, 'Score']} />
                    <Bar dataKey="score" fill="#3b82f6" radius={4} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}
