import { Outlet, Link, useLocation, useNavigate } from 'react-router-dom'
import { useAdminStore } from '@/store/adminStore'
import apiClient from '@/api/client'

const navItems = [
  { path: '/dashboard', label: 'Dashboard', icon: '📊' },
  { path: '/users', label: 'Users', icon: '👥' },
  { path: '/schools', label: 'Schools', icon: '🏫' },
  { path: '/questions', label: 'Question Bank', icon: '📚' },
  { path: '/exams', label: 'Exams', icon: '📝' },
  { path: '/subscriptions', label: 'Subscriptions', icon: '💳' },
  { path: '/audit', label: 'Audit Log', icon: '🔍' },
  { path: '/settings', label: 'Settings', icon: '⚙️' },
]

export default function AdminLayout() {
  const { user, logout } = useAdminStore()
  const location = useLocation()
  const navigate = useNavigate()

  const handleLogout = async () => {
    try { await apiClient.post('/auth/logout') } finally {
      logout()
      navigate('/login')
    }
  }

  return (
    <div className="min-h-screen flex">
      {/* Sidebar */}
      <div className="w-56 bg-gray-900 flex flex-col">
        <div className="p-4 border-b border-gray-700">
          <span className="text-white font-bold text-lg">NAPLANPrep</span>
          <div className="text-gray-400 text-xs mt-0.5">Admin Panel</div>
        </div>

        <nav className="flex-1 p-3 space-y-1">
          {navItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              className={`flex items-center space-x-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                location.pathname === item.path
                  ? 'bg-primary-600 text-white'
                  : 'text-gray-300 hover:bg-gray-800 hover:text-white'
              }`}
            >
              <span>{item.icon}</span>
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>

        <div className="p-3 border-t border-gray-700">
          <div className="text-gray-400 text-xs mb-2 px-2">{user?.email}</div>
          <button
            onClick={handleLogout}
            className="w-full text-left text-gray-300 hover:text-white text-sm px-3 py-2 rounded hover:bg-gray-800 transition-colors"
          >
            Sign out
          </button>
        </div>
      </div>

      {/* Main */}
      <div className="flex-1 flex flex-col overflow-hidden">
        <div className="bg-white border-b border-gray-200 px-6 py-3 flex items-center justify-between">
          <h1 className="text-base font-semibold text-gray-800">
            {navItems.find((n) => location.pathname === n.path || location.pathname.startsWith(n.path + '/'))?.label || 'Admin'}
          </h1>
          <span className="text-xs text-gray-500">PLATFORM_ADMIN</span>
        </div>
        <main className="flex-1 overflow-y-auto p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
