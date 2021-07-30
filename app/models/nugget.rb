class Nugget < ApplicationRecord
    belongs_to :user
    belongs_to :skill
  has_rich_text :description
  

  validates_presence_of :title, :description

  scope :published, -> { where(published: true) }

end
