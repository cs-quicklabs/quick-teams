class ScheduleForm
  include ActiveModel::Model

  attr_accessor :starts_at, :ends_at, :user, :project, :occupancy

  validates_presence_of :user, :starts_at, :ends_at, :project, :occupancy

  def initialize(project, schedule)
    @schedule = schedule
    @project = project
  end

  def submit(params)
    self.starts_at = params[:starts_at]
    self.ends_at = params[:ends_at]
    self.occupancy = params[:occupancy]
    self.user = params[:user_id]

    if valid?
      @schedule.update(params)
      @schedule.project = @project
      @schedule.save!
      true
    else
      false
    end
  end

  def persisted?
    false
  end
end
