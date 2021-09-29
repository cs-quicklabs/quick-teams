require "test_helper"

class SurveyQuestionCategoryTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end
end
