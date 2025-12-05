class AddSpace < Patterns::Service
  def initialize(space_params, actor, users)
    @space = Space.new(space_params)
    @actor = actor
    @users = users
  end

  def call
    create_space
    add_space_users
    send_emails
    space
  rescue StandardError
    space
  end

  private

  attr_reader :space, :actor, :users

  def create_space
    space.save!
  end

  def add_space_users
    space.users << User.where(id: users)
    space.users << actor unless space.users.include?(actor)
  end

  def send_emails
    return if users.empty?

    recipients.each do |user|
      SpacesMailer.with(actor: actor, employee: user, space: space)
                  .space_email
                  .deliver_later
    end
  end

  def recipients
    User.where(id: users).select { |user| deliver_email?(user) }
  end

  def deliver_email?(employee)
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
