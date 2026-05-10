import { useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
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

export default function ExamSelection() {
  const { user } = useAuthStore()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const [examType, setExamType] = useState('PRACTICE')
  const [yearLevel, setYearLevel] = useState(user?.yearLevel || 5)
  const [domain, setDomain] = useState(searchParams.get('domain') || '')

  const { mutate, isPending, error } = useMutation({
    mutationFn: () =>
      apiClient.post('/exams/sessions', {
        examType,
        yearLevel,
        domain: domain || null,
      }),
    onSuccess: (res) => {
      const session = res.data.data
      navigate(`/exams/${session.id}/play`)
    },
  })

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Start an Exam</h1>
        <p className="text-gray-600 text-sm mt-1">Choose your exam type and settings</p>
      </div>

      {/* Exam type */}
      <div className="card">
        <h2 className="text-base font-semibold text-gray-900 mb-3">Exam Type</h2>
        <div className="space-y-2">
          {examTypes.map((t) => (
            <label
              key={t.value}
              className={`flex items-start p-4 border rounded-lg cursor-pointer transition-colors ${
                examType === t.value ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-gray-300'
              }`}
            >
              <input
                type="radio"
                name="examType"
                value={t.value}
                checked={examType === t.value}
                onChange={(e) => setExamType(e.target.value)}
                className="sr-only"
              />
              <span className="text-2xl mr-3">{t.icon}</span>
              <div>
                <div className="font-medium text-gray-900">{t.label}</div>
                <div className="text-sm text-gray-500">{t.desc}</div>
              </div>
            </label>
          ))}
        </div>
      </div>

      {/* Settings */}
      <div className="card">
        <h2 className="text-base font-semibold text-gray-900 mb-4">Settings</h2>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Year Level</label>
            <select
              value={yearLevel}
              onChange={(e) => setYearLevel(Number(e.target.value))}
              className="input-field"
            >
              {[3, 5, 7, 9].map((y) => (
                <option key={y} value={y}>Year {y}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Domain</label>
            <select
              value={domain}
              onChange={(e) => setDomain(e.target.value)}
              className="input-field"
            >
              {domains.map((d) => (
                <option key={d.value} value={d.value}>{d.label}</option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {error && (
        <div className="p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
          {(error as any)?.response?.data?.errors?.[0] || 'Failed to start exam. Please try again.'}
        </div>
      )}

      <button
        onClick={() => mutate()}
        disabled={isPending}
        className="btn-primary w-full py-3 text-base"
      >
        {isPending ? 'Starting exam...' : '🚀 Start Exam'}
      </button>
    </div>
  )
}
