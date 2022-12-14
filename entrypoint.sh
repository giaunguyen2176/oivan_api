#!/bin/sh

set -e
bundle check || bundle install --binstubs="$BUNDLE_BIN"

bundle exec rake db:environment:set RAILS_ENV=$RAILS_ENV
bundle exec rake db:migrate
bundle exec rake db:seed

rm /src/tmp/pids/server.pid || true
bundle exec rails server -b 0.0.0.0

exec "$@"
