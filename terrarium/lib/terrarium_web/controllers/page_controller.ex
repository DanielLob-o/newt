defmodule NewtTerrariumWeb.PageController do
  use NewtTerrariumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
