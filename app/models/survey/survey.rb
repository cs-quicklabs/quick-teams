class Survey::Survey < ActiveRecord::Base
  acts_as_tenant :account

  self.table_name = "survey_surveys"

  enum survey_type: [:checklist, :score, :kpi]
  enum survey_for: [:project, :user, :client]
  belongs_to :actor, class_name: "User"

  # relations
  has_many :attempts, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :users
  has_many :projects
  accepts_nested_attributes_for :questions,
    :reject_if => ->(q) { q[:text].blank? },
    :allow_destroy => true

  # scopes
  scope :active, -> { where(:active => true) }
  scope :inactive, -> { where(:active => false) }
  scope :surveys, -> { where(survey_type: [:checklist, :score]) }
  scope :kpis, -> { where(survey_type: :kpi) }

  # validations
  validates :attempts_number, :numericality => { :only_integer => true, :greater_than => -1 }
  validates :description, :name, :presence => true, :allow_blank => false
  validate :check_active_requirements

  # returns all the correct options for current surveys
  def correct_options
    return self.questions.map(&:correct_options).flatten
  end

  # returns all the incorrect options for current surveys
  def incorrect_options
    return self.questions.map(&:incorrect_options).flatten
  end

  def available_for_participant?(participant)
    current_number_of_attempts = self.attempts.for_participant(participant).size
    upper_bound = self.attempts_number
    return !((current_number_of_attempts >= upper_bound) && (upper_bound != 0))
  end

  def clone_for_actor(actor)
    clone = Survey::Survey.new
    clone.name = self.name + " (Copy)"
    clone.survey_type = self.survey_type
    clone.survey_for = self.survey_for
    clone.actor_id = actor.id
    clone.description = self.description.nil? ? "N/A" : self.description
    clone.save

    self.questions.each do |question|
      q = Survey::Question.new(text: question.text, description: question.description, survey_id: clone.id, question_category_id: question.question_category_id, explanation: question.explanation)
      q.save

      if self.checklist? #checklist
        Survey::Option.new(text: "Yes", question: q, correct: true, weight: 1).save
        Survey::Option.new(text: "No", question: q, correct: false, weight: 0).save
      else
        Survey::Option.new(text: "Score", question: q, correct: true, weight: 10).save
      end
    end

    clone
  end

  private

  # a surveys only can be activated if has one or more questions
  def check_active_requirements
    errors.add(:active, "Survey without questions cannot be activated") if self.active && self.questions.empty?
  end
end
