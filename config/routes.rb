Rails.application.routes.draw do
  # Silence the favicon.ico RoutingError — browsers always request this.
  # Must be outside the locale scope so switch_locale never runs on it.
  get "/favicon.ico", to: proc { [204, {}, []] }

  # Health check for load balancers / uptime monitors.
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise session/auth routes — must stay outside the locale scope.
  devise_for :users

  # Admin area — English-only chrome, outside the locale scope.
  namespace :admin do
    root to: "dashboard#index"
  end

  # Locale-scoped pages. Arabic is the default; English is /en.
  # See docs/DESIGN-AND-TECH-DIRECTION.md §2.7 (path-prefix locales for SEO).
  scope "(:locale)", locale: /ar|en/ do
    root "pages#home"

    # About — The Clinic (§02).
    get "the-clinic", to: "pages#the_clinic", as: :the_clinic

    # Journal (§12) — editorial magazine grid.
    get "journal", to: "pages#journal", as: :journal

    # Patient Stories (§13) — consented social proof. Empty until material is ready.
    get "stories", to: "pages#stories", as: :stories

    # FAQ (§14) — 20 questions, search + accordion.
    get "faq", to: "pages#faq", as: :faq

    # Legal & compliance (§15). Draft copy — pending KSA legal review.
    get "privacy",            to: "pages#privacy",            as: :privacy
    get "medical-disclaimer", to: "pages#medical_disclaimer", as: :medical_disclaimer
    get "terms",              to: "pages#terms",              as: :terms

    # Dr. Maysa — the founder (§03), the most important page on the site.
    get "dr-maysa", to: "pages#dr_maysa", as: :dr_maysa

    # The Medical Team (§04) — the credibility layer.
    get "the-team", to: "pages#the_team", as: :the_team

    # The Maysa Method™ — the philosophy page (§05), not the protocol page.
    get "maysa-method", to: "pages#maysa_method", as: :maysa_method

    # Treatments — by outcome (design §08). A curated outcome list.
    get "treatments", to: "pages#treatments", as: :treatments

    # Private Care / VIP (§09) — gated, by invitation. Not in public nav.
    get "private-care", to: "pages#private_care", as: :private_care

    # Protocols Hub (§06) + protocol template pages (§07a–f).
    resources :protocols, only: %i[index show]

    # Contact & Inquiry — the conversion page (§11).
    get  "inquire", to: "inquiries#new",    as: :inquire
    post "inquire", to: "inquiries#create"

    # Bridal Concierge — the bride funnel (§10).
    get  "bridal-concierge",          to: "bridal#show",          as: :bridal_concierge
    post "bridal-concierge/checklist", to: "bridal#checklist",     as: :bridal_checklist
  end
end
