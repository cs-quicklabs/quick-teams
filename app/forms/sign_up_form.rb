class SignUpForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :email, :company, :new_password, :new_password_confirmation, :account, :user

  validates_presence_of :first_name, :last_name, :email, :company, :new_password, :new_password_confirmation
  validates_presence_of :new_password, :new_password_confirmation
  validates_confirmation_of :new_password
  validates :new_password, not_pwned: true
  validates_length_of :new_password, minimum: 6

  def initialize(*)
    super
  end

  def submit(account_parmas, user_params)
    @user = User.new(user_params)
    @account = Account.new(account_parmas)

    if valid?
      SignUp.call(account_parmas, user_params).result
    else
      false
    end
  end

  def validate_children
    promote_errors(user) if user.invalid?

    promote_errors(account) if account.invalid?
  end

  def promote_errors(child)
    binding.irb
    child.errors.each do |error|
      errors.add(error)
    end
  end

  def persisted?
    false
  end
end
