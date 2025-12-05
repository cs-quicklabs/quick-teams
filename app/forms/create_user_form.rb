class CreateUserForm
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email, :discipline, :job, :role, :manager

  validates :first_name, :last_name, :email, :discipline, :job, :role, :manager, presence: true

  def initialize(account, actor)
    @account = account
    @actor = actor
  end

  def submit(params, invite)
    assign_attributes_from(params)

    return self unless valid?

    CreateUser.call(params, actor, account, invite).result
  end

  def persisted?
    false
  end

  private

  attr_reader :account, :actor

  def assign_attributes_from(params)
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.email = params[:email]
    self.discipline = params[:discipline_id]
    self.job = params[:job_id]
    self.role = params[:role_id]
    self.manager = params[:manager_id]
  end
end
