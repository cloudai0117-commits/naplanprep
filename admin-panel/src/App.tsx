import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useAdminStore } from '@/store/adminStore'
import AdminLayout from '@/components/AdminLayout'
import ProtectedAdminRoute from '@/components/ProtectedAdminRoute'

import AdminLogin from '@/features/auth/AdminLogin'
import AdminDashboard from '@/features/dashboard/AdminDashboard'
import UserManagement from '@/features/users/UserManagement'
import QuestionBank from '@/features/questions/QuestionBank'
import SubscriptionManagement from '@/features/subscriptions/SubscriptionManagement'
import AuditLog from '@/features/audit/AuditLog'
import AdminSettings from '@/features/settings/AdminSettings'

function App() {
  const { isAuthenticated } = useAdminStore()

  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/login"
          element={isAuthenticated ? <Navigate to="/dashboard" replace /> : <AdminLogin />}
        />

        <Route element={<ProtectedAdminRoute />}>
          <Route element={<AdminLayout />}>
            <Route path="/dashboard" element={<AdminDashboard />} />
            <Route path="/users" element={<UserManagement />} />
            <Route path="/questions" element={<QuestionBank />} />
            <Route path="/subscriptions" element={<SubscriptionManagement />} />
            <Route path="/audit" element={<AuditLog />} />
            <Route path="/settings" element={<AdminSettings />} />
          </Route>
        </Route>

        <Route path="/" element={<Navigate to="/dashboard" replace />} />
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
