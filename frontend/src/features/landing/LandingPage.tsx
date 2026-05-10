import { Link } from 'react-router-dom'

const features = [
  { icon: '📚', title: 'Full Question Bank', desc: 'Thousands of NAPLAN-style questions across all domains' },
  { icon: '⏱️', title: 'Timed Mock Exams', desc: 'Simulate the real exam experience with countdown timers' },
  { icon: '📊', title: 'Progress Analytics', desc: 'Track improvement with detailed charts and insights' },
  { icon: '🧠', title: 'Adaptive Learning', desc: 'Questions that adjust to your skill level automatically' },
  { icon: '👨‍👩‍👧', title: 'Parent Dashboard', desc: 'Monitor your child\'s progress in real time' },
  { icon: '🎯', title: 'NAPLAN Band Scores', desc: 'Instant band scores matching the official NAPLAN system' },
]

const plans = [
  {
    name: 'Free',
    price: '$0',
    period: '',
    features: ['1 diagnostic per year level', '10 questions/day', 'Basic progress tracking'],
    cta: 'Start Free',
    highlight: false,
  },
  {
    name: 'Standard',
    price: '$14.99',
    period: '/month',
    features: ['Full question bank', '12 mock exams/year', 'Progress tracking', 'All year levels'],
    cta: 'Start Standard',
    highlight: false,
  },
  {
    name: 'Premium',
    price: '$24.99',
    period: '/month',
    features: ['Adaptive learning', 'Unlimited mock exams', 'Parent dashboard', 'Detailed analytics', '7-day free trial'],
    cta: 'Start Premium',
    highlight: true,
  },
  {
    name: 'Family',
    price: '$34.99',
    period: '/month',
    features: ['Up to 4 children', 'All Premium features', 'Family progress overview', 'Priority support'],
    cta: 'Start Family',
    highlight: false,
  },
]

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white">
      <nav className="flex justify-between items-center px-6 py-4 max-w-7xl mx-auto">
        <span className="text-2xl font-bold text-primary-600">NAPLANPrep</span>
        <div className="flex space-x-4">
          <Link to="/login" className="btn-secondary py-2 px-4 text-sm">Sign in</Link>
          <Link to="/register" className="btn-primary py-2 px-4 text-sm">Get started</Link>
        </div>
      </nav>

      {/* Hero */}
      <section className="text-center py-24 px-6 bg-gradient-to-br from-primary-50 to-blue-50">
        <h1 className="text-5xl font-bold text-gray-900 mb-6">
          Ace Your NAPLAN with <span className="text-primary-600">Confidence</span>
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          The most comprehensive NAPLAN preparation platform for Australian students in Years 3, 5, 7, and 9.
          Adaptive practice, real exam simulations, and detailed analytics.
        </p>
        <div className="flex justify-center space-x-4">
          <Link to="/register" className="btn-primary py-3 px-8 text-lg">Start for Free</Link>
          <Link to="/pricing" className="btn-secondary py-3 px-8 text-lg">View Plans</Link>
        </div>
        <p className="mt-4 text-sm text-gray-500">No credit card required · 7-day free trial on Premium</p>
      </section>

      {/* Features */}
      <section className="py-20 px-6 max-w-7xl mx-auto">
        <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
          Everything you need to succeed
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((f) => (
            <div key={f.title} className="card hover:shadow-md transition-shadow">
              <div className="text-4xl mb-4">{f.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">{f.title}</h3>
              <p className="text-gray-600">{f.desc}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Pricing */}
      <section className="py-20 px-6 bg-gray-50">
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-4">
            Simple, transparent pricing
          </h2>
          <p className="text-center text-gray-600 mb-12">
            Cancel anytime. Annual plans save up to 15%.
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {plans.map((plan) => (
              <div
                key={plan.name}
                className={`card relative ${
                  plan.highlight
                    ? 'border-2 border-primary-500 shadow-md'
                    : ''
                }`}
              >
                {plan.highlight && (
                  <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-primary-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                    MOST POPULAR
                  </span>
                )}
                <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                <div className="mb-4">
                  <span className="text-3xl font-bold text-gray-900">{plan.price}</span>
                  <span className="text-gray-500">{plan.period}</span>
                </div>
                <ul className="space-y-2 mb-6">
                  {plan.features.map((f) => (
                    <li key={f} className="flex items-center text-sm text-gray-600">
                      <span className="text-green-500 mr-2">✓</span>
                      {f}
                    </li>
                  ))}
                </ul>
                <Link
                  to="/register"
                  className={`block text-center py-2 px-4 rounded-lg font-semibold text-sm transition-colors ${
                    plan.highlight
                      ? 'bg-primary-600 text-white hover:bg-primary-700'
                      : 'bg-gray-100 text-gray-800 hover:bg-gray-200'
                  }`}
                >
                  {plan.cta}
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 px-6 text-center bg-primary-600">
        <h2 className="text-3xl font-bold text-white mb-4">
          Ready to boost your NAPLAN score?
        </h2>
        <p className="text-primary-100 mb-8 text-lg">
          Join thousands of Australian students already preparing with NAPLANPrep.
        </p>
        <Link to="/register" className="bg-white text-primary-600 font-bold py-3 px-8 rounded-lg hover:bg-primary-50 transition-colors text-lg">
          Get Started Free
        </Link>
      </section>

      <footer className="py-8 px-6 text-center text-gray-500 text-sm">
        © 2024 NAPLANPrep. NAPLAN is a registered trademark of ACARA. NAPLANPrep is not affiliated with ACARA.
      </footer>
    </div>
  )
}
