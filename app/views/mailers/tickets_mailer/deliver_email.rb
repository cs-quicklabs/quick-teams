<p>Dear <%= @assignee.decorate.display_name %>!</p>
<p> <%= @actor.decorate.display_name %> added a new in ticket. Please click link below to see more details:</p>
<p><%= link_to "Show ticket", ticket_url(@ticket) %></p>
