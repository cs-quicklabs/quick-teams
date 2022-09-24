class Occupancy
  attr_accessor :account

  def self.occupancy_for_account(account)
    users = User.active.where(account: account, billable: true)
    occupancy_for_users(users)
  end

  def self.occupancy_for_users(users)
    users = users.includes({ schedules: :project }).decorate
    return 0 if users.empty?

    occupancy = 0.0
    users.each do |user|
      occupancy += user.overall_occupancy
    end
    occupancy = occupancy / users.count
    occupancy.round(2)
  end
end
