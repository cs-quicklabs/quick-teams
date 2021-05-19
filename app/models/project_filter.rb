# frozen_string_literal: true

class ProjectFilter
  include ActiveModel::Model

  KEYS = %i[
    manager_id
    status
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end
end
