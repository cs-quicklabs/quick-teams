class AddConfirmableToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
    end

    User.all.each do |user|
      user.confirmed_at = Time.now.utc
      user.save!
    end
  end
end
