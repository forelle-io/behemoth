require Logger
alias Behemoth.Contexts.Fishing.Fish
alias Behemoth.Contexts.Geo.City
alias Behemoth.Repo

defmodule Behemoth.Seeds do
  def insert_fishes({:ok, row}) do
    %Fish{}
    |> Fish.changeset(row)
    |> Repo.insert()
  end
end

Logger.info("Заполнение таблицы fishing.fishes названиями рыб")

File.stream!("priv/data/fishing.fishes.csv")
|> Stream.drop(1)
|> CSV.decode(headers: [:name])
|> Enum.each(&Behemoth.Seeds.insert_fishes/1)


