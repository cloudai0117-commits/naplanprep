import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function ExamResults() {
  const { examId } = useParams<{ examId: string }>()
  const navigate = useNavigate()

  const { data: exam } = useQuery({
    queryKey: ['admin-exam', examId],
    queryFn: () => apiClient.get(`/admin/exams/${examId}`).then((r) => r.data.data),
    enabled: !!examId,
  })

  const { data: results, isLoading } = useQuery({
    queryKey: ['admin-exam-results', examId],
    queryFn: () => apiClient.get(`/admin/exams/${examId}/results`).then((r) => r.data.data),
    enabled: !!examId,
  })

  const sessions: any[] = results?.content || results || []

  const avgScore = sessions.length > 0
    ? Math.round(sessions.reduce((sum: number, s: any) => sum + (s.score || s.percentage || 0), 0) / sessions.length)
    : 0

  return (
    <div className="space-y-4">
      <div className="flex items-center space-x-3 mb-2">
        <button onClick={() => navigate('/exams')} className="text-gray-500 hover:text-gray-700 text-sm">
          ← Exams
        </button>
        <h1 className="text-xl font-semibold text-gray-900">
          {exam?.title || 'Exam'} — Results
        </h1>
      </div>

      <div className="grid grid-cols-3 gap-4">
        <div className="bg-white border border-gray-200 rounded-xl p-4 text-center">
          <div className="text-2xl font-bold text-gray-900">{sessions.length}</div>
          <div className="text-xs text-gray-500 mt-1">Total Attempts</div>
        </div>
        <div className="bg-white border border-gray-200 rounded-xl p-4 text-center">
          <div className="text-2xl font-bold text-gray-900">{avgScore}%</div>
          <div className="text-xs text-gray-500 mt-1">Average Score</div>
        </div>
        <div className="bg-white border border-gray-200 rounded-xl p-4 text-center">
          <div className="text-2xl font-bold text-gray-900">
            {sessions.filter((s: any) => (s.percentage || s.score || 0) >= 70).length}
          </div>
          <div className="text-xs text-gray-500 mt-1">Passed (≥70%)</div>
        </div>
      </div>

      {isLoading ? (
        <div className="text-center py-12 text-gray-400">Loading results...</div>
      ) : sessions.length === 0 ? (
        <div className="text-center py-12 text-gray-400">No attempts yet.</div>
      ) : (
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Student</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Started</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Submitted</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Score</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Band</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {sessions.map((session: any) => {
                const score = session.percentage ?? session.score ?? 0
                const scoreColor = score >= 70 ? 'text-green-600' : score >= 50 ? 'text-yellow-600' : 'text-red-600'
                return (
                  <tr key={session.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">
                      <div className="font-medium text-gray-800">
                        {session.user?.firstName} {session.user?.lastName}
                      </div>
                      <div className="text-xs text-gray-400">{session.user?.email || session.userId}</div>
                    </td>
                    <td className="px-4 py-3 text-gray-600 text-xs">
                      {session.startedAt
                        ? new Date(session.startedAt).toLocaleString('en-AU', { dateStyle: 'short', timeStyle: 'short' })
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-gray-600 text-xs">
                      {session.submittedAt
                        ? new Date(session.submittedAt).toLocaleString('en-AU', { dateStyle: 'short', timeStyle: 'short' })
                        : '—'}
                    </td>
                    <td className="px-4 py-3">
                      <span className={`font-semibold ${scoreColor}`}>{Math.round(score)}%</span>
                    </td>
                    <td className="px-4 py-3 text-gray-700">
                      {session.band || session.result?.band || '—'}
                    </td>
                    <td className="px-4 py-3">
                      <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
                        session.status === 'SUBMITTED'
                          ? 'bg-green-100 text-green-700'
                          : session.status === 'IN_PROGRESS'
                          ? 'bg-yellow-100 text-yellow-700'
                          : 'bg-gray-100 text-gray-500'
                      }`}>
                        {session.status}
                      </span>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
