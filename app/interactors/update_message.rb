class UpdateMessage < Patterns::Service
  def initialize(space, message, actor, draft, send_email, params)
    @space = space
    @message = message
    @actor = actor
    @draft = draft
    @send_email = send_email
    @params = params
  end

  def call
    begin
      update_message
      email
    rescue
      message
    end
    message
  end

  def update_message
    if draft.nil?
      message.published = true
    end
    message.update(params)
  end

  def email
    return unless !send_email.nil?
    (space.users - actor).each do |user|
      if deliver_email?(user)
        MessagesMailer.with(actor: actor, employee: user, message: message).update_message_email.deliver_later
      end
    end
  end

  def deliver_email?(employee)
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :space, :message, :actor, :draft, :send_email, :params
end
