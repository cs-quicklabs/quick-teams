require "test_helper"

class AddCommentOnTicketTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @ticket = @user.tickets.first
    @actor = users(:actor)
    @params = { user_id: @actor.id, commentable_id: @ticket.id, title: "this is a new ticket", status: "stale" }
    @method = "and mark closed"
  end

  test "can comment on ticket" do
    comment = AddCommentOnTicket.call(@params, @ticket, @method, @actor).result
    assert comment
    assert_equal comment.user_id, @actor.id
    ticket = @user.tickets.first
    assert_equal ticket.ticketstatus, true
  end
end
