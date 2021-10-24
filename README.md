# Petal Development

Umbrella app to help develop both petal and petal_boilerplate.

```
petal_development
├── apps
│   ├── petal <- git submodule
│   └── petal_boilerplate <- git submodule
```

## Install

```bash
sh setup.sh
```
## Developing

```
petal_development
├── apps
│   ├── petal <- set to a specific commit
│   └── petal_boilerplate <- set to a specific commit
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
# In the petal_development root folder:
git add .
git commit -m 'Petal submodule updated'
git push origin main
```
