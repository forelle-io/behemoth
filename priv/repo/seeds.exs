require Logger

alias Behemoth.Contexts.Fishing.Fish
alias Behemoth.Contexts.Geo.City
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

Logger.info("Инициализация таблицы geo.cities")

Repo.insert_all(
  City,
  [
    %{name: "Москва"},
    %{name: "Санкт-Петербург"},
    %{name: "Новосибирск"},
    %{name: "Екатеринбург"},
    %{name: "Нижний Новгород"},
    %{name: "Казань"},
    %{name: "Челябинск"},
    %{name: "Омск"},
    %{name: "Самара"},
    %{name: "Ростов-на-Дону"},
    %{name: "Уфа"},
    %{name: "Красноярск"},
    %{name: "Воронеж"},
    %{name: "Пермь"},
    %{name: "Волгоград"}
  ]
)
