export default function AuditLog() {
  return (
    <div className="space-y-4">
      <p className="text-gray-600 text-sm">
        Security events including login attempts, admin actions, and data access are logged to the audit_logs table.
        Full audit log viewer with search and export coming in v1.1.
      </p>
      <div className="card">
        <div className="text-center py-8 text-gray-400">
          <div className="text-4xl mb-3">🔍</div>
          <div className="font-medium">Audit Log UI</div>
          <div className="text-sm mt-1">Login events and admin actions are persisted to the database</div>
        </div>
      </div>
    </div>
  )
}
