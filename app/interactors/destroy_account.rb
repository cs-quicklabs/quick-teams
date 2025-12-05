class DestroyAccount < Patterns::Service
  def initialize(ids)
    @accounts = Account.where(id: ids)
  end

  def call
    accounts.each do |account|
      destroy_account(account)
    end
    true
  rescue StandardError => e
    e
  end

  private

  attr_reader :accounts

  def destroy_account(account)
    ActsAsTenant.current_tenant = account
    account.update!(owner: nil)
    account.projects.destroy_all
    account.users.destroy_all
    account.destroy!
  end
end
