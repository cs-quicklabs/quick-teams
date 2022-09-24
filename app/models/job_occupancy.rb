class JobOccupancy < Occupancy
  attr_accessor :job

  def initialize(job)
    @job = job
  end

  def self.occupancy_for_job(job)
    users = User.active.where(job: job, billable: true)
    occupancy_for_users(users)
  end
end
