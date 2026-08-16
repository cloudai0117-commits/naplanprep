import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import apiClient from '@/api/client'

const statusBadge = (status: string) => {
  if (status === 'PUBLISHED') return 'bg-green-100 text-green-700'
  if (status === 'ARCHIVED') return 'bg-gray-100 text-gray-500'
  return 'bg-yellow-100 text-yellow-700'
}

const tierBadge = (tier: string) => {
  if (tier === 'PREMIUM' || tier === 'FAMILY') return 'bg-blue-100 text-blue-700'
  if (tier === 'STANDARD') return 'bg-indigo-100 text-indigo-700'
  return 'bg-gray-100 text-gray-600'
}

export default function ExamList() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [statusFilter, setStatusFilter] = useState('')

  const { data, isLoading } = useQuery({
    queryKey: ['admin-exams', statusFilter],
    queryFn: () =>
      apiClient.get('/admin/exams', { params: { status: statusFilter || undefined } })
        .then((r) => r.data.data),
  })

  const { mutate: updateStatus } = useMutation({
    mutationFn: ({ id, status }: { id: string; status: string }) =>
      apiClient.patch(`/admin/exams/${id}/status`, { status }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-exams'] }),
  })

  const exams = data?.content || data || []

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="input-field py-1.5 text-xs"
          >
            <option value="">All statuses</option>
            <option value="DRAFT">Draft</option>
            <option value="PUBLISHED">Published</option>
            <option value="ARCHIVED">Archived</option>
          </select>
        </div>
        <Link to="/exams/new" className="btn-primary text-sm py-1.5 px-4">
          + New Exam
        </Link>
      </div>

      {isLoading ? (
        <div className="text-center py-12 text-gray-400">Loading exams...</div>
      ) : exams.length === 0 ? (
        <div className="text-center py-12 text-gray-400">
          No exams found.{' '}
          <Link to="/exams/new" className="text-primary-600 hover:underline">
            Create one
          </Link>
        </div>
      ) : (
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Title</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Year</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Domain</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Tier</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Student Q's (Pool)</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Attempts</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Status</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {exams.map((exam: any) => (
                <tr key={exam.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium text-gray-800">{exam.title}</td>
                  <td className="px-4 py-3 text-gray-600">Year {exam.yearLevel}</td>
                  <td className="px-4 py-3 text-gray-600">{exam.domain?.replace(/_/g, ' ')}</td>
                  <td className="px-4 py-3">
                    <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${tierBadge(exam.packageTier)}`}>
                      {exam.packageTier}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-600">{exam.studentTestLength ?? '—'} <span className="text-xs text-gray-400">({exam.poolQuestionCount ?? '—'} pool)</span></td>
                  <td className="px-4 py-3 text-gray-600">{exam.attemptCount ?? '—'}</td>
                  <td className="px-4 py-3">
                    <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${statusBadge(exam.status)}`}>
                      {exam.status}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center space-x-2 justify-end">
                      <button
                        onClick={() => navigate(`/exams/${exam.id}/questions`)}
                        className="text-xs text-gray-500 hover:text-gray-700"
                      >
                        Questions
                      </button>
                      <button
                        onClick={() => navigate(`/exams/${exam.id}/results`)}
                        className="text-xs text-gray-500 hover:text-gray-700"
                      >
                        Results
                      </button>
                      <button
                        onClick={() => navigate(`/exams/${exam.id}/edit`)}
                        className="text-xs text-primary-600 hover:text-primary-700"
                      >
                        Edit
                      </button>
                      {exam.status === 'DRAFT' && (
                        <button
                          onClick={() => updateStatus({ id: exam.id, status: 'PUBLISHED' })}
                          className="text-xs text-green-600 hover:text-green-700 font-medium"
                        >
                          Publish
                        </button>
                      )}
                      {exam.status === 'PUBLISHED' && (
                        <button
                          onClick={() => updateStatus({ id: exam.id, status: 'ARCHIVED' })}
                          className="text-xs text-gray-500 hover:text-gray-700"
                        >
                          Archive
                        </button>
                      )}
                    </div>
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
