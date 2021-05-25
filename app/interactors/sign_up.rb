class SignUp < Patterns::Service
  def initialize(account, user)
    @account = account
    @user = user
  end

  def call
    begin
      register
    rescue
      user
    end
    user
  end

  private

  def register
    ActiveRecord::Base.transaction do
      create_account
      seed_database
      create_user
    end
  end

  def create_account
    account.save!
  end

  def seed_database
    now = Time.now
    ActsAsTenant.with_tenant(account) do
      Discipline.create!([{ name: "Management" }, { name: "Design" }, { name: "HR" }, { name: "Development" }])
      Job.create!([{ name: "Admin" }, { name: "UI/UX Designer" }, { name: "Android Developer" }, { name: "Web Developer" }, { name: "HR Executive" }])
      Role.create!([{ name: "Super" }, { name: "Senior" }, { name: "Junior" }])
    end
  end

  def create_user
    ActsAsTenant.with_tenant(account) do
      user.account = account
      user.role = Role.first
      user.discipline = Discipline.first
      user.job = Job.first
      user.permission = 2 #admin
      user.save!
    end
  end

  attr_reader :account, :user
end
