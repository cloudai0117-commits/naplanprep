import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { format } from 'date-fns'
import apiClient from '@/api/client'

export default function UserManagement() {
  const [search, setSearch] = useState('')
  const [page, setPage] = useState(0)
  const queryClient = useQueryClient()

  const { data, isLoading } = useQuery({
    queryKey: ['admin-users', search, page],
    queryFn: () =>
      apiClient.get(`/admin/users?search=${search}&page=${page}&size=20`).then((r) => r.data.data),
  })

  const { mutate: updateStatus } = useMutation({
    mutationFn: ({ id, status }: { id: string; status: string }) =>
      apiClient.put(`/admin/users/${id}/status`, { status }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-users'] }),
  })

  const users = data?.content || []
  const totalPages = data?.totalPages || 0

  return (
    <div className="space-y-4">
      <div className="flex items-center space-x-3">
        <input
          type="text"
          placeholder="Search by name or email..."
          value={search}
          onChange={(e) => { setSearch(e.target.value); setPage(0) }}
          className="input-field max-w-xs"
        />
        <span className="text-sm text-gray-500">{data?.totalElements || 0} users</span>
      </div>

      <div className="card p-0 overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-gray-500">Loading users...</div>
        ) : (
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="table-th">Name</th>
                <th className="table-th">Email</th>
                <th className="table-th">Role</th>
                <th className="table-th">Status</th>
                <th className="table-th">Joined</th>
                <th className="table-th">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {users.map((user: any) => (
                <tr key={user.id} className="hover:bg-gray-50">
                  <td className="table-td font-medium">
                    {user.profile?.firstName} {user.profile?.lastName}
                  </td>
                  <td className="table-td text-gray-600">{user.email}</td>
                  <td className="table-td">
                    <span className={`badge ${
                      user.role === 'PLATFORM_ADMIN' ? 'bg-red-100 text-red-800' :
                      user.role === 'TEACHER' ? 'bg-purple-100 text-purple-800' :
                      'bg-gray-100 text-gray-700'
                    }`}>
                      {user.role}
                    </span>
                  </td>
                  <td className="table-td">
                    <span className={`badge ${
                      user.status === 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                    }`}>
                      {user.status}
                    </span>
                  </td>
                  <td className="table-td text-gray-500">
                    {format(new Date(user.createdAt), 'dd MMM yyyy')}
                  </td>
                  <td className="table-td">
                    <button
                      onClick={() => updateStatus({
                        id: user.id,
                        status: user.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE',
                      })}
                      className={`text-xs font-medium ${
                        user.status === 'ACTIVE' ? 'text-red-600 hover:text-red-800' : 'text-green-600 hover:text-green-800'
                      }`}
                    >
                      {user.status === 'ACTIVE' ? 'Suspend' : 'Activate'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {totalPages > 1 && (
        <div className="flex justify-between items-center">
          <button
            onClick={() => setPage(Math.max(0, page - 1))}
            disabled={page === 0}
            className="btn-secondary"
          >
            Previous
          </button>
          <span className="text-sm text-gray-600">Page {page + 1} of {totalPages}</span>
          <button
            onClick={() => setPage(Math.min(totalPages - 1, page + 1))}
            disabled={page >= totalPages - 1}
            className="btn-secondary"
          >
            Next
          </button>
        </div>
      )}
    </div>
  )
}
