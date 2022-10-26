defmodule MatchmakerWeb.Components.Dropdown do
  use Surface.Component

  prop(label, :string, required: true)
  prop(as_button, :boolean, default: false)
  slot(items)

  @impl true
  def render(assigns) do
    ~F"""
    <details role={@as_button && "button" || "list"}>
      <summary aria-haspopup="listbox">{@label}</summary>
      <ul role="listbox">
        {#for {_, index} <- Enum.with_index(@items)}
          <li><#slot name="items" index={index} /></li>
        {/for}
      </ul>
    </details>
    """
  end
end
