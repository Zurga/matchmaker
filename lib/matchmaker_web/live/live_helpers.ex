defmodule MatchmakerWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  def to_options(list_of_structs, key \\ :title) do
    Enum.map(list_of_structs, &{Map.get(&1, key), Map.get(&1, :id)})
  end
end
