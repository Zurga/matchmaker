defmodule MatchmakerWeb.Components do
  use Phoenix.Component
  import Phoenix.HTML.Form
  import MatchmakerWeb.ErrorHelpers
  alias Phoenix.LiveView.JS

  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:header, fn -> [] end)
      |> assign_new(:footer, fn -> [] end)

    ~H"""
    <dialog
      id={@id}
      class="modal-is-open"
      phx-click-away={hide_modal(@id)}
      phx-window-keydown={hide_modal(@id)}
      phx-key="escape"
    >
      <article>
        <%= if @header != [] do %>
          <header>
            <a href="#close"
            aria-label="Close"
            class="close"
            data-target="modal-example"
            phx-click={hide_modal(@id)}>
            </a>
            <%= render_slot(@header) %>
          </header>
        <% end %>
        <%= render_slot(@inner_block) %>
        <%= if @footer != [] do %>
          <footer>
            <%= render_slot(@footer) %>
          </footer>
        <% end %>
      </article>
    </dialog>
    """
  end

  def show_modal(id) do
    id = coerce_to_id(id)
    set_attribute(id, "open", "true")
  end

  def hide_modal(id) do
    id = coerce_to_id(id)
    remove_attribute(id, "open")
  end

  def set_attribute(to, key, value) do
    JS.dispatch("js:set-attr", to: to, detail: %{args: [key, value]})
  end

  def remove_attribute(to, key) do
    JS.dispatch("js:rm-attr", to: to, detail: %{args: [key]})
  end

  defp coerce_to_id(<<"#", _::binary>> = id), do: id
  defp coerce_to_id(id), do: "#" <> id

  def input(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:opts, fn -> [] end)
      |> assign_new(:input, fn -> :text_input end)

    opts = assigns.opts ++ validation_opts(assigns.form, assigns.field)

    ~H"""
    <%= label @form, @field%>
    <%= error_tag @form, @field %>
    <%= case @input do %>
      <% :text_input -> %>
        <%= text_input @form, @field, opts %>
      <% :textarea -> %>
        <%= textarea @form, @field, opts %>
    <% end %>
    """
  end

  def validation_opts(
        %Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset},
        field
      ) do
    validation_opts(changeset, field)
  end

  def validation_opts(%Ecto.Changeset{validations: validations, required: required}, field) do
    validations = Keyword.get_values(validations, field)

    [required: field in required]
    |> maybe_add_patterns(validations)
  end

  def validation_opts(_form, _field), do: []

  defp maybe_add_patterns(opts, validations) do
    Enum.reduce(validations, opts, fn
      {:length, [is: length]}, acc ->
        set_input_length(acc, length, length)
        |> Keyword.put(:minLength, length)
        |> Keyword.put(:maxLength, length)

      {:length, values}, acc ->
        set_input_length(acc, values[:min], values[:max])

      {:format, format}, acc ->
        Keyword.put(acc, :pattern, format.source)
    end)
  end

  defp set_input_length(opts, min, max) do
    opts
    |> Keyword.put(:minLength, min)
    |> Keyword.put(:maxLength, max)
  end
end
