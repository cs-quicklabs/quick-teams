class ProjectKpisStats
  attr_accessor :stats, :project, :kpi, :average_score, :contributions

  def initialize(project, kpi)
    @project = project
    @kpi = kpi
  end

  def average_score
    attempts = @kpi.attempts.where(participant_id: @project.id, participant_type: "Project")
    total_score = 0
    total_marks = 0
    attempts.each do |attempt|
      score = attempt.correct_answers.reduce(0.0) { |sum, answer| sum + answer.score }
      total_score += score
      total = (attempt.answers.count * 10)
      total_marks += total
    end

    return 0 if total_marks == 0
    overall_average = (total_score / total_marks) * 10
    overall_average.round(2)
  end

  def contributions
    attempts = @kpi.attempts.where(participant_id: @project.id, participant_type: "Project")
    all_answers_ids = attempts.map(&:answers).flatten.map(&:id)
    all_answers = Survey::Answer.where(id: all_answers_ids)
    all_questions = Survey::Question.where(survey_id: @kpi.id)
    categories = all_questions.map(&:category).uniq

    contributions = []
    categories.each do |category|
      score = score(category, all_questions, all_answers)
      contribution = StatsContribution.new(category, score)
      contributions.push(contribution)
    end

    contributions
  end

  def score(category, questions, answers)
    return 0 if answers.empty?
    category_question_answers = answers.where(question_id: questions.where(category: category).map(&:id))
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
