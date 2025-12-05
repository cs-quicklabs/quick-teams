class SignUpForm
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email, :company, :new_password, :new_password_confirmation

  validates :first_name, :last_name, :email, :company, :new_password, :new_password_confirmation, presence: true
  validates :new_password, length: { minimum: 6 }, not_pwned: true
  validate :validate_children

  def submit(registration_params)
    build_children(registration_params)

    return nil unless valid?

    SignUp.call(account, user).result
  end

  def persisted?
    false
  end

  private

  attr_reader :account, :user

  def build_children(registration_params)
    assign_attributes_from(registration_params)
    build_user
    build_account
  end

  def assign_attributes_from(params)
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.email = params[:email]
    self.new_password = params[:new_password]
    self.new_password_confirmation = params[:new_password_confirmation]
    self.company = params[:company]
  end

  def build_user
    @user = User.new(
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: new_password,
      password_confirmation: new_password_confirmation,
    )
  end

  def build_account
    @account = Account.new(name: company, owner_id: user.id)
  end

  def validate_children
    promote_errors(user) if user&.invalid?
    promote_errors(account) if account&.invalid?
  end

  def promote_errors(child)
    child.errors.each do |error|
      next unless error.attribute == :email && email_error_not_present?

      errors.errors.append(error)
    end
  end

  def email_error_not_present?
    errors.none? { |error| error.attribute == :email }
  end
end
