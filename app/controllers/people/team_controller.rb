class People::TeamController < People::BaseController
  def index
    @subordinates = UserDecorator.decorate_collection(@employee.subordinates)
  end
end
