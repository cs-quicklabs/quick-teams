require "test_helper"

class AddTicketTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @params = { description: "some new ticket", ticket_label_id: ticket_labels(:one).id, user_id: @user.id }
  end

  test "can add ticket" do
    ticket = AddTicket.call(@params, @user).result
    assert ticket
    assert_equal ticket.user, @user
  end
end
