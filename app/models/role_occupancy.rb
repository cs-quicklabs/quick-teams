class RoleOccupancy < Occupancy
  attr_accessor :role

  def initialize(role)
    @role = role
  end

  def self.occupancy_for_role(role)
    users = User.active.where(role: role, billable: true)
    occupancy_for_users(users)
  end
end
