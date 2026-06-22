Rails.application.routes.draw do
  # Health check for load balancers / uptime monitors.
  get "up" => "rails/health#show", as: :rails_health_check

  # Locale-scoped pages. Arabic is the default; English is /en.
  # See docs/DESIGN-AND-TECH-DIRECTION.md §2.7 (path-prefix locales for SEO).
  scope "(:locale)", locale: /ar|en/ do
    root "pages#home"
  end
end
