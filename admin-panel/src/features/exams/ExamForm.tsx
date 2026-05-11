import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import apiClient from '@/api/client'

type FormValues = {
  title: string
  description: string
  yearLevel: number
  domain: string
  packageTier: string
  timeLimitSeconds: number
  availableFrom: string
  availableUntil: string
}

const DOMAINS = ['NUMERACY', 'READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION']
const TIERS = ['FREE', 'STANDARD', 'PREMIUM', 'FAMILY']
const YEAR_LEVELS = [3, 5, 7, 9]

export default function ExamForm() {
  const { examId } = useParams<{ examId: string }>()
  const isNew = examId === 'new'
  const navigate = useNavigate()
  const queryClient = useQueryClient()

  const { data: exam } = useQuery({
    queryKey: ['admin-exam', examId],
    queryFn: () => apiClient.get(`/admin/exams/${examId}`).then((r) => r.data.data),
    enabled: !isNew && !!examId,
  })

  const { register, handleSubmit, reset, formState: { errors, isSubmitting } } = useForm<FormValues>({
    defaultValues: {
      title: '',
      description: '',
      yearLevel: 5,
      domain: 'NUMERACY',
      packageTier: 'FREE',
      timeLimitSeconds: 1800,
      availableFrom: '',
      availableUntil: '',
    },
  })

  useEffect(() => {
    if (exam) {
      reset({
        title: exam.title,
        description: exam.description || '',
        yearLevel: exam.yearLevel,
        domain: exam.domain,
        packageTier: exam.packageTier,
        timeLimitSeconds: exam.timeLimitSeconds,
        availableFrom: exam.availableFrom ? exam.availableFrom.slice(0, 16) : '',
        availableUntil: exam.availableUntil ? exam.availableUntil.slice(0, 16) : '',
      })
    }
  }, [exam, reset])

  const { mutateAsync: save } = useMutation({
    mutationFn: (values: FormValues) => {
      const payload = {
        ...values,
        timeLimitSeconds: Number(values.timeLimitSeconds),
        yearLevel: Number(values.yearLevel),
        availableFrom: values.availableFrom ? new Date(values.availableFrom).toISOString() : null,
        availableUntil: values.availableUntil ? new Date(values.availableUntil).toISOString() : null,
      }
      return isNew
        ? apiClient.post('/admin/exams', payload)
        : apiClient.put(`/admin/exams/${examId}`, payload)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-exams'] })
      navigate('/exams')
    },
  })

  const onSubmit = handleSubmit((values) => save(values))

  return (
    <div className="max-w-2xl">
      <div className="flex items-center space-x-3 mb-6">
        <button onClick={() => navigate('/exams')} className="text-gray-500 hover:text-gray-700 text-sm">
          ← Exams
        </button>
        <h1 className="text-xl font-semibold text-gray-900">
          {isNew ? 'New Exam' : 'Edit Exam'}
        </h1>
      </div>

      <form onSubmit={onSubmit} className="bg-white border border-gray-200 rounded-xl p-6 space-y-5">
        <div>
          <label className="block text-xs font-medium text-gray-700 mb-1">Title *</label>
          <input
            {...register('title', { required: 'Title is required', maxLength: 200 })}
            className="input-field"
            placeholder="Year 5 Numeracy Practice"
          />
          {errors.title && <p className="text-xs text-red-600 mt-1">{errors.title.message}</p>}
        </div>

        <div>
          <label className="block text-xs font-medium text-gray-700 mb-1">Description</label>
          <textarea
            {...register('description')}
            className="input-field"
            rows={3}
            placeholder="Optional description shown to students before they start."
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Year Level *</label>
            <select {...register('yearLevel', { required: true })} className="input-field">
              {YEAR_LEVELS.map((y) => (
                <option key={y} value={y}>Year {y}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Domain *</label>
            <select {...register('domain', { required: true })} className="input-field">
              {DOMAINS.map((d) => (
                <option key={d} value={d}>{d.replace(/_/g, ' ')}</option>
              ))}
            </select>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Package Tier *</label>
            <select {...register('packageTier', { required: true })} className="input-field">
              {TIERS.map((t) => (
                <option key={t} value={t}>{t}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Time Limit (seconds) *</label>
            <input
              type="number"
              {...register('timeLimitSeconds', { required: true, min: 60 })}
              className="input-field"
              placeholder="1800"
            />
            <p className="text-xs text-gray-400 mt-1">
              {/* display friendly hint */}
              {1800} seconds = 30 minutes
            </p>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Available From</label>
            <input
              type="datetime-local"
              {...register('availableFrom')}
              className="input-field"
            />
            <p className="text-xs text-gray-400 mt-1">Leave blank for no start restriction.</p>
          </div>
          <div>
            <label className="block text-xs font-medium text-gray-700 mb-1">Available Until</label>
            <input
              type="datetime-local"
              {...register('availableUntil')}
              className="input-field"
            />
            <p className="text-xs text-gray-400 mt-1">Leave blank for no end restriction.</p>
          </div>
        </div>

        <div className="flex items-center justify-end space-x-3 pt-2 border-t border-gray-100">
          <button type="button" onClick={() => navigate('/exams')} className="btn-secondary">
            Cancel
          </button>
          <button type="submit" disabled={isSubmitting} className="btn-primary">
            {isSubmitting ? 'Saving...' : isNew ? 'Create Exam' : 'Save Changes'}
          </button>
        </div>
      </form>
    </div>
  )
}
