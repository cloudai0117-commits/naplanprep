import { useQuery } from '@tanstack/react-query'
import apiClient from '@/api/client'

export default function AdminSettings() {
  const { data: contentStats } = useQuery({
    queryKey: ['content-stats'],
    queryFn: () => apiClient.get('/admin/content/stats').then((r) => r.data.data),
  })

  return (
    <div className="space-y-6">
      <div className="card">
        <h2 className="text-base font-semibold text-gray-800 mb-4">Content Statistics</h2>
        {contentStats && (
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center p-4 bg-green-50 rounded-lg">
              <div className="text-2xl font-bold text-green-600">{contentStats.totalPublished}</div>
              <div className="text-xs text-gray-500 mt-1">Published</div>
            </div>
            <div className="text-center p-4 bg-yellow-50 rounded-lg">
              <div className="text-2xl font-bold text-yellow-600">{contentStats.totalDraft}</div>
              <div className="text-xs text-gray-500 mt-1">Draft</div>
            </div>
            <div className="text-center p-4 bg-blue-50 rounded-lg">
              <div className="text-2xl font-bold text-blue-600">{contentStats.totalReview}</div>
              <div className="text-xs text-gray-500 mt-1">In Review</div>
            </div>
          </div>
        )}
      </div>

      <div className="card">
        <h2 className="text-base font-semibold text-gray-800 mb-4">Platform Configuration</h2>
        <div className="space-y-3 text-sm">
          <div className="flex justify-between py-2 border-b border-gray-100">
            <span className="text-gray-500">Stripe Mode</span>
            <span className="font-medium text-yellow-700">
              {import.meta.env.VITE_APP_ENV === 'production' ? '⚡ LIVE' : '🧪 TEST'}
            </span>
          </div>
          <div className="flex justify-between py-2 border-b border-gray-100">
            <span className="text-gray-500">Environment</span>
            <span className="font-medium">{import.meta.env.VITE_APP_ENV}</span>
          </div>
          <div className="flex justify-between py-2">
            <span className="text-gray-500">API URL</span>
            <span className="font-medium font-mono text-xs">{import.meta.env.VITE_API_URL}</span>
          </div>
        </div>
      </div>
    </div>
  )
}
