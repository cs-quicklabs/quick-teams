class Survey::Stats::SurveyStats
  attr_accessor :stats, :survey, :question, :average_score, :contributions, :participant

  def initialize(survey)
    @survey = survey
  end

  def average_score
    total_score = 0
    total_marks = 0
    all_attempts.each do |attempt|
      score = attempt.correct_answers.reduce(0.0) { |sum, answer| sum + answer.score }
      total_score += score
      total = (attempt.answers.count * 10)
      total_marks += total
    end

    return 0 if total_marks == 0
    overall_average = (total_score / total_marks) * 10
    overall_average.round(2)
  end

  def stats_for(question)
    answers = Survey::Answer.where(attempt_id: all_attempts.ids, question: question)
    stats_for_answers(answers)
  end

  def stats_for_answers(answers)
    total_responses = answers.count
    average_score = 0.0
    if total_responses > 0
      average_score = answers.map(&:score).sum.to_f / total_responses
    end
    return total_responses, average_score
  end

  def contributions
    all_answers_ids = all_attempts.map(&:answers).flatten.map(&:id)
    all_answers = Survey::Answer.where(id: all_answers_ids)
    all_questions = Survey::Question.where(survey_id: survey_ids).order_by_category
    all_categories_ids = all_questions.map(&:question_category_id).uniq
    categories = Survey::QuestionCategory.where(id: all_categories_ids)

    contributions = []
    categories.each do |category|
      score = score(category, all_questions, all_answers)
      contribution = StatsContribution.new(category.name, score)
      contributions.push(contribution)
    end

    contributions
  end

  def all_attempts
    @survey.attempts
  end

  def survey_ids
    @survey.id
  end

  private

  def score(category, questions, answers)
    return 0 if answers.empty?

    category =
      category_question_answers = answers.where(question_id: questions.where(question_category: category).map(&:id))
    total_marks = category_question_answers.count * 10
    score = category_question_answers.reduce(0.0) do |sum, answer|
      sum + answer.score
    end

    return 0 if total_marks == 0
    overall_score = (score / total_marks) * 10
    overall_score.round(2)
  end
end

class StatsContribution
  def initialize(category, score)
    @category = category
    @score = score
  end

  def category
    @category
  end

  def score
    @score
  end

  def display_score
    "#{@score}"
  end
end
