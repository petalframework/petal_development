#!/bin/bash

echo "Pulling down submodules"
git submodule update --init

echo "Updating petal_boilerplate..."
cp ./setup/petal_boilerplate/dev.exs ./apps/petal_boilerplate/config
cp ./setup/petal_boilerplate/mix.exs ./apps/petal_boilerplate
cp ./setup/petal_boilerplate/package.json ./apps/petal_boilerplate/assets
cp ./setup/petal_boilerplate/tailwind.config.js ./apps/petal_boilerplate/assets

echo "Updating petal components..."
cp ./setup/petal_components/mix.exs ./apps/petal_components

echo "Setup database"
mix setup
