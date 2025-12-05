class UnarchiveSpace < Patterns::Service
  def initialize(space, actor)
    @space = space
    @actor = actor
  end

  def call
    unarchive_space
    send_emails
    space
  rescue StandardError
    space
  end

  private

  attr_reader :space, :actor

  def unarchive_space
    space.update!(archive: false, archive_at: nil)
  end

  def send_emails
    recipients.each do |user|
      SpacesMailer.with(space: space, employee: user, actor: actor)
                  .unarchived_email
                  .deliver_later
    end
  end

  def recipients
    (space.users - [actor]).select { |user| deliver_email?(user) }
  end

  def deliver_email?(employee)
    employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end
end
