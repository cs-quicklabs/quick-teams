class Report::BaseController < BaseController
  include Pagy::Backend
  respond_to :csv
end
