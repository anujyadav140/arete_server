defmodule AreteServerWeb.RoomController do
  use AreteServerWeb, :controller
  alias AreteServer.Chat
  alias AreteServerWeb.Utils

  def ping(conn, _params) do
    conn
    |> render("ack.json", %{success: true, message: "pong"})
  end

  def create(conn, params) do
    case Chat.create_room(params) do
      {:ok, _room} ->
        conn
        |> render("ack.json", %{success: true, message: "Room Created!"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      true ->
        conn
        |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
    end
  end

  def list(conn, _params) do
    conn
    |> render("ack.json", %{success: true, data: Chat.list_rooms()})
  end
end
