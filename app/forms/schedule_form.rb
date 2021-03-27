class ScheduleForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :starts_at, :ends_at, :user, :project, :occupancy

  def initialize(project, schedule, actor)
    @schedule = schedule
    @project = project
    @actor = actor
  end

  def submit(params)
    self.starts_at = params[:starts_at].to_date
    self.ends_at = params[:ends_at].to_date
    self.occupancy = params[:occupancy].to_i
    self.user = params[:user_id]

    if valid?
      update_schedule
    else
      false
    end
  end

  def update_schedule
    UpdateSchedule.call(@schedule, @project, User.find(self.user), params, @actor)
  end

  def persisted?
    false
  end
end
