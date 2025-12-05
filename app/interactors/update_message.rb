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
    update_message
    send_emails
    message
  rescue StandardError
    message
  end

  private

  attr_reader :space, :message, :actor, :draft, :send_email, :params

  def update_message
    message.published = true if draft.nil?
    message.update!(params)
  end

  def send_emails
    return unless send_email.present? && draft.nil?

    recipients.each do |user|
      MessagesMailer.with(actor: actor, employee: user, message: message, space: space)
                    .update_message_email
                    .deliver_later
    end
  end

  def recipients
    (space.users - [actor]).select { |user| deliver_email?(user) }
  end

  def deliver_email?(employee)
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
