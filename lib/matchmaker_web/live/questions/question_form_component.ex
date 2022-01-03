defmodule MatchmakerWeb.QuestionFormComponent do
  use MatchmakerWeb, :live_component
  on_mount MatchmakerWeb.UserLiveAuth

  alias Matchmaker.Questions

  def render(assigns) do
    ~H"""
    <p>
    <.form for={@changeset} let={f} phx-change="change" phx-submit="submit" phx-target={@myself}>
      <.input form={f} field={:title} />
      <.input form={f} field={:description} />
      <%= submit "Save" %>
    </.form>
    </p>
    """
  end

  def update(%{question: question} = assigns, socket) do
    changeset = Questions.change_question(question)

    {:ok,
     socket
     |> assign(changeset: changeset)
     |> assign(assigns)}
  end

  def handle_event("change", %{"question" => params}, socket) do
    changeset =
      Questions.change_question(socket.assigns.question, params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"question" => params}, socket) do
    save_question(socket, socket.assigns.action, socket.assigns.question, params)
  end

  defp save_question(socket, :edit, question, params) do
    case Questions.update_question(question, params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_question(socket, :new, _question, params) do
    case Questions.create_question(socket.assigns.current_user, params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
