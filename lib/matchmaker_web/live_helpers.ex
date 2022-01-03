defmodule MatchmakerWeb.LiveHelper do
  alias Phoenix.LiveView.JS

  def set_attribute(id, key, value) do
    JS.dispatch(%JS{}, "js:set-attr", to: id, detail: %{args: [key, value]})
  end

  def remove_attribute(id, key) do
    JS.dispatch(%JS{}, "js:rm-attr", to: id, detail: %{args: [key]})
  end
end
