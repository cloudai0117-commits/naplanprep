import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function ExamQuestions() {
  const { examId } = useParams<{ examId: string }>()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [search, setSearch] = useState('')
  const [domainFilter, setDomainFilter] = useState('')
  const [yearFilter, setYearFilter] = useState('')

  const { data: exam } = useQuery({
    queryKey: ['admin-exam', examId],
    queryFn: () => apiClient.get(`/admin/exams/${examId}`).then((r) => r.data.data),
    enabled: !!examId,
  })

  const { data: examQuestions = [], isLoading: loadingExamQ } = useQuery({
    queryKey: ['admin-exam-questions', examId],
    queryFn: () => apiClient.get(`/exams/sessions`).then(() =>
      apiClient.get(`/admin/exams/${examId}`).then((r) => r.data.data?.examQuestions || [])
    ),
    enabled: !!examId,
  })

  const { data: allQuestions = [], isLoading: loadingAll } = useQuery({
    queryKey: ['question-bank', domainFilter, yearFilter],
    queryFn: () =>
      apiClient.get('/content/questions', {
        params: {
          status: 'PUBLISHED',
          domain: domainFilter || undefined,
          yearLevel: yearFilter || undefined,
          size: 100,
        },
      }).then((r) => r.data.data?.content || r.data.data || []),
  })

  const assignedIds = new Set((examQuestions as any[]).map((eq: any) => eq.questionId || eq.question?.id))

  const { mutate: addQuestion } = useMutation({
    mutationFn: (questionId: string) =>
      apiClient.post(`/admin/exams/${examId}/questions`, {
        questions: [{ questionId, order: assignedIds.size + 1 }],
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-exam', examId] })
      queryClient.invalidateQueries({ queryKey: ['admin-exam-questions', examId] })
    },
  })

  const { mutate: removeQuestion } = useMutation({
    mutationFn: (questionId: string) =>
      apiClient.delete(`/admin/exams/${examId}/questions/${questionId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-exam', examId] })
      queryClient.invalidateQueries({ queryKey: ['admin-exam-questions', examId] })
    },
  })

  const filteredQuestions = (allQuestions as any[]).filter((q: any) => {
    if (search && !q.questionText?.toLowerCase().includes(search.toLowerCase())) return false
    return true
  })

  return (
    <div className="space-y-4">
      <div className="flex items-center space-x-3 mb-2">
        <button onClick={() => navigate('/exams')} className="text-gray-500 hover:text-gray-700 text-sm">
          ← Exams
        </button>
        <h1 className="text-xl font-semibold text-gray-900">
          {exam?.title || 'Exam'} — Questions
        </h1>
        <span className="text-sm text-gray-500">({assignedIds.size} assigned)</span>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {/* Assigned questions */}
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <div className="px-4 py-3 border-b border-gray-100 bg-gray-50">
            <h2 className="font-medium text-gray-800 text-sm">Assigned Questions</h2>
          </div>
          {loadingExamQ ? (
            <div className="p-4 text-gray-400 text-sm">Loading...</div>
          ) : assignedIds.size === 0 ? (
            <div className="p-4 text-gray-400 text-sm">No questions assigned yet. Add from the right.</div>
          ) : (
            <ul className="divide-y divide-gray-100">
              {(examQuestions as any[]).map((eq: any, idx: number) => {
                const q = eq.question || eq
                const qId = q.id || eq.questionId
                return (
                  <li key={qId} className="px-4 py-3 flex items-start justify-between">
                    <div>
                      <span className="text-xs text-gray-400 mr-2">#{idx + 1}</span>
                      <span className="text-sm text-gray-800 line-clamp-2">{q.questionText}</span>
                      <div className="text-xs text-gray-400 mt-0.5">
                        {q.domain?.replace(/_/g, ' ')} · {q.topic}
                      </div>
                    </div>
                    <button
                      onClick={() => removeQuestion(qId)}
                      className="ml-3 text-xs text-red-500 hover:text-red-700 flex-shrink-0"
                    >
                      Remove
                    </button>
                  </li>
                )
              })}
            </ul>
          )}
        </div>

        {/* Question bank */}
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <div className="px-4 py-3 border-b border-gray-100 bg-gray-50 space-y-2">
            <h2 className="font-medium text-gray-800 text-sm">Question Bank</h2>
            <div className="flex items-center space-x-2">
              <input
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search..."
                className="input-sm flex-1"
              />
              <select value={domainFilter} onChange={(e) => setDomainFilter(e.target.value)} className="input-field py-1.5 text-xs">
                <option value="">All domains</option>
                {['NUMERACY', 'READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION'].map((d) => (
                  <option key={d} value={d}>{d.replace(/_/g, ' ')}</option>
                ))}
              </select>
              <select value={yearFilter} onChange={(e) => setYearFilter(e.target.value)} className="input-field py-1.5 text-xs">
                <option value="">All years</option>
                {[3, 5, 7, 9].map((y) => <option key={y} value={y}>Year {y}</option>)}
              </select>
            </div>
          </div>
          {loadingAll ? (
            <div className="p-4 text-gray-400 text-sm">Loading...</div>
          ) : (
            <ul className="divide-y divide-gray-100 max-h-96 overflow-y-auto">
              {filteredQuestions.slice(0, 50).map((q: any) => {
                const isAssigned = assignedIds.has(q.id)
                return (
                  <li key={q.id} className={`px-4 py-3 flex items-start justify-between ${isAssigned ? 'opacity-40' : ''}`}>
                    <div>
                      <span className="text-sm text-gray-800 line-clamp-2">{q.questionText}</span>
                      <div className="text-xs text-gray-400 mt-0.5">
                        {q.domain?.replace(/_/g, ' ')} · Year {q.yearLevel} · {q.topic}
                      </div>
                    </div>
                    <button
                      onClick={() => !isAssigned && addQuestion(q.id)}
                      disabled={isAssigned}
                      className={`ml-3 text-xs flex-shrink-0 font-medium ${
                        isAssigned ? 'text-green-500 cursor-default' : 'text-primary-600 hover:text-primary-700'
                      }`}
                    >
                      {isAssigned ? 'Added' : '+ Add'}
                    </button>
                  </li>
                )
              })}
            </ul>
          )}
        </div>
      </div>
    </div>
  )
}
