class BackfillSubscriptions < ActiveRecord::Migration[7.0]
  def change
    accounts = Account.all
    accounts.each do |account|
      user = account.owner
      time = 14.days.from_now
      user.set_payment_processor :fake_processor, allow_fake: true
      user.payment_processor.subscribe(trial_ends_at: time, ends_at: time)
    end
  end
end
