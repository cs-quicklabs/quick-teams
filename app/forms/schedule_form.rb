class ScheduleForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :starts_at, :ends_at, :user, :project, :occupancy

  validates_presence_of :user, :starts_at, :ends_at, :project, :occupancy
  validates :starts_at, date: { before: :ends_at }
  validates :ends_at, date: true
  validates :occupancy, inclusion: { in: 0..100, message: "should be less than 100%" }

  def initialize(project, schedule)
    @schedule = schedule
    @project = project
  end

  def submit(params)
    self.starts_at = params[:starts_at].to_date
    self.ends_at = params[:ends_at].to_date
    self.occupancy = params[:occupancy].to_i
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
