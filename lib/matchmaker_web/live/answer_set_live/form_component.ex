defmodule MatchmakerWeb.AnswerSetLive.FormComponent do
  use MatchmakerWeb, :form

  alias Surface.Components.Form
  alias Surface.Components.Form.{Inputs, TextInput, TextArea}
  alias Matchmaker.Answers
  prop(answer_set, :map, required: true, default: %Answers.AnswerSet{})
  prop(action, :atom, default: :new)
  data(changeset, :changeset)

  @impl true
  def render(assigns) do
    ~F"""
      <Context get={Form, form: form}>
        {#if form}
          <Inputs form={form} for={:answer_set}>
            <Context get={Form, form: form}>
              {fields(Map.put(assigns, :form, form))}
            </Context>
          </Inputs>
        {#else }
          <Form for={@changeset}>
            <Context get={Form, form: form}>
              {fields(Map.put(assigns, :form, form))}
            </Context>
          </Form>
        {/if}
      </Context>
    """
  end

  defp fields(assigns) do
    ~F"""
      <Context put={Form, form: @form}>
        <TextInput field={:title}/>
        <TextArea field={:description}/>
        {#if @action == :new}
          <TextArea field={:answers} opts={[value: ""]} />
        {#else}
          <span></span>
        {/if}
      </Context>
    """
  end

  @impl true
  def update(%{answer_set: answer_set} = assigns, socket) do
    changeset = Answers.change_answer_set(answer_set)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"answer_set" => answer_set_params}, socket) do
    changeset =
      socket.assigns.answer_set
      |> Answers.change_answer_set(answer_set_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"answer_set" => answer_set_params}, socket) do
    save_answer_set(socket, socket.assigns.action, answer_set_params)
  end

  defp save_answer_set(socket, :edit, answer_set_params) do
    case Answers.update_answer_set(socket.assigns.answer_set, answer_set_params) do
      {:ok, _answer_set} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer set updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_answer_set(socket, :new, answer_set_params) do
    case Answers.create_answer_set(answer_set_params) do
      {:ok, _answer_set} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer set created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
