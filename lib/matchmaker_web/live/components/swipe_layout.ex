defmodule MatchmakerWeb.Components.SwipeLayout do
  use MatchmakerWeb, :live_component
  alias Phoenix.LiveView.JS

  prop(answers, :list)

  def render(assigns) do
    [answer | _] = assigns.answers

    ~F"""
      <div id="swipe-container" phx-window-keyup="key_response" phx-value-answer_id={answer.id}>
        <article phx-remove={JS.add_class("accept")}>
          <div id={answer.id} phx-hook="Swipe" class={"swipe-answer"} class="answer-container">
            <h2>{answer.title}</h2>
          </div>
          <footer>
            <div class="grid">
              <div>
                <button phx-click="question_response" phx-value-answer_id={answer.id} phx-value-response="1" phx-target={@myself}>Accept</button>
              </div>
              <div>
                <button phx-click="question_response" phx-value-answer_id={answer.id} phx-value-response="0" phx-target={@myself}>Refuse</button>
              </div>
            </div>
          </footer>
        </article>
      </div>
    """
  end

  @impl true
  def handle_event(
        "question_response",
        %{"response" => response, "answer_id" => answer_id} = params,
        socket
      ) do
    {:noreply, process_response(socket, answer_id, response)}
  end

  @impl true
  def handle_event("key_response", %{"key" => key, "answer_id" => answer_id}, socket)
      when key == "ArrowRight" or key == "ArrowLeft" do
    response = (key == "ArrowRight" && "0") || "1"
    {:noreply, process_response(socket, answer_id, response)}
  end

  @impl true
  def handle_event("key_response", _, socket) do
    {:noreply, socket}
  end

  defp process_response(socket, answer_id, response) do
    send(self(), {:process_responses, [{answer_id, response}]})
    socket
  end

  defp send_response(value, element) do
    class =
      if value do
        "accept"
      else
        "refuse"
      end

    # JS.add_class(class, to: ".answer-0")
    JS.push("question_response", value: %{answer_id: element, response: value})
  end
end
