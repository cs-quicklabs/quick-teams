class Report::BaseController < BaseController
  include Pagy::Backend

  LIMIT = 30
end
