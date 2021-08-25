require "application_system_test_case"

class EmployeeNuggetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:lead)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_documents_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def edit_page_url
    edit_employee_document_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @document.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end
end
