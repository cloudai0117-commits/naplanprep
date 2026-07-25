import { useState } from 'react'
import { useNavigate, useSearchParams, Link } from 'react-router-dom'
import { useMutation, useQuery } from '@tanstack/react-query'
import apiClient from '@/api/client'
import { useAuthStore } from '@/store/authStore'

const examTypes = [
  { value: 'PRACTICE', label: 'Practice', icon: '📝', desc: 'Targeted practice on specific topics. 20 questions, 30 min.' },
  { value: 'MOCK', label: 'Mock Exam', icon: '🎯', desc: 'Full simulation of the real NAPLAN exam. 40 questions, 65 min.' },
  { value: 'DIAGNOSTIC', label: 'Diagnostic', icon: '🔍', desc: 'Find your strengths and weaknesses. 10 questions, 20 min.' },
]

const domains = [
  { value: '', label: 'All Domains' },
  { value: 'NUMERACY', label: 'Numeracy' },
  { value: 'READING', label: 'Reading' },
  { value: 'WRITING', label: 'Writing' },
  { value: 'SPELLING', label: 'Spelling' },
  { value: 'GRAMMAR_PUNCTUATION', label: 'Grammar & Punctuation' },
]

const TAG_LABELS: Record<string, string> = {
  BASIC: 'Basic',
  ADVANCED: 'Advanced',
  PRO: 'Pro',
}

export default function ExamSelection() {
  const { user } = useAuthStore()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const [examType, setExamType] = useState('PRACTICE')
  const [domain, setDomain] = useState(searchParams.get('domain') || '')

  const yearLevel = user?.yearLevel || 5

  const { data: availableExams, isLoading: examsLoading } = useQuery({
    queryKey: ['available-exams'],
    queryFn: () => apiClient.get('/exams/available').then((r) => r.data.data as any[]),
  })

  const { mutate: startPractice, isPending: practiceStarting, error: practiceError } = useMutation({
    mutationFn: () =>
      apiClient.post('/exams/sessions', { examType, yearLevel, domain: domain || null }),
    onSuccess: (res) => navigate(`/exams/${res.data.data.id}/play`),
  })

  const { mutate: startAdminExam, isPending: adminStarting } = useMutation({
    mutationFn: (examId: string) => apiClient.post(`/exams/${examId}/start`),
    onSuccess: (res) => {
      const sessionId = res.data.data.sessionId || res.data.data.id
      navigate(`/exams/${sessionId}/play`)
    },
  })

  // Group available exams by tag
  const examsByTag: Record<string, any[]> = {}
  if (availableExams) {
    for (const exam of availableExams) {
      const tag = exam.tag || 'BASIC'
      if (!examsByTag[tag]) examsByTag[tag] = []
      examsByTag[tag].push(exam)
    }
  }

  const tagOrder = ['BASIC', 'ADVANCED', 'PRO']

  return (
    <div className="max-w-3xl mx-auto space-y-8">
      {/* ── Practice section ── */}
      <div className="space-y-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Start a Practice Exam</h1>
          <p className="text-gray-500 text-sm mt-1">Year {yearLevel} · Choose type and subject</p>
        </div>

        <div className="card space-y-4">
          <div className="space-y-2">
            {examTypes.map((t) => (
              <label
                key={t.value}
                className={`flex items-start p-3 border rounded-lg cursor-pointer transition-colors ${
                  examType === t.value ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <input type="radio" name="examType" value={t.value} checked={examType === t.value}
                  onChange={(e) => setExamType(e.target.value)} className="sr-only" />
                <span className="text-xl mr-3">{t.icon}</span>
                <div>
                  <div className="font-medium text-gray-900 text-sm">{t.label}</div>
                  <div className="text-xs text-gray-500">{t.desc}</div>
                </div>
              </label>
            ))}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Subject</label>
            <select value={domain} onChange={(e) => setDomain(e.target.value)} className="input-field max-w-xs">
              {domains.map((d) => <option key={d.value} value={d.value}>{d.label}</option>)}
            </select>
          </div>

          {practiceError && (
            <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
              {(practiceError as any)?.response?.data?.errors?.[0] || 'Failed to start exam. Please try again.'}
            </div>
          )}

          <button onClick={() => startPractice()} disabled={practiceStarting}
            className="btn-primary w-full py-2.5">
            {practiceStarting ? 'Starting…' : '🚀 Start Practice'}
          </button>
        </div>
      </div>

      {/* ── Admin exams by tier ── */}
      <div className="space-y-6">
        <h2 className="text-xl font-bold text-gray-900">Mock Exams</h2>

        {examsLoading && <div className="text-gray-500 text-sm">Loading exams…</div>}

        {!examsLoading && availableExams?.length === 0 && (
          <div className="card text-center py-8 text-gray-500 text-sm">No exams available yet.</div>
        )}

        {tagOrder.map((tag) => {
          const exams = examsByTag[tag]
          if (!exams || exams.length === 0) return null
          return (
            <div key={tag}>
              <div className="flex items-center gap-2 mb-3">
                <h3 className="text-base font-semibold text-gray-800">{TAG_LABELS[tag] || tag}</h3>
                {tag !== 'BASIC' && (
                  <span className="text-xs px-2 py-0.5 rounded-full bg-amber-100 text-amber-700 font-medium">
                    {TAG_LABELS[tag]} only
                  </span>
                )}
              </div>
              <div className="space-y-2">
                {exams.map((exam: any) => {
                  const isLocked = exam.availability === 'UPGRADE_REQUIRED'
                  const isCompleted = exam.alreadyAttempted
                  const isAvailable = exam.availability === 'AVAILABLE'
                  return (
                    <div key={exam.id} className={`card flex items-center gap-4 ${isLocked ? 'opacity-60' : ''}`}>
                      <div className="flex-1 min-w-0">
                        <p className="font-medium text-gray-900 text-sm truncate">{exam.title}</p>
                        <p className="text-xs text-gray-500 mt-0.5">
                          Year {exam.yearLevel} · {(exam.domain || '').replace(/_/g, ' ')} · {exam.questionCount} questions · {Math.floor(exam.timeLimitSeconds / 60)} min
                        </p>
                      </div>
                      {isCompleted ? (
                        <Link to={`/exams/${exam.completedSessionId}/results`}
                          className="btn-secondary text-xs py-1.5 px-3 flex-shrink-0">
                          View Results
                        </Link>
                      ) : isLocked ? (
                        <span className="text-xs text-gray-500 flex-shrink-0">🔒 Upgrade</span>
                      ) : isAvailable ? (
                        <button onClick={() => startAdminExam(exam.id)}
                          disabled={adminStarting}
                          className="btn-primary text-xs py-1.5 px-3 flex-shrink-0">
                          Start
                        </button>
                      ) : (
                        <span className="text-xs text-gray-400 flex-shrink-0">{exam.availability}</span>
                      )}
                    </div>
                  )
                })}
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
