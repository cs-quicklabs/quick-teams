class PeopleController < ApplicationController
  def index
    @employees = UserDecorator.decorate_collection(User.all)
  end

  def new
    @employee = User.new
  end

  def create
  end
end
