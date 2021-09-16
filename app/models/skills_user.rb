class SkillsUser < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  get_primary_key :id
end
