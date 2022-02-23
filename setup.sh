#!/bin/bash

echo "Pulling down submodules"
git submodule update --init

echo "Switch to main branch"
cd apps/petal_components && git checkout main && git pull && cd ../..
cd apps/petal_boilerplate && git checkout main && git pull && cd ../..

echo "Updating petal_boilerplate..."
cp ./setup/petal_boilerplate/config.exs ./apps/petal_boilerplate/config
cp ./setup/petal_boilerplate/dev.exs ./apps/petal_boilerplate/config
cp ./setup/petal_boilerplate/mix.exs ./apps/petal_boilerplate
cp ./setup/petal_boilerplate/tailwind.config.js ./apps/petal_boilerplate/assets

echo "Setup database"
mix setup
