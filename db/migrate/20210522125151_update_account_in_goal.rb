class UpdateAccountInGoal < ActiveRecord::Migration[6.1]
  def change
    ActsAsTenant.without_tenant do
      Goal.all.update_all(account_id: 1)
    end
    change_column_null :goals, :account_id, false
  end
end
