class Survey::Attempt < ActiveRecord::Base
  self.table_name = "survey_attempts"

  # relations
  belongs_to :survey
  belongs_to :actor, class_name: "User", foreign_key: "actor_id"
  belongs_to :participant, polymorphic: true
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers,
    :reject_if => ->(q) { q[:question_id].blank? || q[:option_id].blank? }

  # validations
  validate :check_number_of_attempts_by_survey

  #scopes
  scope :wins, -> { where(:winner => true) }
  scope :looses, -> { where(:winner => false) }
  scope :scores, -> { order("score DESC") }
  scope :for_survey, ->(survey) { where(:survey_id => survey.id) }
  scope :exclude_survey, ->(survey) { where("NOT survey_id = #{survey.id}") }
  scope :for_participant, ->(participant) {
          where(:participant_id => participant.try(:id))
        }

  # callbacks
  before_create :collect_scores

  def correct_answers
    return self.answers.where(:correct => true)
  end

  def incorrect_answers
    return self.answers.where(:correct => false)
  end

  def self.high_score
    return scores.first.score
  end

  def submit
    self.score = calculate_score
  end

  def score
    submitted? ? super : calculate_score
  end

  def calculate_score
    score = 0
    if survey.checklist?
      score = correct_answers.count.times { score += 1 }
    else
      score = correct_answers.reduce(0.0) { |sum, answer| sum + answer.score }
      total = (answers.count * 10)
      unless total == 0
        percentage = (score / total) * 100.0
        score = percentage.round(2)
      end
    end
    score
  end

  private

  def check_number_of_attempts_by_survey
    attempts = self.class.for_survey(survey).for_participant(participant)
    upper_bound = self.survey.attempts_number

    if attempts.size >= upper_bound && upper_bound != 0
      errors.add(:survey_id, "Number of attempts exceeded")
    end
  end

  def collect_scores
    self.score = self.answers.map(&:value).reduce(:+) || 0
  end
end
