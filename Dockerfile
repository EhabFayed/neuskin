# syntax=docker/dockerfile:1
# check=error=true

# Production image for the NeuSkin site + dashboard (deployed via
# docker-compose.yml on port 9020):
#   docker compose up -d --build

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.10
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
# Build args let docker-compose.dev.yml build a development image (all gem
# groups, RAILS_ENV=development) from this same Dockerfile. Defaults = production.
ARG RAILS_ENV="production"
ARG BUNDLE_WITHOUT="development test"
ENV RAILS_ENV="${RAILS_ENV}" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="${BUNDLE_WITHOUT}"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems, plus `minify` (tdewolff) to shrink the
# CSS/JS below — Propshaft ships assets verbatim, unminified. Pinned so a base
# image or Debian update cannot silently change the minified output.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config minify=2.20.37-1 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets for production without requiring secret RAILS_MASTER_KEY
# Only production ships precompiled assets; development serves them live.
#
# Minify the app's own CSS/JS sources BEFORE precompile (PageSpeed "Minify
# CSS/JS"). Propshaft fingerprints each file from its contents, so minifying
# first means every change gets a new digest URL. Minifying the digested output
# afterwards would change contents under the old URL, and the year-long
# immutable cache would then keep a stale or broken copy even after a rollback.
# Only the build stage's copy is touched; the repo and development are not.
# set -e + xargs fail the build on any minify error (find -exec would not).
# *.min.* files are already minified and skipped. Gem assets (turbo,
# stimulus, trix) are not in these paths; the site loads their prebuilt .min
# builds through the importmap.
RUN if [ "$RAILS_ENV" = "production" ]; then \
      set -e; \
      find app/assets/stylesheets app/javascript vendor/javascript \
           -type f \( -name "*.css" -o -name "*.js" \) ! -name "*.min.*" -print0 \
        | xargs -0 -n1 sh -c 'minify -o "$0" "$0"'; \
      SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile; \
    fi


# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security.
# mkdir -p first: log/ tmp/ storage/ hold no tracked files, so a clean git
# clone's build context does not contain them and chown would fail.
RUN mkdir -p db log storage tmp && \
    groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Rails serves directly on PORT (default 9020); overridden by docker-compose.
EXPOSE 9020
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bin/rails server -b 0.0.0.0 -p ${PORT:-9020}"]
