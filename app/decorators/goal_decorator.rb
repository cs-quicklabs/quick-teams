class GoalDecorator < Draper::Decorator
  delegate_all
  decorates_association :comment
  decorates_association :user
end
