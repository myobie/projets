# projets

* Users _<=> Projects_
* Projects
    * Files
    * Discussions
    * Comments

## Prereqs

### `brew install`

* `heroku-toolbelt` (if you want to deploy to heroku)
* `postgresql`
* `rabbitmq`

### `rbenv install` (or `rvm install`)

* `2.1.2`

### `gem install`

* `bundler`

## Setup

* `$ bundle`
* `$ bin/rake db:setup`

## Develoment settings

If you need different AWS keys or something like that for development,
create a `.env.development` file (which will be ignored by git) to
override what's in `.env`. Do not change `.env` to make tests pass, they
should pass with the default settings.

Always use `ENV.fetch(...)` to require env vars or provide defaults.
