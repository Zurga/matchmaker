defmodule Matchmaker.Accounts.UserNotifier do

  def deliver_confirmation_instructions(_user, token), do: {:ok, %{text_body: token}}
  def deliver_reset_password_instructions(_user, token), do: {:ok, %{text_body: token}}
  def deliver_update_email_instructions(_user, token), do: {:ok, %{text_body: token}}
  def deliver_user_reset_password_instructions(_user, token), do: {:ok, %{text_body: token}}
end
