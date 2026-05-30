import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { RadarChart, Radar, PolarGrid, PolarAngleAxis, ResponsiveContainer, Tooltip } from 'recharts'
import apiClient from '@/api/client'

export default function ExamResultsDetailPage() {
  const { examId, sessionId } = useParams<{ examId: string; sessionId: string }>()
  const navigate = useNavigate()

  const { data: result, isLoading } = useQuery({
    queryKey: ['exam-result-detail', sessionId],
    queryFn: () => apiClient.get(`/exams/results/${sessionId}`).then((r) => r.data.data),
    enabled: !!sessionId,
  })

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-96">
        <div className="text-gray-500">Loading results...</div>
      </div>
    )
  }

  if (!result) {
    return (
      <div className="text-center py-20">
        <h2 className="text-xl font-semibold text-gray-800">Results not found</h2>
        <button onClick={() => navigate('/dashboard')} className="btn-secondary mt-4">
          Back to Dashboard
        </button>
      </div>
    )
  }

  const radarData = Object.entries(result.domainScores || {}).map(([topic, s]: [string, any]) => ({
    topic: topic.replace(/_/g, ' '),
    score: s.percentage,
  }))

  const timeTaken = result.timeTakenSeconds
  const timeTakenLabel = timeTaken
    ? `${Math.floor(timeTaken / 60)}m ${timeTaken % 60}s`
    : '—'

  const bandColor = (band: string) => {
    const n = parseInt(band)
    if (n >= 8) return 'text-green-600'
    if (n >= 6) return 'text-blue-600'
    if (n >= 4) return 'text-yellow-600'
    return 'text-red-600'
  }

  return (
    <div className="max-w-3xl mx-auto py-8 px-4 space-y-6">
      <div className="flex items-center justify-between">
        <button
          onClick={() => navigate('/dashboard')}
          className="text-gray-500 hover:text-gray-700 text-sm flex items-center space-x-1"
        >
          <span>←</span>
          <span>Back to Dashboard</span>
        </button>
        <button
          onClick={() => navigate('/history')}
          className="text-sm text-primary-600 hover:text-primary-700"
        >
          View all results
        </button>
      </div>

      {/* Score summary */}
      <div className="card text-center">
        <h1 className="text-xl font-bold text-gray-900 mb-1">{result.examTitle || 'Exam Results'}</h1>
        <p className="text-gray-500 text-sm mb-6">
          {result.startedAt ? new Date(result.startedAt).toLocaleDateString('en-AU', { dateStyle: 'long' }) : ''}
        </p>

        <div className="flex justify-center items-center mb-6">
          <div className="relative">
            <svg className="w-36 h-36 -rotate-90">
              <circle cx="72" cy="72" r="60" fill="none" stroke="#e5e7eb" strokeWidth="12" />
              <circle
                cx="72" cy="72" r="60"
                fill="none"
                stroke={
                  result.percentage != null && !isNaN(result.percentage)
                    ? result.percentage >= 80 ? '#10b981' : result.percentage >= 60 ? '#3b82f6' : '#f59e0b'
                    : '#e5e7eb'
                }
                strokeWidth="12"
                strokeDasharray={`${((result.percentage ?? 0) / 100) * 376.99} 376.99`}
                strokeLinecap="round"
              />
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span data-testid="percentage" className="text-3xl font-bold text-gray-900">
                {result.percentage != null && !isNaN(result.percentage) ? `${Math.round(result.percentage)}%` : '—'}
              </span>
              <span data-testid="overall-score" className="text-xs text-gray-500">{result.correctAnswers}/{result.totalQuestions}</span>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-4">
          <div>
            <div data-testid="naplan-band" className={`text-2xl font-bold ${bandColor(result.band)}`}>Band {result.band}</div>
            <div className="text-xs text-gray-500">NAPLAN Band</div>
          </div>
          <div>
            <div data-testid="time-taken" className="text-2xl font-bold text-gray-900">{timeTakenLabel}</div>
            <div className="text-xs text-gray-500">Time Taken</div>
          </div>
          <div>
            <div className="text-2xl font-bold text-gray-900">{result.totalQuestions - result.correctAnswers}</div>
            <div className="text-xs text-gray-500">Incorrect</div>
          </div>
        </div>
      </div>

      {/* Topic breakdown */}
      {radarData.length > 0 && (
        <div data-testid="topic-breakdown" className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Performance by Topic</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-center">
            <ResponsiveContainer width="100%" height={220}>
              <RadarChart data={radarData}>
                <PolarGrid />
                <PolarAngleAxis dataKey="topic" tick={{ fontSize: 10 }} />
                <Radar dataKey="score" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.25} />
                <Tooltip formatter={(v) => [`${v}%`, 'Score']} />
              </RadarChart>
            </ResponsiveContainer>
            <div className="space-y-2">
              {Object.entries(result.domainScores || {}).map(([topic, s]: [string, any]) => (
                <div key={topic}>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="text-gray-700">{topic.replace(/_/g, ' ')}</span>
                    <span className="font-medium">{s.correct}/{s.total}</span>
                  </div>
                  <div className="w-full bg-gray-100 rounded-full h-2">
                    <div
                      className="h-2 rounded-full transition-all"
                      style={{
                        width: `${s.percentage}%`,
                        background: s.percentage >= 70 ? '#10b981' : s.percentage >= 50 ? '#3b82f6' : '#ef4444',
                      }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Question review */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Question Review</h2>
        <div data-testid="question-review-list" className="space-y-4">
          {(result.questions || []).map((q: any) => (
            <div
              key={q.questionId}
              className={`p-4 rounded-lg border ${
                q.correct ? 'border-green-200 bg-green-50' : 'border-red-200 bg-red-50'
              }`}
            >
              <div className="flex items-start justify-between mb-2">
                <span className="text-xs font-semibold text-gray-500 uppercase">
                  Q{q.questionOrder}
                </span>
                <span className={`text-xs font-bold ${q.correct ? 'text-green-600' : 'text-red-600'}`}>
                  {q.correct ? 'Correct' : 'Incorrect'}
                </span>
              </div>

              {q.stimulusText && (
                <div className="text-xs text-gray-600 mb-2 p-2 bg-white/70 rounded border border-gray-200">
                  {q.stimulusText}
                </div>
              )}

              <p className="text-sm text-gray-800 font-medium mb-3">{q.questionText}</p>

              {q.options?.options && (
                <div className="space-y-1.5">
                  {q.options.options.map((opt: string) => {
                    const isCorrect = opt === q.correctAnswer
                    const isStudentAnswer = opt === q.studentAnswer
                    return (
                      <div
                        key={opt}
                        className={`flex items-center px-3 py-2 rounded text-sm ${
                          isCorrect
                            ? 'bg-green-100 border border-green-300 text-green-800'
                            : isStudentAnswer && !isCorrect
                            ? 'bg-red-100 border border-red-300 text-red-800'
                            : 'bg-white border border-gray-200 text-gray-700'
                        }`}
                      >
                        <span className="mr-2">
                          {isCorrect ? '✓' : isStudentAnswer && !isCorrect ? '✗' : '○'}
                        </span>
                        {opt}
                        {isCorrect && <span className="ml-auto text-xs text-green-600">Correct answer</span>}
                        {isStudentAnswer && !isCorrect && (
                          <span className="ml-auto text-xs text-red-600">Your answer</span>
                        )}
                      </div>
                    )
                  })}
                </div>
              )}

              {q.explanation && (
                <div className="mt-3 text-xs text-gray-600 p-2 bg-blue-50 border border-blue-200 rounded">
                  <strong>Explanation:</strong> {q.explanation}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      <div className="flex space-x-3">
        <button onClick={() => navigate('/dashboard')} className="btn-secondary flex-1">
          Back to Dashboard
        </button>
        <button onClick={() => navigate('/history')} className="btn-primary flex-1">
          View All Results
        </button>
      </div>
    </div>
  )
}
