defmodule AreteServerWeb.RoomChannel do
  use AreteServerWeb, :channel
  # alias AreteServer.Chat
  alias AreteServer.Chat.Message, as: MessageRepo

  @new_message "new_message"

  def join("room:" <> room_id, _payload, socket) do
    IO.inspect("joining channel")
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in("new_message", %{"payload" => %{"content" => content}}, socket) do
    res = MessageRepo.create_message(%{room_id: socket.assigns.room_id, content: content})

    case res do
      {:ok, new_message} ->
        IO.inspect("broadcasting new message....")
        broadcast!(socket, @new_message, %{data: new_message})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:error, socket}

      _ ->
        {:error, socket}
    end
  end

  def handle_in("new_message", payload, socket) do
    IO.inspect("payload done")
    IO.inspect(payload)
    {:noreply, socket}
  end
end
