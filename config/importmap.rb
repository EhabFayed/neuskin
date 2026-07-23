# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "lenis" # vendor/javascript/lenis.js — smooth scrolling (v1.3.11 ESM build)
pin_all_from "app/javascript/controllers", under: "controllers"
