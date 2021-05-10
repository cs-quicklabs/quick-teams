# frozen_string_literal: true

class GoalFilter
  include ActiveModel::Model

  KEYS = %i[
    created_by
    created_for
    from_date
    to_date
    status
    type
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end
end
