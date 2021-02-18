class PasswordForm
  include ActiveModel::Model
  # extend ActiveModel::Naming
  # include ActiveModel::Conversion
  # include ActiveModel::Validations

  # Add all validations you need
  validates_presence_of :old_password, :new_password, :confirm_new_password
  validates_confirmation_of :new_password
  validate :verify_old_password

  attr_accessor :old_password, :new_password, :confirm_new_password

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.old_password = params[:old_pasword]
    self.new_password = params[:new_password]
    self.confirm_new_password = params[:confirm_new_password]

    if valid?
      @user.new_password = new_password
      @user.confirm_new_password = confirm_new_password
      @user.save!
      true
    else
      false
    end
  end

  def verify_old_password
    self.errors << "Not valid" if @user.new_password != new_password
  end

  def change_password
    @user.new_password = new_password
  end

  # This method is required
  # def persisted?
  #   false
  # end
end