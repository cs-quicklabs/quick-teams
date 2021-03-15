class ScheduleForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :starts_at, :ends_at, :user, :project, :occupancy

  validates_presence_of :user, :starts_at, :ends_at, :project, :occupancy
  validates :occupancy, inclusion: { in: 0..100, message: "should be less than 100%" }
  validate :start_date_cannot_be_in_the_past, :end_date_cannot_be_before_start_date

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

  def start_date_cannot_be_in_the_past
    if starts_at.present? && starts_at < Date.today
      errors.add(:starts_at, "can't be in the past")
    end
  end

  def end_date_cannot_be_before_start_date
    return if ends_at.blank? || starts_at.blank?

    if ends_at < starts_at
      errors.add(:end_date, "cannot be before the start date") 
    end 
  end

  def persisted?
    false
  end
end
