class NuggetFilter
  include ActiveModel::Model

  KEYS = %i[
    user_id
    published
    skill_id
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end
end
