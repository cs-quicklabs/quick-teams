require "application_system_test_case"

class EmployeeTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @todo = @employee.todos.first
    sign_in @employee
  end

  def page_url
    employee_todos_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def page_detail_url
    employee_todo_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @todo.id)
  end

  test "admin can see employee todos" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "div#employee-tabs", text: "Todos"
    assert_selector "form#new_todo"
    assert_selector "tbody#todos"

    #can see delete button for employee todos
    @employee.todos.each do |todo|
      if !@todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "admin can see his own todos" do
    sign_out @employee
    sign_in users(:super)
    visit page_url
    assert_selector "div#employee-tabs", text: "Todos"
    assert_selector "form#new_todo"
    assert_selector "tbody#todos"

    #can see delete button for his todos
    @employee.todos.each do |todo|
      if !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "admin can see own todo detail " do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @todo.title
  end

  test "admin can see employee todo details" do
    sign_out @employee
    @admin = users(:super)
    sign_in @admin
    @employee = users(:member)
    visit page_detail_url
    assert_selector "h3", text: @todo.title
  end

  test "lead can see subordinate todos" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "div#employee-tabs", text: "Todos"
    assert_selector "form#new_todo"
    assert_selector "tbody#todos"

    #can see delete button for his created todos
    #can not see delete button for his not created todos
    @employee.todos.each do |todo|
      if todo.user == @lead && !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "lead can not see someone elses todos" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:super)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_no_selector "form#new_todo"
    assert_no_selector "tbody#todos"
  end

  test "lead can see his own todos" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Todos"
    assert_selector "form#new_todo"
    assert_selector "tbody#todos"

    #can see delete button for his created todos
    #can not see delete button for his not created todos
    @employee.todos.each do |todo|
      if todo.user == @employee && !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "lead can see own todo details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @todo.title
  end

  test "lead can see subordinate todo details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_detail_url
    assert_selector "h3", text: @todo.title
  end

  test "lead can not see someone elses todo detail" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "member can see own todos" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Todos"
    assert_selector "form#new_todo"
    assert_selector "tbody#todos"

    #can see delete button for his created todos
    #can not see delete button for his not created todos
    @employee.todos.each do |todo|
      if todo.user == @employee && !todo.completed?
        assert_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_selector "tr##{dom_id(todo)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(todo)}", text: "Edit"
        assert_no_selector "tr##{dom_id(todo)}", text: "Delete"
      end
    end
  end

  test "member can see his own todo details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @todo.title
  end

  test "member can not see someone elsees todo" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
    assert_no_selector "form#new_todo"
    assert_no_selector "tbody#todos"
  end

  test "member can not see someone elses todo details" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @member.decorate.display_name
  end
end
