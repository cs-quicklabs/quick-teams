class ReportFilter
  include ActiveModel::Model

  KEYS = %i[
    project_id
    user_id
    submitted
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end
end
