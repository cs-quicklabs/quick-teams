# frozen_string_literal: true

class GoalQuery
  def initialize(entries, params, order_by, order)
    @entries = entries.extending(Scopes)
    @params = params
    @order_by = order_by
    @order = order
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    if order_by.nil? or order.nil?
      result.order(deadline: :desc)
    else
      result.order(order_by.parameterize => order.parameterize)
    end
  end

  private

  attr_reader :entries, :params, :order, :order_by

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

    def tag(param)
      joins(:taggings).where(taggings: { tag_id: Tag.find(param), taggable_type: "Goal" })
    end
  end
end
