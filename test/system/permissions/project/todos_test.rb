require "application_system_test_case"

class ProjectTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    @todo = @project.todos.where(completed: false).first
    sign_in @employee
  end

  def page_url
    project_todos_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def page_detail_url
    project_todo_url(script_name: "/#{@account.id}", project_id: @project.id, id: @todo.id)
  end

  test "admin can see project todos" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Todos"
    assert_selector "div#todo-list"
    assert_selector "form#new_todo"
    @project.todos.each do |todo|
      if !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "admin can see todo todo details" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#todo-detail"
    #can see edit
    assert_selector "a", text: "Edit"
  end

  test "lead can not see project todos" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "lead can not see project todo details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#todo-detail"
  end

  test "member can not see project todos" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "member can not see project todo details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#todo-detail"
  end

  test "manager can see project todos" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Todos"
    assert_selector "div#todo-list"
    assert_selector "form#new_todo"
    @project.todos.each do |todo|
      if todo.owner == @employee && !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "manager can see project todo details" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#todo-detail"
  end

  test "manager can not see project todos of other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "manager can not see project todo details of different project" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    @todo = @project.todos.first
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#todo-detail"
  end

  test "observer can see project todos" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Todos"
    assert_selector "div#todo-list"
    assert_selector "form#new_todo"
    @project.todos.each do |todo|
      if todo.owner == @employee && !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "observer can see project todo details" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#todo-detail"
  end

  test "observer can not see project todos of other projects" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:managed)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "observer can not see project todo details of different project" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:managed)
    @todo = @project.todos.first
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#todo-detail"
  end
end
