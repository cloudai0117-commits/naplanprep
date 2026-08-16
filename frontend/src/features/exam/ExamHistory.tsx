import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import { format } from 'date-fns'
import apiClient from '@/api/client'

export default function ExamHistory() {
  const { data, isLoading } = useQuery({
    queryKey: ['exam-history'],
    queryFn: () => apiClient.get('/exams/my-results?size=50').then((r) => r.data.data),
  })

  const sessions = data?.content || []

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Exam History</h1>

      {isLoading && <div className="text-gray-500">Loading...</div>}

      {!isLoading && sessions.length === 0 && (
        <div className="card text-center py-12">
          <div className="text-4xl mb-4">📝</div>
          <h3 className="text-lg font-semibold text-gray-700 mb-2">No exams yet</h3>
          <p className="text-gray-500 text-sm mb-4">Start your first exam to see your history here</p>
          <Link to="/exams" className="btn-primary py-2 px-6">Start an Exam</Link>
        </div>
      )}

      {sessions.length > 0 && (
        <div className="card overflow-hidden p-0">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left p-4 font-semibold text-gray-700">Date</th>
                <th className="text-left p-4 font-semibold text-gray-700">Type</th>
                <th className="text-left p-4 font-semibold text-gray-700">Domain</th>
                <th className="text-left p-4 font-semibold text-gray-700">Year</th>
                <th className="text-left p-4 font-semibold text-gray-700">Status</th>
                <th className="text-right p-4 font-semibold text-gray-700">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {sessions.map((session: any) => (
                <tr key={session.id} data-testid="result-row" className="hover:bg-gray-50">
                  <td className="p-4 text-gray-700">
                    {format(new Date(session.createdAt), 'dd MMM yyyy, h:mm a')}
                  </td>
                  <td className="p-4">
                    <span className="badge badge-blue">{session.examType}</span>
                  </td>
                  <td className="p-4 text-gray-700">{session.domain || 'Mixed'}</td>
                  <td className="p-4 text-gray-700">Year {session.yearLevel}</td>
                  <td className="p-4">
                    <span className={`badge ${
                      session.status === 'SUBMITTED' ? 'badge-green' :
                      session.status === 'IN_PROGRESS' ? 'badge-yellow' : 'badge-gray'
                    }`}>
                      {session.status}
                    </span>
                  </td>
                  <td className="p-4 text-right">
                    {session.status === 'SUBMITTED' || session.status === 'TIMED_OUT' ? (
                      <Link
                        to={`/exams/${session.id}/results`}
                        className="text-primary-600 hover:text-primary-800 font-medium text-xs"
                      >
                        View Results
                      </Link>
                    ) : session.status === 'IN_PROGRESS' ? (
                      <Link
                        to={`/exams/${session.id}/play`}
                        className="text-green-600 hover:text-green-800 font-medium text-xs"
                      >
                        Continue
                      </Link>
                    ) : null}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
