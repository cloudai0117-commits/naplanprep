import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useAuthStore } from '@/store/authStore'
import Layout from '@/components/Layout'
import ProtectedRoute from '@/components/ProtectedRoute'

import LandingPage from '@/features/landing/LandingPage'
import LoginPage from '@/features/auth/pages/LoginPage'
import RegisterPage from '@/features/auth/pages/RegisterPage'
import Dashboard from '@/features/dashboard/Dashboard'
import ExamSelection from '@/features/exam/ExamSelection'
import ExamPlayer from '@/features/exam/ExamPlayer'
import ResultsPage from '@/features/exam/ResultsPage'
import ExamHistory from '@/features/exam/ExamHistory'
import ExamInstructionsPage from '@/features/exam/ExamInstructionsPage'
import ExamResultsDetailPage from '@/features/exam/ExamResultsDetailPage'
import PricingPage from '@/features/subscription/PricingPage'
import ParentDashboard from '@/features/parent/ParentDashboard'
import ProfileSettings from '@/features/profile/ProfileSettings'
import SchoolsPage from '@/features/admin/SchoolsPage'
import ResetPasswordPage from '@/features/auth/pages/ResetPasswordPage'

function App() {
  const { isAuthenticated } = useAuthStore()

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route
          path="/login"
          element={isAuthenticated ? <Navigate to="/dashboard" replace /> : <LoginPage />}
        />
        <Route
          path="/register"
          element={isAuthenticated ? <Navigate to="/dashboard" replace /> : <RegisterPage />}
        />

        <Route path="/reset-password" element={<ResetPasswordPage />} />

        <Route element={<Layout />}>
          <Route path="/pricing" element={<PricingPage />} />
        </Route>

        <Route element={<ProtectedRoute />}>
          <Route element={<Layout />}>
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/exams" element={<ExamSelection />} />
            <Route path="/exams/:examId" element={<ExamInstructionsPage />} />
            <Route path="/exams/:examId/results/:sessionId" element={<ExamResultsDetailPage />} />
            <Route path="/exams/:sessionId/play" element={<ExamPlayer />} />
            <Route path="/exams/:sessionId/results" element={<ResultsPage />} />
            <Route path="/history" element={<ExamHistory />} />
            <Route path="/parent" element={<ParentDashboard />} />
            <Route path="/settings" element={<ProfileSettings />} />
            <Route path="/admin/schools" element={<SchoolsPage />} />
          </Route>
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
