require "application_system_test_case"

class ClientsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_clients_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Client"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new client" do
    visit page_url
    fill_in "Full Name", with: "New Client"
    fill_in "Email", with: "mayank@crown.com"
    click_on "Save"
    take_screenshot
    assert_text "Client was created successfully."
    assert_selector "#client_name", text: ""
    assert_selector "#client_email", text: ""
  end

  test "can not add an empty client name email" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_selector "div#error_explanation", text: "Name can't be blank"
  end

  test "can not add a duplicate client email" do
    visit page_url
    fill_in "Email", with: clients(:mayank).email
    click_on "Save"
    take_screenshot
    assert_text "Email has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_client_url(clients(:mayank), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a client" do
    visit page_url
    client = clients(:mayank)

    assert_selector "li", text: client.name
    find("li", text: client.name).click_on("Delete")
    assert_no_selector "li", text: client.name
  end

  test "can edit client" do
    visit page_url
    client = clients(:mayank)

    assert_selector "li", text: client.name
    assert_selector "li", text: client.email
    find("li", text: client.name).click_on("Edit")
    within "turbo-frame#client_#{client.id}" do
      fill_in "client_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit client with exiting email" do
    visit page_url
    client = clients(:mayank)
    prachi = clients(:prachi)

    assert_selector "li", text: client.email
    find("li", text: client.email).click_on("Edit")
    within "turbo-frame#client_#{client.id}" do
      fill_in "client_email", with: ""
      fill_in "client_email", with: prachi.email
      click_on "Save"
      take_screenshot
      assert_text "Email has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Clients selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Clients"
    end
  end
end
