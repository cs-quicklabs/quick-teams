#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Ensure public/assets directory exists
mkdir -p public/assets

bundle exec rake assets:clean
bundle exec rake tailwindcss:build
bundle exec rake assets:precompile
bundle exec rake db:migrate