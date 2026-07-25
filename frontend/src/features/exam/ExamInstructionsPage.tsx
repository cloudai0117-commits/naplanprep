import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function ExamInstructionsPage() {
  const { examId } = useParams<{ examId: string }>()
  const navigate = useNavigate()

  const { data: exams, isLoading } = useQuery({
    queryKey: ['available-exams'],
    queryFn: () => apiClient.get('/exams/available').then((r) => r.data.data),
  })

  const exam = exams?.find((e: any) => e.id === examId)

  const [startError, setStartError] = useState<string | null>(null)

  const { mutate: startExam, isPending } = useMutation({
    mutationFn: () => apiClient.post(`/exams/${examId}/start`),
    onSuccess: (res) => {
      const sessionId = res.data.data?.sessionId
      if (sessionId) navigate(`/exams/${sessionId}/play`)
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.errors?.[0] || err?.message || 'Failed to start exam'
      setStartError(msg)
    },
  })

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-96">
        <div className="text-gray-500">Loading exam details...</div>
      </div>
    )
  }

  if (!exam) {
    return (
      <div className="text-center py-20">
        <h2 className="text-xl font-semibold text-gray-800">Exam not found</h2>
        <button onClick={() => navigate('/dashboard')} className="btn-secondary mt-4">
          Back to Dashboard
        </button>
      </div>
    )
  }

  const formatTime = (seconds: number) => {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    if (h > 0) return `${h}h ${m}m`
    return `${m} minutes`
  }

  const domainLabel = (d: string) => d.replace(/_/g, ' ')

  const isUnavailable = exam.availability === 'UPGRADE_REQUIRED' ||
    exam.availability === 'UPCOMING' ||
    exam.availability === 'EXPIRED'

  return (
    <div className="max-w-2xl mx-auto py-8 px-4">
      <button
        onClick={() => navigate('/dashboard')}
        className="text-gray-500 hover:text-gray-700 text-sm mb-6 flex items-center space-x-1"
      >
        <span>←</span>
        <span>Back to Dashboard</span>
      </button>

      <div className="card space-y-6">
        <div>
          <div className="flex items-start justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">{exam.title}</h1>
              <p className="text-gray-500 text-sm mt-1">
                Year {exam.yearLevel} · {domainLabel(exam.domain)}
              </p>
            </div>
            {exam.availability === 'UPGRADE_REQUIRED' && (
              <span className="badge badge-yellow">Upgrade Required</span>
            )}
            {exam.alreadyAttempted && (
              <span className="badge badge-green">Completed</span>
            )}
          </div>
          {exam.description && (
            <p className="text-gray-600 mt-3 text-sm leading-relaxed">{exam.description}</p>
          )}
        </div>

        <div className="grid grid-cols-3 gap-4 py-4 border-y border-gray-100">
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900">{exam.questionCount}</div>
            <div className="text-xs text-gray-500 mt-1">Questions</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900">{formatTime(exam.timeLimitSeconds)}</div>
            <div className="text-xs text-gray-500 mt-1">Time Limit</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900">{exam.tag}</div>
            <div className="text-xs text-gray-500 mt-1">Required Tier</div>
          </div>
        </div>

        <div>
          <h2 className="font-semibold text-gray-800 mb-3">Before you start</h2>
          <ul className="space-y-2 text-sm text-gray-600">
            <li className="flex items-start space-x-2">
              <span className="text-primary-500 mt-0.5">•</span>
              <span>You have <strong>{formatTime(exam.timeLimitSeconds)}</strong> to complete this exam. The timer starts immediately.</span>
            </li>
            <li className="flex items-start space-x-2">
              <span className="text-primary-500 mt-0.5">•</span>
              <span>You can flag questions for review and navigate back to them using the sidebar.</span>
            </li>
            <li className="flex items-start space-x-2">
              <span className="text-primary-500 mt-0.5">•</span>
              <span>Your answers are saved automatically as you go.</span>
            </li>
            <li className="flex items-start space-x-2">
              <span className="text-red-500 mt-0.5">•</span>
              <span>You can only attempt this exam <strong>once</strong>. Make sure you are ready before starting.</span>
            </li>
          </ul>
        </div>

        {exam.alreadyAttempted ? (
          <div className="space-y-3">
            <div className="p-3 bg-green-50 border border-green-200 rounded-lg text-sm text-green-700">
              You have already completed this exam.
            </div>
            {exam.completedSessionId && (
              <button
                onClick={() => navigate(`/exams/${examId}/results/${exam.completedSessionId}`)}
                className="btn-primary w-full"
              >
                View My Results
              </button>
            )}
          </div>
        ) : exam.availability === 'UPGRADE_REQUIRED' ? (
          <div className="space-y-3">
            <div className="p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-sm text-yellow-700">
              This exam requires a <strong>{exam.tag}</strong> subscription.
            </div>
            <button
              onClick={() => navigate('/pricing')}
              className="btn-primary w-full"
            >
              Upgrade to Access
            </button>
          </div>
        ) : exam.availability === 'UPCOMING' ? (
          <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg text-sm text-blue-700">
            This exam is not yet available.
          </div>
        ) : exam.availability === 'EXPIRED' ? (
          <div className="p-3 bg-gray-50 border border-gray-200 rounded-lg text-sm text-gray-600">
            This exam is no longer available.
          </div>
        ) : (
          <div className="space-y-3">
            {startError && (
              <div className="p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-700">
                {startError}
              </div>
            )}
            <button
              onClick={() => { setStartError(null); startExam() }}
              disabled={isPending}
              className="btn-primary w-full py-3 text-base"
            >
              {isPending ? 'Starting...' : 'Start Exam'}
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
