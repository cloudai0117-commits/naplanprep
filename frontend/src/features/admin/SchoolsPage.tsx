import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import apiClient from '@/api/client'

const AU_STATES = ['NSW', 'VIC', 'QLD', 'WA', 'SA', 'TAS', 'ACT', 'NT']

interface School { id: string; name: string; state: string }

export default function SchoolsPage() {
  const queryClient = useQueryClient()
  const [search, setSearch] = useState('')
  const [newName, setNewName] = useState('')
  const [newState, setNewState] = useState('NSW')
  const [showForm, setShowForm] = useState(false)
  const [deleteId, setDeleteId] = useState<string | null>(null)
  const [formError, setFormError] = useState('')

  const { data, isLoading } = useQuery({
    queryKey: ['admin-schools', search],
    queryFn: () => apiClient.get(`/schools${search ? `?search=${encodeURIComponent(search)}` : ''}`).then((r) => r.data.data),
  })
  const schools: School[] = data || []

  const createMutation = useMutation({
    mutationFn: () => apiClient.post('/schools', { name: newName.trim(), state: newState }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-schools'] })
      setNewName('')
      setNewState('NSW')
      setShowForm(false)
      setFormError('')
    },
    onError: () => setFormError('Failed to create school. Please try again.'),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: string) => apiClient.delete(`/schools/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['admin-schools'] }); setDeleteId(null) },
  })

  return (
    <div className="space-y-6 max-w-3xl">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Schools</h1>
          <p className="text-gray-500 text-sm mt-1">Manage schools available in the student signup dropdown</p>
        </div>
        <button onClick={() => { setShowForm(true); setFormError('') }} className="btn-primary">
          + Add School
        </button>
      </div>

      {showForm && (
        <div className="card border border-primary-200 bg-primary-50 space-y-3">
          <h2 className="font-semibold text-gray-900">New School</h2>
          <div className="flex gap-3">
            <div className="flex-1">
              <label className="block text-xs font-medium text-gray-700 mb-1">School name *</label>
              <input
                className="input-field"
                placeholder="e.g. St Mary's Primary School"
                value={newName}
                onChange={(e) => setNewName(e.target.value)}
                autoFocus
              />
            </div>
            <div className="w-28">
              <label className="block text-xs font-medium text-gray-700 mb-1">State</label>
              <select className="input-field" value={newState} onChange={(e) => setNewState(e.target.value)}>
                {AU_STATES.map((s) => <option key={s}>{s}</option>)}
              </select>
            </div>
          </div>
          {formError && <p className="text-sm text-red-600">{formError}</p>}
          <div className="flex gap-2">
            <button
              onClick={() => { if (!newName.trim()) { setFormError('Name is required'); return } createMutation.mutate() }}
              disabled={createMutation.isPending}
              className="btn-primary"
            >
              {createMutation.isPending ? 'Saving…' : 'Save School'}
            </button>
            <button onClick={() => setShowForm(false)} className="btn-secondary">Cancel</button>
          </div>
        </div>
      )}

      <input
        className="input-field max-w-xs"
        placeholder="Search schools…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {isLoading ? (
        <div className="space-y-2">
          {Array.from({ length: 4 }).map((_, i) => <div key={i} className="card h-12 animate-pulse bg-gray-100" />)}
        </div>
      ) : schools.length === 0 ? (
        <div className="card text-center py-12 text-gray-500">
          {search ? 'No schools match your search.' : 'No schools yet. Click "Add School" to get started.'}
        </div>
      ) : (
        <div className="card divide-y divide-gray-100 p-0 overflow-hidden">
          {schools.map((school) => (
            <div key={school.id} className="flex items-center gap-3 px-4 py-3">
              <div className="flex-1">
                <p className="font-medium text-gray-900">{school.name}</p>
              </div>
              <span className="text-xs font-semibold px-2 py-0.5 rounded bg-blue-100 text-blue-700">{school.state}</span>
              <button
                onClick={() => setDeleteId(school.id)}
                className="text-gray-400 hover:text-red-500 text-xs px-2 py-1 rounded hover:bg-red-50 transition-colors"
              >
                Delete
              </button>
            </div>
          ))}
        </div>
      )}

      <p className="text-sm text-gray-500">{schools.length} school{schools.length !== 1 ? 's' : ''} total</p>

      {deleteId && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4" role="dialog">
          <div className="bg-white rounded-xl shadow-xl max-w-sm w-full p-6">
            <h2 className="text-lg font-bold text-gray-900 mb-2">Delete School?</h2>
            <p className="text-sm text-gray-600 mb-5">This removes the school from the signup dropdown.</p>
            <div className="flex gap-3">
              <button onClick={() => setDeleteId(null)} className="btn-secondary flex-1">Cancel</button>
              <button
                onClick={() => deleteMutation.mutate(deleteId)}
                disabled={deleteMutation.isPending}
                className="flex-1 py-2 px-4 rounded-lg bg-red-600 text-white text-sm font-medium hover:bg-red-700 disabled:opacity-50"
              >
                {deleteMutation.isPending ? 'Deleting…' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
