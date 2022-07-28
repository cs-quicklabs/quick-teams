require "application_system_test_case"

class ProjectClientsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:one)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_clients_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit projects if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Clients"
  end

  test "can add and remove clients to project" do
    visit page_url
    assert_text "Add New Client"
    client_name = clients(:mayank)
    sleep(0.5)
    find(:select, id: "client_client_id").find(:xpath, "option[2]").select_option
    sleep(0.5)
    take_screenshot
    click_on "Add Client"
    assert_selector "div#project-clients", text: client_name.name
    take_screenshot
    client = @project.clients.first
    page.accept_confirm do
      find("turbo-frame", id: dom_id(client)).click_link("Delete")
    end
    within "#project-clients" do
      assert_no_text client_name.name
    end
    take_screenshot
  end

  test "can not visit project if not logged in" do
    sign_out @employee

    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

end
