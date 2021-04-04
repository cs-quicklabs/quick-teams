require "application_system_test_case"

class JobsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_jobs_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Job Profiles"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new job" do
    visit page_url
    fill_in "Add New Job", with: "New Job"
    click_on "Save"
    take_screenshot
    assert_text "Job was created successfully."
    assert_selector "#job_name", text: ""
  end

  test "can not add an empty job" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate job" do
    visit page_url
    fill_in "Add New Job", with: jobs(:developer).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_job_url(jobs(:developer), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a job" do
    visit page_url
    job = jobs(:developer)

    assert_selector "li", text: job.name
    find("li", text: job.name).click_on("Delete")
    assert_no_selector "li", text: job.name
  end

  test "can edit job" do
    visit page_url
    job = jobs(:developer)

    assert_selector "li", text: job.name
    find("li", text: job.name).click_on("Edit")
    within "turbo-frame#job_#{job.id}" do
      fill_in "job_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit job with exiting name" do
    visit page_url
    job = jobs(:developer)
    ios_engineer = jobs(:ios)

    assert_selector "li", text: job.name
    find("li", text: job.name).click_on("Edit")
    within "turbo-frame#job_#{job.id}" do
      fill_in "job_name", with: ios_engineer.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Job Profiles selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "Job Profiles"
    end
  end

  test "can not delete a job which is being used" do
    visit page_url
    job = jobs(:ios)

    assert_selector "li", text: job.name
    find("li", text: job.name).click_on("Delete")
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: job.name
  end
end
