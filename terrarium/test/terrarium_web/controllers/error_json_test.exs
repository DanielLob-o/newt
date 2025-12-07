defmodule NewtTerrariumWeb.ErrorJSONTest do
  use NewtTerrariumWeb.ConnCase, async: true

  test "renders 404" do
    assert NewtTerrariumWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert NewtTerrariumWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
