require "application_system_test_case"

class ProjectTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:unarchived)
    sign_in @employee
  end

  def page_url
    project_todos_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Add New Todo"
    take_screenshot
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can redirect to employee detail page on todo click" do
    visit page_url
    list = @project.participants.first
    click_on "#{list.first_name} #{list.last_name}"
    assert_selector "h1", text: "#{list.first_name} #{list.last_name}"
    take_screenshot
  end  

  test "can add new todo" do
    visit page_url
    name = "#{users(:abram).first_name + " " + users(:abram).last_name}"
    select name, from: "todo_user_id"
    fill_in "todo_title", with: "Some Random Todo Title"
    fill_in "todo_deadline", with: Time.now
    click_on "Add Todo"
    assert_selector "tbody#todos", text: "Worked on some random todo"
  end

  test "can check a todo" do
    visit page_url
    find("tr", id: dom_id(todo)).check "completed"
    take_screenshot
  end

  test "can not add todo with empty params" do
    visit page_url
    click_on "Add Todo"
    assert_selector "div#error_explanation", text: "User must exist"
    assert_selector "div#error_explanation", text: "User can't be blank"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Deadline can't be blank"
    take_screenshot
  end

  test "can delete a todo" do
    visit page_url

    todo = @project.todos.first
    display_name = todo.user.decorate.display_name
    assert_text display_name
    find("tr", id: dom_id(todo)).click_link("Delete")
    assert_no_selector "tbody#todos", text: todo.title
  end

  test "can not show add todo when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Todo"
  end
end
