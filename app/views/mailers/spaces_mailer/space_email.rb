<p>Dear <%= @employee.decorate.display_name %>!</p>
<p> <%= @actor.decorate.display_name %> created a new Space. Please click link below to see more details:</p>
<p><%= link_to "Show Space", space_messages_url(@space, script_name: "/#{@employee.account.id}") %></p>
