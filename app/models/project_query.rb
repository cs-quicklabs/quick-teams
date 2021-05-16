# frozen_string_literal: true

class ProjectQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result.order(name: :asc)
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
    def manager_id(param)
      where(manager_id: param)
    end

    def status(param)
      where(status: param)
    end
  end
end
