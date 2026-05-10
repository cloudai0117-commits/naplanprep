import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import apiClient from '@/api/client'
import { useAdminStore } from '@/store/adminStore'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
})

type FormData = z.infer<typeof schema>

export default function AdminLogin() {
  const navigate = useNavigate()
  const setAuth = useAdminStore((s) => s.setAuth)

  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  })

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: FormData) => apiClient.post('/auth/login', data),
    onSuccess: (res) => {
      const { accessToken, user } = res.data.data
      if (user.role !== 'PLATFORM_ADMIN') {
        throw new Error('Access denied: not a platform admin')
      }
      setAuth(user, accessToken)
      navigate('/dashboard')
    },
  })

  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center">
      <div className="bg-white rounded-xl shadow-xl p-8 w-full max-w-sm">
        <div className="text-center mb-6">
          <h1 className="text-2xl font-bold text-gray-900">NAPLANPrep</h1>
          <p className="text-gray-500 text-sm mt-1">Admin Panel</p>
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
            {(error as any)?.message || 'Invalid credentials or insufficient permissions'}
          </div>
        )}

        <form className="space-y-4" onSubmit={handleSubmit((d) => mutate(d))}>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input {...register('email')} type="email" className="input-field" placeholder="admin@naplanprep.com.au" />
            {errors.email && <p className="mt-1 text-xs text-red-600">Invalid email</p>}
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <input {...register('password')} type="password" className="input-field" placeholder="••••••••" />
          </div>
          <button type="submit" disabled={isPending} className="btn-primary w-full py-2.5">
            {isPending ? 'Signing in...' : 'Sign in'}
          </button>
        </form>
      </div>
    </div>
  )
}
