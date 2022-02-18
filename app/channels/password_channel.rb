class PasswordChannel < ApplicationCable::Channel
  def subscribed
    stream_from "password_channel"
  end
end