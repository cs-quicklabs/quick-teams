class SignUp < Patterns::Service
  def initialize(account_parmas, user_params)
    @account = Account.new(account_parmas)
    @user = User.new(user_parmas)
  end

  def call
    begin
      create_account_and_user
    rescue
      false
    end
    true
  end

  private

  def create_account_and_user
    ActiveRecord::Base.transaction do
      account = account.save!
      user.account = account
      user.save!
    end
  end

  attr_reader :account, :user
end
