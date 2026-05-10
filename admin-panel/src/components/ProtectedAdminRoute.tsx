import { Navigate, Outlet } from 'react-router-dom'
import { useAdminStore } from '@/store/adminStore'

export default function ProtectedAdminRoute() {
  const { isAuthenticated, user } = useAdminStore()

  if (!isAuthenticated || user?.role !== 'PLATFORM_ADMIN') {
    return <Navigate to="/login" replace />
  }

  return <Outlet />
}
