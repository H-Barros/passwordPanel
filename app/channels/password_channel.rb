class PasswordChannel < ApplicationCable::Channel
  def subscribed
    self.number_off_tickets
    stream_from "password_channel"
  end

  def number_off_tickets
    PasswordPanelDb.have_password_in_queue?
  end
end