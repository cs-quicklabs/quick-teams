require "application_system_test_case"

class ProjectTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_todos_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project todos" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Todos"
    assert_selector "div#todo-list"
    assert_selector "form#new_todo"
  end

  test "lead can not see project todos" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "member can not see project todos" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end

  test "manager can see project todos" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Todos"
    assert_selector "div#todo-list"
    assert_selector "form#new_todo"
  end

  test "manager can not see project todos of other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Todos"
  end
end
