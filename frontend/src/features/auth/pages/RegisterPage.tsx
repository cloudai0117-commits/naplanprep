import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Link, useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'
import { useAuthStore } from '@/store/authStore'

const schema = z.object({
  firstName: z.string().min(2, 'First name must be at least 2 characters'),
  lastName: z.string().optional(),
  email: z.string().email('Invalid email address'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, 'Must contain uppercase, lowercase, and a number'),
  role: z.enum(['STUDENT', 'PARENT']),
  yearLevel: z.coerce.number().optional(),
})

type FormData = z.infer<typeof schema>

export default function RegisterPage() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)

  const { register, handleSubmit, watch, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: { role: 'STUDENT' },
  })

  const role = watch('role')

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: FormData) => apiClient.post('/auth/register', data),
    onSuccess: (res) => {
      const { accessToken, refreshToken, user } = res.data.data
      setAuth(user, accessToken, refreshToken)
      navigate('/dashboard')
    },
  })

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <Link to="/" className="block text-center text-2xl font-bold text-primary-600 mb-6">
          NAPLANPrep
        </Link>
        <h2 className="text-center text-3xl font-bold text-gray-900">Create your account</h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Already have an account?{' '}
          <Link to="/login" className="font-medium text-primary-600 hover:text-primary-500">
            Sign in
          </Link>
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="card py-8 px-4 shadow sm:rounded-xl sm:px-10">
          {error && (
            <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
              {(error as any)?.response?.data?.errors?.[0] || 'Registration failed. Try again.'}
            </div>
          )}

          <form className="space-y-5" onSubmit={handleSubmit((d) => mutate(d))}>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">First name *</label>
                <input {...register('firstName')} className="input-field" placeholder="Jane" />
                {errors.firstName && <p className="mt-1 text-xs text-red-600">{errors.firstName.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Last name</label>
                <input {...register('lastName')} className="input-field" placeholder="Smith" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email *</label>
              <input {...register('email')} type="email" className="input-field" placeholder="jane@example.com" />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email.message}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Password *</label>
              <input {...register('password')} type="password" className="input-field" placeholder="••••••••" />
              {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password.message}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">I am a</label>
              <div className="grid grid-cols-2 gap-3">
                {(['STUDENT', 'PARENT'] as const).map((r) => (
                  <label
                    key={r}
                    className={`flex items-center justify-center p-3 border rounded-lg cursor-pointer transition-colors ${
                      role === r ? 'border-primary-500 bg-primary-50 text-primary-700' : 'border-gray-300'
                    }`}
                  >
                    <input {...register('role')} type="radio" value={r} className="sr-only" />
                    <span className="font-medium text-sm">{r === 'STUDENT' ? '🎓 Student' : '👨‍👩‍👧 Parent'}</span>
                  </label>
                ))}
              </div>
            </div>

            {role === 'STUDENT' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Year Level</label>
                <select {...register('yearLevel')} className="input-field">
                  <option value="">Select year level</option>
                  {[3, 5, 7, 9].map((y) => (
                    <option key={y} value={y}>Year {y}</option>
                  ))}
                </select>
              </div>
            )}

            <button type="submit" disabled={isPending} className="btn-primary w-full py-3">
              {isPending ? 'Creating account...' : 'Create account'}
            </button>
          </form>

          <p className="mt-4 text-xs text-center text-gray-500">
            By registering, you agree to our Terms of Service and Privacy Policy.
          </p>
        </div>
      </div>
    </div>
  )
}
