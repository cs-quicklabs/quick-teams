class Kb < ApplicationRecord
    belongs_to :user
  belongs_to :job
  belongs_to :discipline
  validates :link, :url => true
end
