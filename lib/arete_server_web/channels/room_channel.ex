defmodule AreteServerWeb.RoomChannel do
  use AreteServerWeb, :channel
  alias AreteServer.Chat
  alias AreteServer.Chat.Message, as: MessageRepo

  @new_message "new_message"

  def join("room" <> room_id, _payload, socket) do
    # IO.inspect(room_id)
    # IO.inspect(payload)
    room = Chat.get_room(room_id)

    if room == nil do
      {:error, socket}
    else
      {:ok, assign(socket, :room_id, room_id)}
    end
  end

  def handle_in(@new_message, %{"payload" => %{"content" => content}}, socket) do
    # IO.inspect("payload of #{@new_message}")
    # IO.inspect(content)
    # IO.inspect('assigns the room id:')
    # IO.inspect(socket.assigns.room_id)

    room_id = socket.assigns.room_id

    case MessageRepo.create_message(%{content: content, room_id: room_id}) do
      {:ok, _message} ->
        # IO.inspect("new message!!!")
        broadcast!(socket, @new_message, %{payload: %{content: content}})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}

      true ->
        {:noreply, socket}
    end
  end

  def handle_in(@new_message, _payload, socket) do
    {:noreply, socket}
  end
end
