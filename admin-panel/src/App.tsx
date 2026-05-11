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
import ExamList from '@/features/exams/ExamList'
import ExamForm from '@/features/exams/ExamForm'
import ExamQuestions from '@/features/exams/ExamQuestions'
import ExamResults from '@/features/exams/ExamResults'

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
            <Route path="/exams" element={<ExamList />} />
            <Route path="/exams/new" element={<ExamForm />} />
            <Route path="/exams/:examId/edit" element={<ExamForm />} />
            <Route path="/exams/:examId/questions" element={<ExamQuestions />} />
            <Route path="/exams/:examId/results" element={<ExamResults />} />
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
