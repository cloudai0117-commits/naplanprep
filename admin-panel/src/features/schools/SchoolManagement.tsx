import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import apiClient from '@/api/client'

interface School {
  id: string
  name: string
  state: string
}

const AU_STATES = ['NSW', 'VIC', 'QLD', 'SA', 'WA', 'TAS', 'NT', 'ACT']

export default function SchoolManagement() {
  const [showForm, setShowForm] = useState(false)
  const queryClient = useQueryClient()

  const { data: schools, isLoading } = useQuery<School[]>({
    queryKey: ['admin-schools'],
    queryFn: () => apiClient.get('/schools').then((r) => r.data.data),
  })

  const { register, handleSubmit, reset, formState: { errors, isSubmitting } } = useForm<{ name: string; state: string }>()

  const { mutate: addSchool } = useMutation({
    mutationFn: (data: { name: string; state: string }) => apiClient.post('/schools', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-schools'] })
      reset()
      setShowForm(false)
    },
  })

  const { mutate: deleteSchool } = useMutation({
    mutationFn: (id: string) => apiClient.delete(`/schools/${id}`),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-schools'] }),
  })

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold text-gray-900">School Management</h1>
          <p className="text-sm text-gray-500 mt-0.5">Schools appear in the student signup dropdown</p>
        </div>
        <button onClick={() => setShowForm(!showForm)} className="btn-primary text-sm py-2 px-4">
          {showForm ? 'Cancel' : '+ Add School'}
        </button>
      </div>

      {showForm && (
        <div className="card p-5 border border-primary-200 bg-primary-50">
          <h2 className="text-sm font-semibold text-gray-800 mb-3">Add New School</h2>
          <form onSubmit={handleSubmit((d) => addSchool(d))} className="flex items-end gap-3">
            <div className="flex-1">
              <label className="block text-xs font-medium text-gray-700 mb-1">School Name *</label>
              <input
                {...register('name', { required: 'School name is required' })}
                className="input-field"
                placeholder="e.g. Sydney Grammar School"
              />
              {errors.name && <p className="text-xs text-red-600 mt-1">{errors.name.message}</p>}
            </div>
            <div className="w-32">
              <label className="block text-xs font-medium text-gray-700 mb-1">State *</label>
              <select {...register('state', { required: true })} className="input-field">
                <option value="">State</option>
                {AU_STATES.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <button type="submit" disabled={isSubmitting} className="btn-primary py-2 px-4 text-sm">
              {isSubmitting ? 'Adding...' : 'Add School'}
            </button>
          </form>
        </div>
      )}

      <div className="card p-0 overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-gray-500">Loading schools...</div>
        ) : !schools || schools.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            <div className="text-4xl mb-3">🏫</div>
            <p>No schools added yet. Click "Add School" to get started.</p>
          </div>
        ) : (
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="table-th">School Name</th>
                <th className="table-th">State</th>
                <th className="table-th">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {schools.map((school) => (
                <tr key={school.id} className="hover:bg-gray-50">
                  <td className="table-td font-medium text-gray-900">{school.name}</td>
                  <td className="table-td">
                    <span className="badge bg-blue-50 text-blue-700">{school.state}</span>
                  </td>
                  <td className="table-td">
                    <button
                      onClick={() => {
                        if (confirm(`Delete "${school.name}"?`)) deleteSchool(school.id)
                      }}
                      className="text-xs text-red-600 hover:text-red-800 font-medium"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <p className="text-xs text-gray-400">
        Total: {schools?.length || 0} school{schools?.length !== 1 ? 's' : ''}
      </p>
    </div>
  )
}
