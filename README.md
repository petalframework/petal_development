# Petal Development

Umbrella app to help develop both petal_components and petal_boilerplate.

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

```
petal_development
├── apps
│   ├── petal_components <- set to a specific commit
│   └── petal_boilerplate <- set to a specific commit
```

Since each git submodule points to a commit hash, we need to update this project after we have finished editing one of the submodules.

Develop either project (petal_components or petal_boilerplate) and run the normal git commands within the folder. For example:

```
cd apps/petal_components
touch newfile.ex
git add newfile.ex
git commit -m 'added a new file'
git push origin main
```

Petal has been updated successfully. However, now the submodule in petal_development is pointing to an old commit. We need to update this pointer:

```
# In the petal_development root folder:
git add .
git commit -m 'Petal submodule updated'
git push origin main
```
