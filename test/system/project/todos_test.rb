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
    name = @project.participants.first.decorate.display_name
    select name, from: "todo_owner_id"
    fill_in "todo_title", with: "Some Random Todo Title"
    fill_in "todo_body", with: "Some Random Todo Body"
    fill_in "todo_deadline", with: Time.now
    click_on "Add Todo"
    assert_selector "tbody#todos", text: "Some Random Todo Title"
  end

  test "can check a todo" do
    visit page_url
    todo = @project.todos.first

    find("tr", id: dom_id(todo)).check "completed"
    take_screenshot
  end

  test "can not add todo with empty params" do
    visit page_url
    click_on "Add Todo"
    assert_selector "div#error_explanation", text: "Owner must exist"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    take_screenshot
  end

  test "can see todo detail page" do
    visit page_url
    todo = @project.todos.first
    find("tr", id: dom_id(todo)).click_link(todo.title)
    assert_selector "h3", text: todo.title
    take_screenshot
  end

  test "can edit a todo" do
    visit page_url
    todo = @project.todos.where(completed: 0).first
    assert_text todo.title
    find("tr", id: dom_id(todo)).click_link("Edit")
    take_screenshot
    within "##{dom_id(todo)}" do
      fill_in "todo_title", with: "todo Edited"
      click_on "Edit Todo"
      take_screenshot
      assert_no_text "Edit Todo"
    end
    assert_selector "p.notice", text: "todo was successfully updated."
    assert_selector "tr##{dom_id(todo)}", text: "todo Edited"
  end

  test "can not edit todo with invalid params" do
    visit page_url
    todo = @project.todos.where(completed: 0).first
    assert_text todo.title
    find("tr", id: dom_id(todo)).click_link("Edit")
    within "##{dom_id(todo)}" do
      fill_in "todo_title", with: ""
      click_on "Edit Todo"
      take_screenshot
    end
    assert_selector "p.alert", text: "Failed to update. Please try again."
  end

  test "can delete a todo" do
    visit page_url

    todo = @project.todos.where(completed: 0).first
    display_name = todo.user.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find("tr", id: dom_id(todo)).click_link("Delete")
    end
    assert_no_selector "tbody#todos", text: todo.title
  end

  test "can not show add todo when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Todo"
  end
end
