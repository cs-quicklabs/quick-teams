class ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :original_password, :new_password, :new_password_confirmation

  validates :original_password, :new_password, :new_password_confirmation, presence: true
  validates :new_password, confirmation: true, length: { minimum: 6 }, not_pwned: true
  validate :verify_old_password

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.original_password = params[:original_password]
    self.new_password = params[:new_password]
    self.new_password_confirmation = params[:new_password_confirmation]

    return false unless valid?

    update_user_password
    true
  end

  def persisted?
    false
  end

  private

  attr_reader :user

  def verify_old_password
    return if user.valid_password?(original_password)

    errors.add(:original_password, "is not correct")
  end

  def update_user_password
    user.password = new_password
    user.password_confirmation = new_password
    user.save!
  end
end
