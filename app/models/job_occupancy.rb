class JobOccupancy
  attr_accessor :job

  def initialize(job)
    @job = job
  end

  def self.occupancy_for_job(job)
    users = User.active.where(job: job)
    occupancy_for_users(users)
  end

  def self.occupancy_for_account(account)
    users = User.active.where(account: account)
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
