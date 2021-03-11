class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :project, touch: true
end
