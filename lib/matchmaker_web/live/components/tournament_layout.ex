defmodule MatchmakerWeb.Components.TournamentLayout do
  use MatchmakerWeb, :live_component

  prop(answers, :list)

  prop(ordering, :list, default: [])

  def render(assigns) do
    ~F"""
      <div id="tournament-container">
        <div class="grid">
          {#for row <- group_answers(@answers, @ordering)}
            <div>
              {#for {answer, idx} <- row}
                <article :on-click="click" phx-value-id={answer.id} class={"clicked-#{idx}": idx}>
                  <h2>{answer.title}</h2>
                </article>
              {/for}
            </div>
          {/for}
        </div>
      </div>
    """
  end

  def handle_event("click", %{"id" => id}, %{assigns: %{ordering: ordering}} = socket) do
    ordering =
      case Enum.find_index(ordering, &(&1 == id)) do
        nil -> ordering ++ [id]
        0 -> []
        index -> Enum.slice(ordering, 0..(index - 1))
      end

    if length(ordering) == 4 do
      Process.send_after(
        self(),
        {:process_responses,
         Enum.with_index(ordering) |> Enum.map(fn {a, i} -> {a, to_string(i)} end)},
        300
      )
    end

    {:noreply, assign(socket, ordering: ordering)}
  end

  defp group_answers(answers, ordering) do
    Enum.slice(answers, 0..3)
    |> Enum.map(&{&1, index(ordering, &1.id)})
    |> Enum.chunk_every(2)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp index(ordering, id) do
    case Enum.find_index(ordering, &(&1 == id)) do
      nil -> nil
      index -> index + 1
    end
  end
end
