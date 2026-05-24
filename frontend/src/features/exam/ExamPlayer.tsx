import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'

function useTimer(expiresAt: string | undefined) {
  const [remaining, setRemaining] = useState(0)

  useEffect(() => {
    if (!expiresAt) return
    const tick = () => {
      const diff = Math.max(0, new Date(expiresAt).getTime() - Date.now())
      setRemaining(Math.floor(diff / 1000))
    }
    tick()
    const interval = setInterval(tick, 1000)
    return () => clearInterval(interval)
  }, [expiresAt])

  const minutes = Math.floor(remaining / 60)
  const seconds = remaining % 60
  return { remaining, label: `${minutes}:${seconds.toString().padStart(2, '0')}` }
}

export default function ExamPlayer() {
  const { sessionId } = useParams<{ sessionId: string }>()
  const navigate = useNavigate()
  const [currentIdx, setCurrentIdx] = useState(0)
  const [answers, setAnswers] = useState<Record<string, string>>({})
  const [flagged, setFlagged] = useState<Record<string, boolean>>({})
  const [showSubmitModal, setShowSubmitModal] = useState(false)

  const { data: session, isLoading: sessionLoading } = useQuery({
    queryKey: ['exam-session', sessionId],
    queryFn: () => apiClient.get(`/exams/sessions/${sessionId}`).then((r) => r.data.data),
    refetchInterval: 30000,
  })

  const timer = useTimer(session?.expiresAt)

  const { data: questions = [], isLoading: questionsLoading } = useQuery({
    queryKey: ['session-questions', sessionId],
    queryFn: () => apiClient.get(`/exams/sessions/${sessionId}/questions`).then((r) => r.data.data),
    enabled: !!sessionId,
  })

  const currentQuestion = questions[currentIdx] || null
  const currentQuestionId: string = currentQuestion?.id || ''

  const { mutate: submitAnswer } = useMutation({
    mutationFn: ({ questionId, answer }: { questionId: string; answer: string }) =>
      apiClient.post(`/exams/sessions/${sessionId}/answer`, {
        questionId,
        answer: { value: answer },
        flagged: flagged[questionId] || false,
      }),
  })

  const { mutate: submitExam, isPending: submitting } = useMutation({
    mutationFn: () => apiClient.post(`/exams/sessions/${sessionId}/submit`),
    onSuccess: (res) => {
      const examId = res.data.data?.examId
      if (examId) {
        navigate(`/exams/${examId}/results/${sessionId}`)
      } else {
        navigate(`/exams/${sessionId}/results`)
      }
    },
  })

  const handleAnswer = (questionId: string, answer: string) => {
    setAnswers((prev) => ({ ...prev, [questionId]: answer }))
    submitAnswer({ questionId, answer })
  }

  const handleFlag = (questionId: string) => {
    setFlagged((prev) => ({ ...prev, [questionId]: !prev[questionId] }))
  }

  useEffect(() => {
    if (timer.remaining === 0 && session?.status === 'IN_PROGRESS') {
      submitExam()
    }
  }, [timer.remaining, session?.status, submitExam])

  if (sessionLoading || questionsLoading) {
    return (
      <div className="flex items-center justify-center min-h-96">
        <div className="text-gray-500">Loading exam...</div>
      </div>
    )
  }

  if (!session || session.status !== 'IN_PROGRESS') {
    return (
      <div className="text-center py-20">
        <h2 className="text-xl font-semibold text-gray-800">Exam ended</h2>
        <button onClick={() => navigate(`/exams/${sessionId}/results`)} className="btn-primary mt-4">
          View Results
        </button>
      </div>
    )
  }

  const answeredCount = Object.keys(answers).length
  const progress = questions.length > 0 ? (answeredCount / questions.length) * 100 : 0

  return (
    <div className="fixed inset-0 bg-gray-50 flex flex-col">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 px-4 py-3 flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <div>
            {session?.examTitle && (
              <div className="text-xs text-gray-500 font-medium">{session.examTitle}</div>
            )}
            <span className="font-semibold text-gray-800">
              Question {currentIdx + 1} of {questions.length}
            </span>
          </div>
          <div className="hidden md:flex items-center text-sm text-gray-600">
            <span className="w-24 bg-gray-200 rounded-full h-2 mr-2">
              <div
                className="bg-primary-500 h-2 rounded-full transition-all"
                style={{ width: `${progress}%` }}
              />
            </span>
            {answeredCount}/{questions.length} answered
          </div>
        </div>
        <div className={`font-mono text-lg font-bold ${timer.remaining < 300 ? 'text-red-600' : 'text-gray-800'}`}>
          ⏱ {timer.label}
        </div>
        <button
          onClick={() => setShowSubmitModal(true)}
          className="btn-primary py-1.5 px-4 text-sm"
        >
          Submit Exam
        </button>
      </div>

      <div className="flex flex-1 overflow-hidden">
        {/* Question area */}
        <div className="flex-1 overflow-y-auto p-6">
          {currentQuestion ? (
            <div className="max-w-2xl mx-auto space-y-6">
              {currentQuestion.stimulusText && (
                <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg text-gray-700 text-sm leading-relaxed">
                  {currentQuestion.stimulusText}
                </div>
              )}
              <div>
                <div className="flex items-start justify-between mb-4">
                  <h2 className="text-lg font-medium text-gray-900 leading-relaxed">
                    {currentQuestion.questionText}
                  </h2>
                  <button
                    onClick={() => handleFlag(currentQuestionId)}
                    className={`ml-4 p-2 rounded ${flagged[currentQuestionId] ? 'text-orange-500' : 'text-gray-400'} hover:text-orange-500`}
                    title="Flag for review"
                  >
                    🚩
                  </button>
                </div>

                {currentQuestion.options?.options && (
                  <div className="space-y-2">
                    {currentQuestion.options.options.map((opt: string) => (
                      <label
                        key={opt}
                        className={`flex items-center p-4 border rounded-lg cursor-pointer transition-colors ${
                          answers[currentQuestionId] === opt
                            ? 'border-primary-500 bg-primary-50'
                            : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                        }`}
                      >
                        <input
                          type="radio"
                          name={`q-${currentQuestionId}`}
                          value={opt}
                          checked={answers[currentQuestionId] === opt}
                          onChange={() => handleAnswer(currentQuestionId, opt)}
                          className="sr-only"
                        />
                        <div className={`w-4 h-4 rounded-full border-2 mr-3 flex-shrink-0 ${
                          answers[currentQuestionId] === opt
                            ? 'border-primary-500 bg-primary-500'
                            : 'border-gray-400'
                        }`} />
                        <span className="text-gray-800">{opt}</span>
                      </label>
                    ))}
                  </div>
                )}
              </div>
            </div>
          ) : (
            <div className="flex items-center justify-center h-64 text-gray-500">
              Loading question...
            </div>
          )}
        </div>

        {/* Question nav sidebar */}
        <div className="w-48 border-l border-gray-200 bg-white p-4 overflow-y-auto hidden lg:block">
          <div className="text-xs font-semibold text-gray-500 uppercase mb-3">Questions</div>
          <div className="grid grid-cols-4 gap-1.5">
            {questions.map((q: any, idx: number) => (
              <button
                key={q.id}
                onClick={() => setCurrentIdx(idx)}
                className={`w-9 h-9 rounded text-xs font-medium transition-colors ${
                  idx === currentIdx
                    ? 'bg-primary-600 text-white'
                    : flagged[q.id]
                    ? 'bg-orange-100 text-orange-700 border border-orange-300'
                    : answers[q.id]
                    ? 'bg-green-100 text-green-700 border border-green-300'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {idx + 1}
              </button>
            ))}
          </div>
          <div className="mt-4 space-y-1 text-xs text-gray-500">
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 rounded bg-green-100 border border-green-300" />
              <span>Answered</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 rounded bg-orange-100 border border-orange-300" />
              <span>Flagged</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 rounded bg-gray-100" />
              <span>Not answered</span>
            </div>
          </div>
        </div>
      </div>

      {/* Footer nav */}
      <div className="bg-white border-t border-gray-200 px-6 py-3 flex justify-between">
        <button
          onClick={() => setCurrentIdx(Math.max(0, currentIdx - 1))}
          disabled={currentIdx === 0}
          className="btn-secondary py-2 px-4 text-sm"
        >
          ← Previous
        </button>
        <button
          onClick={() => setCurrentIdx(Math.min(questions.length - 1, currentIdx + 1))}
          disabled={currentIdx === questions.length - 1}
          className="btn-primary py-2 px-4 text-sm"
        >
          Next →
        </button>
      </div>

      {/* Submit modal */}
      {showSubmitModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl p-6 max-w-md w-full mx-4 shadow-xl">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Submit Exam?</h3>
            <p className="text-gray-600 text-sm mb-4">
              You have answered {answeredCount} of {questions.length} questions.
              {questions.length - answeredCount > 0 && (
                <span className="text-orange-600 font-medium">
                  {' '}{questions.length - answeredCount} unanswered questions.
                </span>
              )}
            </p>
            <div className="flex space-x-3">
              <button
                onClick={() => setShowSubmitModal(false)}
                className="btn-secondary flex-1"
              >
                Keep going
              </button>
              <button
                onClick={() => submitExam()}
                disabled={submitting}
                className="btn-primary flex-1"
              >
                {submitting ? 'Submitting...' : 'Submit'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
