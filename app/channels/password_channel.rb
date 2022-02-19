class PasswordChannel < ApplicationCable::Channel
  def subscribed
    stream_for "password_channel"
  end

  def receive(data)
    p data
  end
end