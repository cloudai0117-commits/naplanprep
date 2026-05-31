import { useParams, Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import apiClient from '@/api/client'

function getBandColor(band: number) {
  if (band >= 8) return 'text-green-600'
  if (band >= 6) return 'text-blue-600'
  if (band >= 4) return 'text-yellow-600'
  return 'text-red-600'
}

function getBandLabel(band: number) {
  if (band >= 9) return 'Outstanding'
  if (band >= 7) return 'Above Average'
  if (band >= 5) return 'Average'
  if (band >= 3) return 'Below Average'
  return 'Developing'
}

export default function ResultsPage() {
  const { sessionId } = useParams<{ sessionId: string }>()

  const { data: result, isLoading } = useQuery({
    queryKey: ['exam-result', sessionId],
    queryFn: () => apiClient.get(`/exams/results/${sessionId}`).then((r) => r.data.data),
  })

  if (isLoading) {
    return <div className="text-center py-20 text-gray-500">Loading results...</div>
  }

  if (!result) {
    return <div className="text-center py-20 text-gray-500">Results not found</div>
  }

  // API returns domainScores as { topic: { correct, total, percentage } }
  const domainData = result.domainScores
    ? Object.entries(result.domainScores).map(([topic, s]: [string, any]) => ({
        domain: topic.replace(/_/g, ' '),
        score: Math.round(s.percentage || 0),
        correct: s.correct || 0,
        total: s.total || 0,
      }))
    : []

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="text-center card">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Exam Complete!</h1>
        <div className="flex justify-center items-baseline space-x-4 my-6">
          <div className="text-center">
            <div data-testid="percentage" className="text-6xl font-bold text-primary-600">
              {result.percentage != null && !isNaN(result.percentage)
                ? `${Math.round(result.percentage)}%`
                : '—'}
            </div>
            <div className="text-gray-500 text-sm mt-1">Overall Score</div>
          </div>
          <div className="text-center">
            <div data-testid="naplan-band" className={`text-5xl font-bold ${getBandColor(result.band || 0)}`}>
              {result.band ? `Band ${result.band}` : '—'}
            </div>
            <div className="text-gray-500 text-sm mt-1">{getBandLabel(result.band || 0)}</div>
          </div>
        </div>
        <div className="flex justify-center space-x-6 text-sm text-gray-600">
          <span data-testid="overall-score">✅ {result.correctAnswers}/{result.totalQuestions}</span>
          <span>❌ {result.totalQuestions - result.correctAnswers} incorrect</span>
          <span>📝 {result.totalQuestions} total</span>
        </div>
      </div>

      {domainData.length > 0 && (
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Domain Breakdown</h2>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={domainData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="domain" tick={{ fontSize: 11 }} />
              <YAxis domain={[0, 100]} tick={{ fontSize: 11 }} />
              <Tooltip formatter={(v) => [`${v}%`, 'Score']} />
              <Bar dataKey="score" fill="#3b82f6" radius={4} />
            </BarChart>
          </ResponsiveContainer>
          <div className="mt-4 grid grid-cols-2 md:grid-cols-3 gap-3">
            {domainData.map((d) => (
              <div key={d.domain} className="p-3 bg-gray-50 rounded-lg">
                <div className="text-xs font-medium text-gray-500 uppercase">{d.domain}</div>
                <div className="text-xl font-bold text-gray-900 mt-1">{d.score}%</div>
                <div className="text-xs text-gray-500">{d.correct}/{d.total} correct</div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="flex space-x-4">
        <Link to="/exams" className="btn-primary flex-1 text-center py-3">
          Practice Again
        </Link>
        <Link to="/dashboard" className="btn-secondary flex-1 text-center py-3">
          Back to Dashboard
        </Link>
      </div>
    </div>
  )
}
