require "application_system_test_case"

class EmployeeTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_todos_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Add New Todo"
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can redirect to employee detail page on project click" do
    visit page_url
    project = @employee.projects.first
    click_on "#{project.name}"
    assert_selector "a", text: "#{project.name}"
  end

  test "can add new todo" do
    visit page_url
    fill_in "todo_title", with: "Some Random Todo Title"
    fill_in "todo_deadline", with: Time.now
    click_on "Add Todo"
    assert_selector "tbody#todos", text: "Some Random Todo Title"
    take_screenshot
  end

  test "can check a todo" do
    visit page_url
    todo = @employee.todos.first

    find("tr", id: dom_id(todo)).check "completed"
    take_screenshot
  end

  test "can not add todo with empty params" do
    visit page_url
    click_on "Add Todo"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can delete a todo" do
    visit page_url
    todo = @employee.todos.first
    display_name = todo.project.name
    assert_text display_name
    page.accept_confirm do
      find("tr", id: dom_id(todo)).click_link("Delete")
    end
    assert_no_selector "tbody#todos", text: todo.title
  end

  test "can not show add todo when employee is inactive" do
    inactive_employee = users(:inactive)
    visit employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Todo"
  end
end
