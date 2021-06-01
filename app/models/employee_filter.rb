# frozen_string_literal: true

class EmployeeFilter
  include ActiveModel::Model

  KEYS = %i[
    manager_id
    status
    tag
    permission
    billable
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end
end
