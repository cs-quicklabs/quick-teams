class Schedule < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :project, touch: true
end
