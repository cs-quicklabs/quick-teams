require "test_helper"

class AddNoteTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:one)
    @actor = users(:actor)
    @params = { body: "Add some note" }
  end

  test "can add note" do
    note = AddNote.call(@project, @params, @actor).result
    assert note
    assert_equal note.user_id, @actor.id
  end

  test "can add event noted" do
    assert_difference("@project.events.count") do
      AddNote.call(@project, @params, @actor)
    end
    assert_equal Event.last.action, "noted"
  end
end
