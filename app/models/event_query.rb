# frozen_string_literal: true

class EventQuery
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
    result.order(order)
  end

  private

  attr_reader :entries, :params, :order

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

    def from_date(param)
      where("date >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("date <= ?", Date.parse(param.to_s))
    end
  end
end
