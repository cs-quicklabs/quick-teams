require "application_system_test_case"

class SkillsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_skills_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Skills"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new skill" do
    visit page_url
    fill_in "Add New Skill", with: "New Skill"
    click_on "Save"
    take_screenshot
    assert_text "Skill was created successfully."
    assert_selector "#skill_name", text: ""
  end

  test "can not add an empty skill" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate skill" do
    visit page_url
    fill_in "Add New Skill", with: skills(:ruby).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_skill_url(skills(:ruby), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a skill" do
    visit page_url
    skill = skills(:ruby)

    assert_selector "li", text: skill.name
    find("li", text: skill.name).click_on("Delete")
    assert_no_selector "li", text: skill.name
  end

  test "can edit skill" do
    visit page_url
    skill = skills(:ruby)

    assert_selector "li", text: skill.name
    find("li", text: skill.name).click_on("Edit")
    within "turbo-frame#skill_#{skill.id}" do
      fill_in "skill_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit skill with exiting name" do
    visit page_url
    skill = skills(:ruby)
    python = skills(:python)

    assert_selector "li", text: skill.name
    find("li", text: skill.name).click_on("Edit")
    within "turbo-frame#skill_#{skill.id}" do
      fill_in "skill_name", with: python.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Skills selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "Skills"
    end
  end

  test "can not delete a skill which is being used" do
    visit page_url
    skill = skills(:python)

    assert_selector "li", text: skill.name
    find("li", text: skill.name).click_on("Delete")
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: skill.name
  end
end
