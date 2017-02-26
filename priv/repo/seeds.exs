# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tasks.Repo.insert!(%Tasks.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Tasks.{ Repo, User }

[
    %{
        first_name: "John",
        last_name: "Doe",
        email: "john@tasks.com",
        password: "12341234"
    },
]
|>  Enum.map(&User.changeset(%User{}, &1))
|>  Enum.each(&Repo.insert!(&1))