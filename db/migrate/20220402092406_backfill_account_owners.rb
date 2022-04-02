class BackfillAccountOwners < ActiveRecord::Migration[7.0]
  def change
    accounts = Account.all
    accounts.each do |account|
      owner = User.where(account: account, permission: :admin).first
      account.update(owner_id: owner.id)
    end
  end
end
