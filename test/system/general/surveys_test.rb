require "application_system_test_case"

class SurveysTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @survey = survey_surveys(:one)
    sign_in @user
  end

  def page_url
    surveys_url(script_name: "/#{@account.id}")
  end

  def surveys_page_url
    survey_questions_url(script_name: "/#{@account.id}", survey_id: @survey.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Surveys"
    assert_text "New Survey"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show survey detail page" do
    visit page_url
    click_on "#{@survey.name} in #{@survey.discription}"
    within "#survey-header" do
      assert_text "Attempt"
      assert_text "Clone"
    end
    take_screenshot
  end

  test "can create a new survey" do
    visit page_url
    click_on "New Survey"
    fill_in "Name", with: "Survey Campaign"
    fill_in "Description", with: "This is a sample Survey Description"
    select survey_type(:kpi), from: "select survey_type"
    select survey_for(:employee), from: "survey_typeSelect for whom this survey is intended"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "survey was successfully created."
  end

  test "can not create with empty Name Discription survey_type survey_for" do
    visit page_url
    click_on "New Survey"
    assert_selector "h1", text: "Add New Survey"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Add New Survey"
  end

  test "can edit a survey" do
    visit page_url
    binding.irb
    click_on "#{@survey.name} in #{@survey.discription}"
    within "#survey-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Survey"
    fill_in "Name", with: "Survey Campaigning"
    click_on "Save"
    assert_selector "p.notice", text: "Survey was successfully updated."
  end

  test "can not edit a survey with invalid name" do
    visit page_url
    click_on "#{@survey.name} in #{@survey.description}"
    within "#survey-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Survey"
    fill_in "Survey Name", with: ""
    click_on "Save"
    take_screenshot
  end

  test "can clone a survey" do
    visit page_url
    click_on "#{@survey.name} in #{@survey.description}"
    within "#survey-header" do
      page.accept_confirm do
        click_on "Clone"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Survey was cloned successfully."
  end

  test "can attempt a survey" do
    visit page_url
    click_on "#{@survey.name} in #{@survey.description}"
    within "#survey-header" do
      page.accept_confirm do
        click_on "Attempt"
      end
    end
    take_screenshot
    assert_selector "h1", text: "Select participant in #{@survey.name}"
  end

  test "can delete survey" do
    visit page_url
    click_on "#{@survey.name} in #{@survey.description}"
    within "#survey-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Survey was removed successfully."
  end
end
