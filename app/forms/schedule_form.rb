class ScheduleForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :starts_at, :ends_at, :user, :project, :occupancy

  validates_presence_of :user, :starts_at, :ends_at, :project, :occupancy
  validates_numericality_of :occupancy

  validates :occupancy, inclusion: { in: 0..100, message: "should be less than 100%" }
  validate :end_date_cannot_be_in_the_past

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
      UpdateSchedule.call(@schedule, @project, User.find(self.user), params, @actor)
      true
    else
      false
    end
  end
 
  def end_date_cannot_be_in_the_past
    return if ends_at.blank? || starts_at.blank?

    if ends_at < starts_at
      errors.add(:ends_at, "cannot be before the start date")
    end
  end

  def persisted?
    false
  end
end
