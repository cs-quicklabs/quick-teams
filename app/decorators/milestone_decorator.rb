class MilestoneDecorator < Draper::Decorator
  delegate_all
  decorates_association :comment

  def author
    User.find(user_id).decorate
  end
end
