class SignUp < Patterns::Service
  def initialize(account, user)
    @account = account
    @user = user
  end

  def call
    register
    set_stripe_subscription_trial
    user
  rescue StandardError
    user
  end

  private

  attr_reader :account, :user

  def register
    ActiveRecord::Base.transaction do
      create_account
      seed_database
      create_user
      update_account_with_owner
      seed_preferences
      seed_ticket_labels
    end
  end

  def create_account
    account.save!
  end

  def seed_database
    ActsAsTenant.with_tenant(account) do
      Discipline.create!([{ name: "Management" }, { name: "Design" }, { name: "HR" }, { name: "Development" }, { name: "Admin" }])
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
      user.permission = 2 # owner
      user.save!
    end
  end

  def update_account_with_owner
    ActsAsTenant.with_tenant(account) do
      account.update!(owner_id: user.id)
    end
  end

  def seed_preferences
    ActsAsTenant.with_tenant(account) do
      create_preference(
        key: "delete_deactivated_users_after_x_days",
        value: "1095",
        title: "Delete deactivated users after a specified time",
        message: "You can destroy old deactivated users automatically after a certain time. Please select time after which deactivated users can be deleted ",
      )
      create_preference(
        key: "delete_timesheets_after_x_days",
        value: "90",
        title: "Delete timesheets after a specific time duration",
        message: "The timesheets recorded will be deleted after below specified time. This helps to keep only those records which are needed. Please select time after which old timesheets can be deleted",
      )
      create_preference(
        key: "delete_archived_projects_after_x_days",
        value: "365",
        title: "Delete archived projects after a specified time",
        message: "You can destroy old archived projects automatically after a certain time. Please select time after which archived projects can be deleted ",
      )
      create_preference(
        key: "consider_overall_kpi_score",
        value: "true",
        title: "Consider overall KPI score when KPIs are changed",
        message: "When KPIs are changed for an employee, do you wish to consider previous KPIs in overall score or just the new KPIs score should be considered while calculating final score",
      )
      create_preference(
        key: "transfer_data_to_admin",
        value: User.find_by(account: account, permission: :admin).id,
        title: "Transfer data to admin on user delete",
        message: "When a user is deleted, you might want to keep some of the data like Report Templates. Whom do you wish to assign this data when the user is deleted",
      )
    end
  end

  def create_preference(key:, value:, title:, message:)
    Preference.create!(key: key, value: value, title: title, message: message)
  end

  def seed_ticket_labels
    ActsAsTenant.with_tenant(account) do
      TicketLabel.create!(name: "Other", user: user, discipline: Discipline.find_by(name: "Admin"))
    end
  end

  def set_stripe_subscription_trial
    trial_end_time = 14.days.from_now
    user.set_payment_processor :fake_processor, allow_fake: true
    user.payment_processor.subscribe(trial_ends_at: trial_end_time, ends_at: trial_end_time)
  end
end
