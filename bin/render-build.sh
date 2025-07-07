#!/usr/bin/env bash

set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# Run migrations if DATABASE_URL is available
if [ -n "$DATABASE_URL" ]; then
  bin/rails db:migrate
fi