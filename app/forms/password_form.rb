class PasswordForm
  include ActiveModel::Model
  # extend ActiveModel::Naming
  # include ActiveModel::Conversion
  # include ActiveModel::Validations

  # Add all validations you need
  validates_presence_of :password, :new_password, :confirm_new_password
  validates_confirmation_of :new_password
  validate :verify_old_password

  attr_accessor :password, :new_password, :confirm_new_password

  def initialize(user)
    @user = user
  end

  def submit(params)
    # binding.irb
    self.password = params[:password]
    self.new_password = params[:new_password]
    self.confirm_new_password = params[:confirm_new_password]

    if valid?
      @user.new_password = new_password
      @user.confirm_new_password = new_password
      @user.save!
      true
    else
      false
    end
  end

  def verify_old_password
    unless @user.valid_password?(password)
      errors.add :password, "is not correct"
    end  
  end

    # def change_password
    #   @user.new_password = new_password
    # end

  # This method is required
  def persisted?
    false
  end
end