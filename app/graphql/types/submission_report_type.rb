module Types
  class SubmissionReportType < Types::BaseObject
    field :id, ID, null: false
    field :status, Types::SubmissionReportStatusType, null: false
    field :conclusion, Types::SubmissionReportConclusionType, null: true
    field :test_report, String, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: true
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end