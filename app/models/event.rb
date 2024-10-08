class Event < ApplicationRecord
  ACTIONS = ["activated", "freed", "archived", "goal", "milestone", "todo", "plan", "created", "deactivated", "event", "feedback", "noted", "reviewed", "scheduled", "unarchived", "project_created", "document", "risk", "report", "attempt", "observer", "observer_removed"].freeze

  acts_as_tenant :account

  belongs_to :user
  belongs_to :eventable, polymorphic: true
  belongs_to :trackable, polymorphic: true

  validates_presence_of :eventable, :trackable, :user
  validates :action, inclusion: { in: ACTIONS }
end
