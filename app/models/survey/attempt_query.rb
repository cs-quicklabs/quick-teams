# frozen_string_literal: true

class Survey::AttemptQuery
  def initialize(entries, params, order)
    @entries = entries.extending(Scopes)
    @params = params
    @order = order
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result.order(@order)
  end

  private

  attr_reader :entries, :params

  def filter_params
    params&.reject { |_, v| v.nil? } || {}
  end

  def present?(value)
    value != "" && !value.nil?
  end

  module Scopes
    def participant_id(param)
      where(participant_id: param)
    end

    def survey_type(param)
      where("survey_surveys.survey_type = ?", param)
    end

    def from_date(param)
      where("survey_attempts.created_at >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("survey_attempts.created_at <= ?", Date.parse(param.to_s))
    end
  end
end
