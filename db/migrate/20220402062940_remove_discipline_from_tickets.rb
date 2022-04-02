class RemoveDisciplineFromTickets < ActiveRecord::Migration[7.0]
  def change
    remove_column :tickets, :discipline_id
  end
end
