#!/usr/bin/env sh

# Credits to thoughtbot

# Exit if any subcommand fails
set -e

# Set up Ruby dependencies via Bundler
gem install bundler --conservative
bundle check || bundle install

# Set up database and add any development seed data
bundle exec rake db:setup

# Add binstubs to PATH via export PATH=".git/safe/../../bin:$PATH" in ~/.zshenv
mkdir -p .git/safe

# Pick a port for Foreman
if ! grep --quiet --no-messages --fixed-strings 'port' .foreman; then
  printf 'port: <%= config[:port_number] %>\n' >> .foreman
fi

if ! command -v foreman > /dev/null; then
  printf 'Foreman is not installed.\n'
  printf 'See https://github.com/ddollar/foreman for install instructions.\n'
fi
