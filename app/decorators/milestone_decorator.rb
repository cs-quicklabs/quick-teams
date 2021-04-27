class MilestoneDecorator < Draper::Decorator
  delegate_all
  decorates_association :comment
end
