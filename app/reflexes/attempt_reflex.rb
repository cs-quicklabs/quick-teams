# frozen_string_literal: true

class AttemptReflex < ApplicationReflex
  def answer
    attempt, question, option = records
    answer = find_or_create_answer(attempt, question, option: option, correct: option.correct)
    answer.update(option_id: element.dataset[:option_id], correct: option.correct)

    morph dom_id(question), render(partial: "survey/attempts/checklist_question", locals: { attempt: attempt, question: question, option: option })
  end

  def score
    attempt, question, option = records
    answer = find_or_create_answer(attempt, question, option: option, correct: true, score: element.dataset[:score].to_i)
    answer.update(score: element.dataset[:score].to_i)

    morph dom_id(question), render(partial: "survey/attempts/score_question", locals: { attempt: attempt, question: question, option: option })
  end

  private

  def records
    attempt = Survey::Attempt.find(element.dataset[:attempt_id])
    question = Survey::Question.find(element.dataset[:question_id])
    option = Survey::Option.find(element.dataset[:option_id])
    [attempt, question, option]
  end

  def find_or_create_answer(attempt, question, **attributes)
    Survey::Answer.find_or_create_by(attempt: attempt, question: question, option: attributes[:option]) do |answer|
      answer.assign_attributes(attributes.except(:option))
    end
  end
end
