class Space::BaseController < BaseController
  before_action :set_space, only: %i[ index show edit update destroy create new ]
  after_action :verify_authorized
  include Pagy::Backend

  def set_space
    @space ||= Space.find(params["space_id"])
  end
end
