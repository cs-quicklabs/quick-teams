class AddColorToJobCards < ActiveRecord::Migration[8.1]
  def change
    add_column :job_cards, :color, :integer
  end
end
