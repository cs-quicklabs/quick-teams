class Nugget < ApplicationRecord
    belongs_to :user
    belongs_to :skill
  has_rich_text :body
  

  validates_presence_of :title , :body

  scope :published, -> { where(published: true) }

end
