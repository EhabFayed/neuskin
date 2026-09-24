# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Running locally (Docker)

`docker-compose.yml` is the **production** stack the server runs (port 9020).
For development use the dev compose file, which bind-mounts the source and
runs Rails in development on <http://localhost:3000>:

```sh
docker compose -f docker-compose.dev.yml up --build   # first run, or after Gemfile changes
docker compose -f docker-compose.dev.yml up -d        # afterwards
docker compose -f docker-compose.dev.yml exec app bundle exec rspec
```

The database is created and migrated automatically on start.
