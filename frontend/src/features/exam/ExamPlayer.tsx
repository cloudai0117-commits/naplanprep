import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import apiClient from '@/api/client'
import { audioMimeType } from '@/utils/audioMimeType'
import { shortAnswerPlaceholder, showSpellingHint } from '@/utils/examPlayerUtils'

// Simple 4-operation calculator widget for permitted questions.
// Rendered only when the current question's calculatorAllowed === true (server-authoritative).
function CalculatorWidget() {
  const [display, setDisplay] = useState('0')
  const [pending, setPending] = useState<number | null>(null)
  const [op, setOp]           = useState<string | null>(null)
  const [fresh, setFresh]     = useState(true)

  const input = (char: string) => {
    if (fresh) { setDisplay(char === '.' ? '0.' : char); setFresh(false) }
    else if (char === '.' && display.includes('.')) return
    else setDisplay(display === '0' ? char : display + char)
  }

  const operation = (nextOp: string) => {
    const val = parseFloat(display)
    if (pending !== null && op) {
      const result = compute(pending, val, op)
      setDisplay(String(result)); setPending(result)
    } else {
      setPending(val)
    }
    setOp(nextOp); setFresh(true)
  }

  const compute = (a: number, b: number, o: string) => {
    if (o === '+') return a + b
    if (o === '−') return a - b
    if (o === '×') return a * b
    if (o === '÷') return b !== 0 ? a / b : 0
    return b
  }

  const equals = () => {
    if (pending === null || op === null) return
    const result = compute(pending, parseFloat(display), op)
    const str = String(parseFloat(result.toPrecision(10)))
    setDisplay(str); setPending(null); setOp(null); setFresh(true)
  }

  const clear = () => { setDisplay('0'); setPending(null); setOp(null); setFresh(true) }

  const btn = (label: string, action: () => void, cls = '') => (
    <button
      key={label}
      onClick={action}
      className={`p-2 text-sm font-medium rounded border border-gray-300 hover:bg-gray-100 transition-colors ${cls}`}
    >
      {label}
    </button>
  )

  return (
    <div data-testid="calculator-widget" className="mt-4 p-3 bg-gray-50 border border-gray-200 rounded-lg w-48 select-none">
      <div className="text-right font-mono text-base bg-white border border-gray-300 rounded px-2 py-1 mb-2 overflow-hidden truncate">
        {display}
      </div>
      <div className="grid grid-cols-4 gap-1">
        {btn('C',   clear,                  'col-span-2 bg-red-50 text-red-700')}
        {btn('÷',   () => operation('÷'),   'bg-blue-50 text-blue-700')}
        {btn('×',   () => operation('×'),   'bg-blue-50 text-blue-700')}
        {btn('7',   () => input('7'))}
        {btn('8',   () => input('8'))}
        {btn('9',   () => input('9'))}
        {btn('−',   () => operation('−'),   'bg-blue-50 text-blue-700')}
        {btn('4',   () => input('4'))}
        {btn('5',   () => input('5'))}
        {btn('6',   () => input('6'))}
        {btn('+',   () => operation('+'),   'bg-blue-50 text-blue-700')}
        {btn('1',   () => input('1'))}
        {btn('2',   () => input('2'))}
        {btn('3',   () => input('3'))}
        {btn('=',   equals,                 'row-span-2 bg-green-100 text-green-800')}
        {btn('0',   () => input('0'),       'col-span-2')}
        {btn('.',   () => input('.'))}
      </div>
    </div>
  )
}

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
  const queryClient = useQueryClient()
  const [currentIdx, setCurrentIdx] = useState(0)
  const [answers, setAnswers] = useState<Record<string, string>>({})
  const [flagged, setFlagged] = useState<Record<string, boolean>>({})
  const [showSubmitModal, setShowSubmitModal] = useState(false)
  const hasTimerStarted = useRef(false)
  const [showBackWarning, setShowBackWarning] = useState(false)

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

  const sessionStatus = session?.status
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
      queryClient.invalidateQueries({ queryKey: ['available-exams'] })
      queryClient.invalidateQueries({ queryKey: ['progress-overview'] })
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

  // Block browser back navigation during an active exam session
  useEffect(() => {
    if (!session || sessionStatus !== 'IN_PROGRESS') return

    // Push a dummy state so there's something to catch
    window.history.pushState({ examActive: true }, '')

    const handlePopState = (_e: PopStateEvent) => {
      // Re-push so the back button can't escape
      window.history.pushState({ examActive: true }, '')
      setShowBackWarning(true)
    }

    const handleBeforeUnload = (e: BeforeUnloadEvent) => {
      e.preventDefault()
      e.returnValue = 'Your exam is in progress. Leaving will not submit your answers.'
    }

    window.addEventListener('popstate', handlePopState)
    window.addEventListener('beforeunload', handleBeforeUnload)
    return () => {
      window.removeEventListener('popstate', handlePopState)
      window.removeEventListener('beforeunload', handleBeforeUnload)
    }
  }, [session, sessionStatus])

  // Track when the timer has actually started counting (i.e., had a positive value).
  // Prevents auto-submit firing on initial render when remaining is 0 by default.
  useEffect(() => {
    if (timer.remaining > 0) {
      hasTimerStarted.current = true
    }
  }, [timer.remaining])

  useEffect(() => {
    if (timer.remaining === 0 && hasTimerStarted.current && sessionStatus === 'IN_PROGRESS') {
      submitExam()
    }
  }, [timer.remaining, sessionStatus, submitExam])

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
  // NAPLAN Spelling has a pool of 43 questions (S1+S2A+S2B+S3A+S3B) but the student
  // path is always 25 (7+9+9 through one branch). Show 25 for display purposes.
  const displayTotal = session?.domain === 'SPELLING' ? 25 : questions.length
  const progress = displayTotal > 0 ? (answeredCount / displayTotal) * 100 : 0

  return (
    <div className="fixed inset-0 z-50 bg-gray-50 flex flex-col">
      {/* Back-navigation warning modal */}
      {showBackWarning && (
        <div className="fixed inset-0 z-[60] bg-black/50 flex items-center justify-center">
          <div className="bg-white rounded-xl shadow-xl p-6 max-w-sm mx-4 text-center">
            <div className="text-4xl mb-3">⚠️</div>
            <h2 className="text-lg font-bold text-gray-900 mb-2">Exam in Progress</h2>
            <p className="text-gray-600 text-sm mb-4">
              You cannot navigate away during an exam. Please submit your exam first.
            </p>
            <button
              onClick={() => setShowBackWarning(false)}
              className="btn-primary w-full"
            >
              Continue Exam
            </button>
          </div>
        </div>
      )}
      {/* Header */}
      <div className="bg-white border-b border-gray-200 px-4 py-3 flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <div>
            {session?.examTitle && (
              <div data-testid="exam-title" className="text-xs text-gray-500 font-medium">{session.examTitle}</div>
            )}
            <span data-testid="question-counter" className="font-semibold text-gray-800">
              Question {currentIdx + 1} of {displayTotal}
            </span>
          </div>
          <div className="hidden md:flex items-center text-sm text-gray-600">
            <span data-testid="progress-bar" className="w-24 bg-gray-200 rounded-full h-2 mr-2">
              <div
                className="bg-primary-500 h-2 rounded-full transition-all"
                style={{ width: `${progress}%` }}
              />
            </span>
            {answeredCount}/{displayTotal} answered
          </div>
        </div>
        <div className={`font-mono text-lg font-bold ${timer.remaining < 300 ? 'text-red-600' : 'text-gray-800'}`}>
          ⏱ <span data-testid="exam-timer">{timer.label}</span>
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
                  <h2 data-testid="question-text" className="text-lg font-medium text-gray-900 leading-relaxed">
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

                {/* Calculator: only for Numeracy questions that explicitly permit it.
                  Domain and calculatorAllowed both come from the server-side snapshot. */}
              {currentQuestion.domain === 'NUMERACY' && currentQuestion.calculatorAllowed === true && <CalculatorWidget key={currentQuestionId} />}

              {currentQuestion.questionType === 'AUDIO_RESPONSE' ? (
                  <div className="mt-4">
                    {currentQuestion.audioUrl ? (
                      <div className="mb-4">
                        <audio
                          key={currentQuestionId}
                          controls
                          className="w-full"
                          aria-label="Listen to the word to spell"
                        >
                          <source src={currentQuestion.audioUrl} type={audioMimeType(currentQuestion.audioUrl)} />
                        </audio>
                        <p className="mt-1 text-xs text-gray-500">
                          Listen to the audio, then type the correct spelling below.
                        </p>
                      </div>
                    ) : (
                      <div className="mb-4 p-3 bg-amber-50 border border-amber-200 rounded-lg text-sm text-amber-700">
                        Audio for this item is not yet available. Type the correct spelling below.
                      </div>
                    )}
                    <input
                      type="text"
                      autoComplete="off"
                      autoCorrect="off"
                      autoCapitalize="off"
                      spellCheck={false}
                      data-testid="short-answer-input"
                      placeholder="Type the spelling here"
                      value={answers[currentQuestionId] || ''}
                      onChange={(e) => handleAnswer(currentQuestionId, e.target.value)}
                      className="w-full border-2 border-gray-300 rounded-lg px-4 py-3 text-lg font-medium text-gray-800 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-200 transition-colors"
                    />
                    <p className="mt-2 text-xs text-gray-500">Type one word. Spelling counts.</p>
                  </div>
                ) : currentQuestion.questionType === 'SHORT_ANSWER' ? (
                  <div className="mt-4">
                    <input
                      type="text"
                      autoComplete="off"
                      autoCorrect="off"
                      autoCapitalize="off"
                      spellCheck={false}
                      data-testid="short-answer-input"
                      placeholder={shortAnswerPlaceholder(currentQuestion.domain)}
                      value={answers[currentQuestionId] || ''}
                      onChange={(e) => handleAnswer(currentQuestionId, e.target.value)}
                      className="w-full border-2 border-gray-300 rounded-lg px-4 py-3 text-lg font-medium text-gray-800 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-200 transition-colors"
                    />
                    {showSpellingHint(currentQuestion.domain) && (
                      <p className="mt-2 text-xs text-gray-500">Type one word. Spelling counts.</p>
                    )}
                  </div>
                ) : Array.isArray(currentQuestion.options) && currentQuestion.options.length > 0 && (
                  <div className="space-y-2" data-testid="options-list">
                    {currentQuestion.options.map((opt: any) => {
                      const optLabel = typeof opt === 'string' ? opt : (opt.label ?? opt.value ?? String(opt))
                      const optText = typeof opt === 'string' ? opt : (opt.text ?? opt.value ?? optLabel)
                      return (
                      <label
                        key={optLabel}
                        data-testid="answer-option"
                        aria-checked={answers[currentQuestionId] === optLabel}
                        className={`flex items-center p-4 border rounded-lg cursor-pointer transition-colors ${
                          answers[currentQuestionId] === optLabel
                            ? 'border-primary-500 bg-primary-50 selected'
                            : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                        }`}
                      >
                        <input
                          type="radio"
                          name={`q-${currentQuestionId}`}
                          value={optLabel}
                          checked={answers[currentQuestionId] === optLabel}
                          onChange={() => handleAnswer(currentQuestionId, optLabel)}
                          className="sr-only"
                        />
                        <div className={`w-4 h-4 rounded-full border-2 mr-3 flex-shrink-0 ${
                          answers[currentQuestionId] === optLabel
                            ? 'border-primary-500 bg-primary-500'
                            : 'border-gray-400'
                        }`} />
                        <span className="text-gray-800">{optLabel}. {optText}</span>
                      </label>
                    )
                    })}
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
        <div data-testid="question-nav-panel" className="w-48 border-l border-gray-200 bg-white p-4 overflow-y-auto hidden lg:block">
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
              You have answered {answeredCount} of {displayTotal} questions.
              {displayTotal - answeredCount > 0 && (
                <span className="text-orange-600 font-medium">
                  {' '}{displayTotal - answeredCount} unanswered questions.
                </span>
              )}
            </p>
            <div className="flex space-x-3">
              <button
                onClick={() => setShowSubmitModal(false)}
                className="btn-secondary flex-1"
              >
                {answeredCount === questions.length ? 'Review answers' : 'Keep going'}
              </button>
              <button
                data-testid="confirm-submit-btn"
                onClick={() => submitExam()}
                disabled={submitting}
                className="btn-primary flex-1"
              >
                {submitting ? 'Submitting...' : 'Confirm Submit'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
