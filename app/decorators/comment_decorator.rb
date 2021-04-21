class CommentDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def author
    User.find(user_id).decorate
  end
end
