import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { useMutation, useQuery } from '@tanstack/react-query'
import { useState, useRef, useEffect } from 'react'
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
  yearLevel: z.coerce.number().optional(),
  school: z.string().optional(),
})

type FormData = z.infer<typeof schema>

export default function RegisterPage() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)
  const [searchParams] = useSearchParams()
  const redirectPlan = searchParams.get('plan')
  const [schoolSearch, setSchoolSearch] = useState('')
  const [showDropdown, setShowDropdown] = useState(false)
  const [selectedSchool, setSelectedSchool] = useState('')
  const dropdownRef = useRef<HTMLDivElement>(null)

  const { register, handleSubmit, setValue, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  })

  const { data: schoolsData } = useQuery({
    queryKey: ['schools', schoolSearch],
    queryFn: () => apiClient.get(`/schools${schoolSearch ? `?search=${encodeURIComponent(schoolSearch)}` : ''}`).then((r) => r.data.data),
  })

  const schools: { id: string; name: string; state: string }[] = schoolsData || []

  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setShowDropdown(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const { mutate: checkout } = useMutation({
    mutationFn: (planSlug: string) =>
      apiClient.post('/subscriptions/checkout', { planSlug }),
    onSuccess: (res) => {
      const url = res.data.data?.checkoutUrl
      if (url) window.location.href = url
      else navigate('/dashboard')
    },
    onError: () => navigate('/dashboard'),
  })

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: FormData) => apiClient.post('/auth/register', { ...data, role: 'STUDENT' }),
    onSuccess: (res) => {
      const { accessToken, refreshToken, user } = res.data.data
      setAuth(user, accessToken, refreshToken)
      if (redirectPlan && redirectPlan !== 'free' && redirectPlan !== 'basic') {
        checkout(redirectPlan)
      } else {
        navigate('/dashboard')
      }
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
              <input {...register('email')} type="email" required className="input-field" placeholder="jane@example.com" />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email.message}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Password *</label>
              <input {...register('password')} type="password" className="input-field" placeholder="••••••••" />
              {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password.message}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Year Level</label>
              <select {...register('yearLevel')} className="input-field">
                <option value="">Select year level</option>
                {[3, 5, 7, 9].map((y) => (
                  <option key={y} value={y}>Year {y}</option>
                ))}
              </select>
            </div>

            <div ref={dropdownRef}>
              <label className="block text-sm font-medium text-gray-700 mb-1">School</label>
              <input
                type="text"
                className="input-field"
                placeholder="Search for your school..."
                value={selectedSchool || schoolSearch}
                onFocus={() => setShowDropdown(true)}
                onChange={(e) => {
                  setSelectedSchool('')
                  setValue('school', '')
                  setSchoolSearch(e.target.value)
                  setShowDropdown(true)
                }}
              />
              {showDropdown && schools.length > 0 && (
                <ul className="absolute z-10 mt-1 w-full max-w-sm bg-white border border-gray-200 rounded-lg shadow-lg max-h-48 overflow-y-auto text-sm">
                  {schools.map((s) => (
                    <li
                      key={s.id}
                      className="px-3 py-2 hover:bg-primary-50 cursor-pointer flex items-center justify-between"
                      onMouseDown={() => {
                        setSelectedSchool(s.name)
                        setValue('school', s.name)
                        setSchoolSearch('')
                        setShowDropdown(false)
                      }}
                    >
                      <span>{s.name}</span>
                      <span className="text-xs text-gray-400">{s.state}</span>
                    </li>
                  ))}
                </ul>
              )}
            </div>

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
