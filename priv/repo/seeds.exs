require Logger

alias Behemoth.Contexts.Fishing.Fish
alias Behemoth.Repo

Logger.info("Инициализация таблицы fishing.fishes")

Repo.insert_all(
  Fish,
  "priv/data/fishing.fishes.csv"
  |> File.stream!()
  |> CSV.decode(headers: [:name])
  |> Enum.map(fn {:ok, data} ->
    data
  end)
)
