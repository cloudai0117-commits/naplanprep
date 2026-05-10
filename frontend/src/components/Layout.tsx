import { Outlet, Link, useNavigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '@/store/authStore'
import apiClient from '@/api/client'

const navItems = [
  { path: '/dashboard', label: 'Dashboard' },
  { path: '/exams', label: 'Practice' },
  { path: '/history', label: 'History' },
  { path: '/pricing', label: 'Pricing' },
]

export default function Layout() {
  const { user, logout } = useAuthStore()
  const navigate = useNavigate()
  const location = useLocation()

  const handleLogout = async () => {
    try {
      await apiClient.post('/auth/logout')
    } finally {
      logout()
      navigate('/login')
    }
  }

  return (
    <div className="min-h-screen flex flex-col">
      <nav className="bg-white border-b border-gray-200 sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-8">
              <Link to="/dashboard" className="text-xl font-bold text-primary-600">
                NAPLANPrep
              </Link>
              <div className="hidden md:flex space-x-4">
                {navItems.map((item) => (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                      location.pathname === item.path
                        ? 'bg-primary-50 text-primary-700'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    {item.label}
                  </Link>
                ))}
                {user?.role === 'PARENT' && (
                  <Link
                    to="/parent"
                    className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                      location.pathname === '/parent'
                        ? 'bg-primary-50 text-primary-700'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    Children
                  </Link>
                )}
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <Link
                to="/settings"
                className="text-sm text-gray-600 hover:text-gray-900 font-medium"
              >
                {user?.firstName || user?.email}
              </Link>
              <button
                onClick={handleLogout}
                className="btn-secondary text-sm py-1.5 px-3"
              >
                Sign out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8">
        <Outlet />
      </main>

      <footer className="bg-white border-t border-gray-200 py-4 text-center text-sm text-gray-500">
        © 2024 NAPLANPrep. All rights reserved.
      </footer>
    </div>
  )
}
