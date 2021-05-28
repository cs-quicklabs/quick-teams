class TodoDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :owner
end
