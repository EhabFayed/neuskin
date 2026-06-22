require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Full-stack Hotwire monolith (not API-only): server-rendered ERB/ViewComponent
    # views, Turbo + Stimulus, sessions/flash/cookies. See docs/DESIGN-AND-TECH-DIRECTION.md.

    # Arabic-first, bilingual. Arabic is the default locale; English is the alternate.
    config.i18n.available_locales = [:ar, :en]
    config.i18n.default_locale = :ar
  end
end
