defmodule MatchmakerWeb.Components.Table.Column do
  use Surface.Component, slot: "cols"

  @doc "The title of the column"
  prop title, :string, required: true
end

defmodule MatchmakerWeb.Components.Table do
  use Surface.Component

  @doc "The list of items to be rendered"
  prop items, :list, required: true

  @doc "The list of columns defining the Grid"
  slot cols, args: [item: ^items]

  def render(assigns) do
    ~F"""
    <table class="table is-bordered is-striped is-hoverable is-fullwidth">
      <thead>
        <tr>
          {#for col <- @cols}
            <th>{col.title}</th>
          {/for}
        </tr>
      </thead>
      <tbody>
        {#for item <- @items}
          <tr>
            {#for {_, index} <- Enum.with_index(@cols)}
              <td><#slot name="cols" index={index} :args={item: item} /></td>
            {/for}
          </tr>
        {/for}
      </tbody>
    </table>
    """
  end
end


