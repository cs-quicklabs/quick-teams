# frozen_string_literal: true

class TimesheetQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result.order(date: :desc)
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
    def user_id(param)
      where(user_id: param)
    end

    def project_id(param)
      where(project_id: param)
    end

    def user(param)
      where(user_id: param)
    end

    def billed(param)
      where(billed: param)
    end

    def from_date(param)
      where("date >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("date <= ?", Date.parse(param.to_s))
    end

    def billable(param)
      where("billable = ?", param)
    end

    def billed(param)
      where("billed = ?", param)
    end
  end
end
