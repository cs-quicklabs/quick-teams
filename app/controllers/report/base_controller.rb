class Report::BaseController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  LIMIT = 50

  def pagy_nil_safe(collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end
end
