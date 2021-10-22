# mix run priv/repo/seeds.exs

# Keep this script idempotent (can run multiple times and get the same result)
# If you have changed the DB structure with a migration, then run `mix ecto.reset`
DB.delete_all_data()

App.Accounts.UserSeeder.admin()

# Create 10 user accounts
# Enum.each(0..10, fn _ ->
#   App.Accounts.UserSeeder.random()
# end)
