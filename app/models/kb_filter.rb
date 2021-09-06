class KbFilter
    include ActiveModel::Model
  
    KEYS = %i[
      discipline_id
      user_id
      job_id
    ].freeze
  
    attr_accessor(*KEYS)
  
    def initialize(params = {})
      params = params&.slice(*KEYS)
      super(params)
    end
  end
  