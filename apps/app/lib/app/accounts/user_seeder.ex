defmodule App.Accounts.UserSeeder do
  alias App.Repo
  alias App.Accounts
  alias App.Accounts.User

  def admin() do
    {:ok, user} =
      Accounts.dev_register_user(%{
        name: "John Smith",
        email: "admin@test.com",
        password: "password"
      })

    User.toggle_moderator_changeset(user, %{is_moderator: true})
    |> Repo.update()
  end

  def random() do
    name = Faker.Person.En.first_name() <> " " <> Faker.Person.En.last_name()
    first_name = name |> String.split(" ") |> List.first()
    email = String.downcase("#{first_name}@test.com")

    Accounts.register_user(%{
      name: name,
      email: email,
      password: "password"
    })
  end
end
