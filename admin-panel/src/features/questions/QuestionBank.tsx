import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import apiClient from '@/api/client'

interface QuestionForm {
  questionType: string
  yearLevel: number
  domain: string
  topic: string
  difficultyBand: number
  stimulusText?: string
  questionText: string
  correctAnswerValue: string
  option1?: string
  option2?: string
  option3?: string
  option4?: string
  explanation?: string
}

export default function QuestionBank() {
  const [filters, setFilters] = useState({ yearLevel: '', domain: '', status: '' })
  const [page, setPage] = useState(0)
  const [showModal, setShowModal] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const queryClient = useQueryClient()

  const { data, isLoading } = useQuery({
    queryKey: ['admin-questions', filters, page],
    queryFn: () => {
      const params = new URLSearchParams({ page: String(page), size: '20' })
      if (filters.yearLevel) params.append('yearLevel', filters.yearLevel)
      if (filters.domain) params.append('domain', filters.domain)
      if (filters.status) params.append('status', filters.status)
      return apiClient.get(`/content/questions?${params}`).then((r) => r.data.data)
    },
  })

  const { register, handleSubmit, reset, formState: { errors } } = useForm<QuestionForm>({
    defaultValues: { questionType: 'MULTIPLE_CHOICE', yearLevel: 3, domain: 'NUMERACY', difficultyBand: 5 },
  })

  const { mutate: saveQuestion, isPending, error: saveError } = useMutation({
    mutationFn: (form: QuestionForm) => {
      const options = [form.option1, form.option2, form.option3, form.option4].filter(Boolean)
      const body = {
        questionType: form.questionType,
        yearLevel: Number(form.yearLevel),
        domain: form.domain,
        topic: form.topic,
        difficultyBand: Number(form.difficultyBand),
        stimulusText: form.stimulusText || null,
        questionText: form.questionText,
        options: options.length > 0 ? { options } : null,
        correctAnswer: { value: form.correctAnswerValue },
        explanation: form.explanation || null,
      }
      return editingId
        ? apiClient.put(`/content/questions/${editingId}`, body)
        : apiClient.post('/content/questions', body)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-questions'] })
      setShowModal(false)
      setEditingId(null)
      reset()
    },
  })

  const { mutate: updateStatus } = useMutation({
    mutationFn: ({ id, status }: { id: string; status: string }) =>
      apiClient.patch(`/content/questions/${id}/status`, { status }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-questions'] }),
  })

  const questions = data?.content || []

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex space-x-3">
          <select
            value={filters.yearLevel}
            onChange={(e) => setFilters((f) => ({ ...f, yearLevel: e.target.value }))}
            className="input-field w-32"
          >
            <option value="">All Years</option>
            {[3, 5, 7, 9].map((y) => <option key={y} value={y}>Year {y}</option>)}
          </select>
          <select
            value={filters.domain}
            onChange={(e) => setFilters((f) => ({ ...f, domain: e.target.value }))}
            className="input-field w-44"
          >
            <option value="">All Domains</option>
            {['NUMERACY', 'READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION'].map((d) => (
              <option key={d} value={d}>{d.replace('_', ' ')}</option>
            ))}
          </select>
          <select
            value={filters.status}
            onChange={(e) => setFilters((f) => ({ ...f, status: e.target.value }))}
            className="input-field w-36"
          >
            <option value="">All Statuses</option>
            {['DRAFT', 'REVIEW', 'PUBLISHED', 'ARCHIVED'].map((s) => (
              <option key={s} value={s}>{s}</option>
            ))}
          </select>
        </div>
        <button onClick={() => { setShowModal(true); setEditingId(null); reset() }} className="btn-primary">
          + New Question
        </button>
      </div>

      <div className="card p-0 overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="table-th">Question</th>
              <th className="table-th">Year</th>
              <th className="table-th">Domain</th>
              <th className="table-th">Difficulty</th>
              <th className="table-th">Status</th>
              <th className="table-th">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {questions.map((q: any) => (
              <tr key={q.id} className="hover:bg-gray-50">
                <td className="table-td max-w-xs truncate">{q.questionText}</td>
                <td className="table-td">Year {q.yearLevel}</td>
                <td className="table-td text-xs">{q.domain?.replace('_', ' ')}</td>
                <td className="table-td">Band {q.difficultyBand}</td>
                <td className="table-td">
                  <span className={`badge ${
                    q.status === 'PUBLISHED' ? 'bg-green-100 text-green-800' :
                    q.status === 'REVIEW' ? 'bg-yellow-100 text-yellow-800' :
                    q.status === 'DRAFT' ? 'bg-gray-100 text-gray-700' :
                    'bg-red-100 text-red-800'
                  }`}>
                    {q.status}
                  </span>
                </td>
                <td className="table-td">
                  <div className="flex space-x-2 text-xs">
                    {q.status === 'DRAFT' && (
                      <button
                        onClick={() => updateStatus({ id: q.id, status: 'REVIEW' })}
                        className="text-yellow-600 hover:text-yellow-800 font-medium"
                      >
                        Submit
                      </button>
                    )}
                    {q.status === 'REVIEW' && (
                      <>
                        <button
                          onClick={() => updateStatus({ id: q.id, status: 'PUBLISHED' })}
                          className="text-green-600 hover:text-green-800 font-medium"
                        >
                          Approve
                        </button>
                        <button
                          onClick={() => updateStatus({ id: q.id, status: 'DRAFT' })}
                          className="text-red-600 hover:text-red-800 font-medium"
                        >
                          Reject
                        </button>
                      </>
                    )}
                    {q.status === 'PUBLISHED' && (
                      <button
                        onClick={() => updateStatus({ id: q.id, status: 'ARCHIVED' })}
                        className="text-gray-500 hover:text-gray-700 font-medium"
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
        {isLoading && <div className="p-6 text-center text-gray-500">Loading...</div>}
      </div>

      {/* Create/Edit Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl p-6 w-full max-w-2xl max-h-screen overflow-y-auto shadow-xl">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              {editingId ? 'Edit Question' : 'New Question'}
            </h3>
            <form onSubmit={handleSubmit((d) => saveQuestion(d))} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Type</label>
                  <select {...register('questionType', { required: true })} className="input-field">
                    <option value="MULTIPLE_CHOICE">Multiple Choice</option>
                    <option value="SHORT_ANSWER">Short Answer</option>
                    <option value="EXTENDED_WRITING">Extended Writing</option>
                    <option value="DRAG_DROP">Drag & Drop</option>
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Year Level</label>
                  <select {...register('yearLevel', { required: true })} className="input-field">
                    {[3, 5, 7, 9].map((y) => <option key={y} value={y}>Year {y}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Domain</label>
                  <select {...register('domain', { required: true })} className="input-field">
                    {['NUMERACY', 'READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION'].map((d) => (
                      <option key={d} value={d}>{d.replace('_', ' ')}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">Difficulty Band (1-10)</label>
                  <input {...register('difficultyBand', { required: true, min: 1, max: 10, valueAsNumber: true })} type="number" min={1} max={10} className="input-field" />
                  {errors.difficultyBand && <p className="mt-1 text-xs text-red-600">Required, 1–10</p>}
                </div>
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Topic *</label>
                <input {...register('topic', { required: true })} className="input-field" placeholder="e.g. Addition, Reading Comprehension" />
                {errors.topic && <p className="mt-1 text-xs text-red-600">Topic is required</p>}
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Stimulus Text (optional)</label>
                <textarea {...register('stimulusText')} rows={2} className="input-field" placeholder="Passage or stimulus..." />
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Question Text *</label>
                <textarea {...register('questionText', { required: true })} rows={2} className="input-field" placeholder="What is...?" />
                {errors.questionText && <p className="mt-1 text-xs text-red-600">Question text is required</p>}
              </div>
              <div className="grid grid-cols-2 gap-3">
                {[1, 2, 3, 4].map((n) => (
                  <div key={n}>
                    <label className="block text-xs font-medium text-gray-700 mb-1">Option {n}</label>
                    <input {...register(`option${n}` as any)} className="input-field" placeholder={`Option ${n}`} />
                  </div>
                ))}
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Correct Answer *</label>
                <input {...register('correctAnswerValue', { required: true })} className="input-field" placeholder="The correct answer value" />
                {errors.correctAnswerValue && <p className="mt-1 text-xs text-red-600">Correct answer is required</p>}
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">Explanation</label>
                <textarea {...register('explanation')} rows={2} className="input-field" placeholder="Why is this the correct answer?" />
              </div>
              {saveError && (
                <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-xs">
                  {(saveError as any)?.response?.data?.errors?.[0] || (saveError as any)?.message || 'Failed to save question. Please try again.'}
                </div>
              )}
              <div className="flex space-x-3 pt-2">
                <button type="button" onClick={() => setShowModal(false)} className="btn-secondary flex-1">Cancel</button>
                <button type="submit" disabled={isPending} className="btn-primary flex-1">
                  {isPending ? 'Saving...' : 'Save Question'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
