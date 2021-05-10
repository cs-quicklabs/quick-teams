# frozen_string_literal: true

class GoalQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result.order(deadline: :desc)
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
    def created_by(param)
      where(user_id: param)
    end

    def created_for(param)
      where(goalable_id: param)
    end

    def from_date(param)
      where("deadline >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("deadline <= ?", Date.parse(param.to_s))
    end

    def status(param)
      where(status: param)
    end

    def type(param)
      where(goalable_type: param)
    end
  end
end
