defmodule AreteServerWeb.MessageController do
  use AreteServerWeb, :controller
  alias AreteServer.Chat
  alias AreteServerWeb.Utils
  alias AreteServer.Chat.Message, as: MessageRepo

  def create(conn, params) do
    room_id = params["room_id"]

    if Chat.get_room(room_id) == nil do
      conn |> render("errors.json", %{errors: ["No room found!"]})
    else
          case MessageRepo.create_message(params) do
            {:ok, _message} ->
              conn
              |> render("ack.json", %{success: true, message: "Message sent!"})

            {:error, %Ecto.Changeset{} = changeset} ->
              conn
              |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

            true ->
              conn
              |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
          end
      end
    end

    def get(conn, %{"id" => room_id}) do
      room = Chat.get_room(room_id)
      if room == nil do
        conn |> render("errors.json", %{errors: ["No room found!"]})
      else
        conn |> render("ack.json", %{success: true, data: MessageRepo.get_messages_by_room(room_id)})
      end
    end

  end
