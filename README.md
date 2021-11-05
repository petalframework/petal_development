<p align="center">
  <img src="https://res.cloudinary.com/wickedsites/image/upload/v1635752721/petal/logo_rh2ras.png" height="128">
  <h1 align="center">Petal Development</h1>
</p>

An elixir umbrella app to help developers contribute to either [petal_components](https://github.com/petalframework/petal_components) or [petal_boilerplate](https://github.com/petalframework/petal_boilerplate).

Be up and running within a minute.

```
petal_development
├── apps
│   ├── petal_components <- git submodule
│   └── petal_boilerplate <- git submodule
```

## Install

```bash
sh setup.sh
mix phx.server
```
## Developing

1. Make your changes
2. Commit to that submodule
3. Submit a PR
4. If accepted, we will update this petal_development project to point to the latest submodule commits

