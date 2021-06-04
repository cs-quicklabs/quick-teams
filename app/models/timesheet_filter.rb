# frozen_string_literal: true

class TimesheetFilter
  include ActiveModel::Model

  KEYS = %i[
    user_id
    project_id
    billed
    billable
    from_date
    to_date
    status
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end

  def billed_options
    [
      ["Show Only Billed", false],
      ["Show Only Unbilled", true],
    ]
  end

  def billable_options
    [
      ["Show Only Billable", false],
      ["Show Only Unbillable", true],
    ]
  end

  def from_date
    DateTime.parse(@from_date) if @from_date.present?
  end

  def to_date
    DateTime.parse(@to_date) if @to_date.present?
  end

  def employee
    @employee ||= User.find_by(id: @user_id)
  end

  def project
    @project ||= Project..find_by(id: @project_id)
  end
end
