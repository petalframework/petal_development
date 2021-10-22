# Petal Development

Umbrella app to help develop both petal and petal_pro.

```
petal_development
├── apps
│   ├── petal <- git submodule
│   └── petal_pro <- git submodule
```

## Install

Pull down the git submodules.

```bash
git submodule update --init
```

Update apps/app/dev.exs with the right database name.
```elixir
# Configure your database
# Set log: true to see database queries in your logs
config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "petal_development_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  log: false
```

Setup the project:

```bash
cd apps/app
mix setup
```

## Developing

```
petal_development
├── apps
│   ├── petal <- set to a specific commit
│   └── petal_pro <- set to a specific commit
```

Since each git submodule points to a commit hash, we need to update this project after we have finished editing one of the submodules.

Develop either project (petal or petal)_pro) and run the normal git commands within the folder. For example:

```
cd apps/petal
touch newfile.ex
git add newfile.ex
git commit -m 'added a new file'
git push origin main
```

Petal has been updated successfully. However, now the submodule in petal_development is pointing to an old commit. We need to update this pointer:

```
cd ..
/apps

cd ..
/

git add .
git commit -m 'Petal submodule updated'
git push origin main
```
