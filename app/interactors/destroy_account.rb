class DestroyAccount < Patterns::Service
  def initialize(ids)
    @accounts = Account.where(id: ids)
  end

  def call
    begin
      accounts.each do |account|
        ActsAsTenant.current_tenant = account
        account.owner = nil
        account.save!
        delete_projects(account)
        delete_users(account)
        account.destroy
      end
    rescue Exception => e
      return e
    end
    true
  end

  private

  def delete_projects(account)
    account.projects.destroy_all
  end

  def delete_users(account)
    User.where(account_id: account.id).destroy_all
  end

  attr_reader :accounts
end
