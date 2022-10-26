defmodule Matchmaker.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, Ecto.ULID, autogenerate: true}
      @foreign_key_type Ecto.ULID

      defp maybe_put_assoc(changeset, assocs, attrs) when is_list(assocs) do
        Enum.reduce(assocs, changeset, fn assoc, acc ->
          maybe_put_assoc(acc, assoc, attrs)
        end)
      end

      defp maybe_put_assoc(changeset, assoc, attrs) do
        if resource = attrs[to_string(assoc)] || attrs[assoc] do
          put_assoc(changeset, assoc, resource)
        else
          changeset
        end
      end
    end
  end
end
