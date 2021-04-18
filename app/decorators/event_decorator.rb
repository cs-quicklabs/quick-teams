class EventDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :eventable
  decorates_association :trackable
end
