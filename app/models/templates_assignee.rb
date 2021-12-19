class TemplatesAssignee < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :template
end
