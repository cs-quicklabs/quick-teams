class Kb < ApplicationRecord
    belongs_to :user
  belongs_to :job
  belongs_to :discipline
  validates :link, :url => true
 
  def self.query(params, includes = nil, order)
    return [] if params.empty?
    KbQuery.new(self.includes(includes), params, order).filter
  end
end
