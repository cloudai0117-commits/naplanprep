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
import PricingPage from '@/features/subscription/PricingPage'
import ParentDashboard from '@/features/parent/ParentDashboard'
import ProfileSettings from '@/features/profile/ProfileSettings'

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

        <Route element={<ProtectedRoute />}>
          <Route element={<Layout />}>
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/exams" element={<ExamSelection />} />
            <Route path="/exams/:sessionId/play" element={<ExamPlayer />} />
            <Route path="/exams/:sessionId/results" element={<ResultsPage />} />
            <Route path="/history" element={<ExamHistory />} />
            <Route path="/pricing" element={<PricingPage />} />
            <Route path="/parent" element={<ParentDashboard />} />
            <Route path="/settings" element={<ProfileSettings />} />
          </Route>
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
