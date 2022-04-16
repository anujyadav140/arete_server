defmodule AreteServer.Chat.MessageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AreteServer.Chat.Message` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> AreteServer.Chat.Message.create_message()

    message
  end
end
