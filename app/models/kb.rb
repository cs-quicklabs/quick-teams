class Kb < ApplicationRecord
  acts_as_tenant :account

  include PgSearch::Model

  pg_search_scope :search_title, against: :document, using: { tsearch: { dictionary: "english" } }

  belongs_to :user
  belongs_to :job, optional: true
  belongs_to :discipline, optional: true
  validates :link, :url => true

  def self.query(params, includes = nil, order)
    return [] if params.empty?
    KbQuery.new(self.includes(includes), params, order).filter
  end

  def self.visible_documents_for_user(user)
    Kb.includes(:discipline, :job, :user).where(discipline_id: [nil, user.discipline.id], job_id: [nil, user.job.id]).order(created_at: :desc)
  end
end
