source "https://rubygems.org"

ruby "3.4.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.5"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.20"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache", "~> 1.0.7"
gem "solid_queue", "~> 1.2.1"
gem "solid_cable", "~> 3.0.12"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Kamal deployment removed

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", "~> 0.1.15", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", "~> 7.1.0", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", "~> 4.35.0"
end

#################################
gem "sass-rails", "~> 6.0"


gem "devise", "~> 4.9"

gem "stripe", "~> 15.5"

gem "activeadmin", "~> 3.3"

gem 'dotenv-rails', groups: [ :development, :test ]

gem "image_processing", "~> 1.13"

gem "jquery-rails", "~> 4.6"

gem "rails-i18n", "~> 8.0"
gem 'i18n-tasks', group: :development
group :development do
  gem 'i18n-debug'
end



###############################



group :development do
  # === AUTO-RESTART SERVEUR ===
  gem 'rerun'            # rerun -- rails server
  gem 'guard'           # Surveillance avancée des fichiers
  gem 'guard-rails'     # Guard spécifique pour Rails
  gem 'guard-livereload' # Recharge la page automatiquement

  # === SURVEILLANCE FICHIERS ===
  gem 'listen'          # Surveillance efficace des changements
  gem 'spring'          # Préchargement Rails (inclus par défaut Rails 8)
  gem 'spring-watcher-listen' # Spring + Listen pour surveillance

  # === AUTO-RELOAD NAVIGATEUR ===
  gem 'rack-livereload' # Recharge automatique du navigateur

  # === BEAUTIFUL TERMINAL ===
  gem 'colorize'        # Couleurs dans le terminal
  gem 'rainbow'         # Alternative à colorize
  gem 'tty-spinner'     # Spinners animés dans le terminal
  gem 'tty-progressbar' # Barres de progression

  # === BETTER RAILS CONSOLE ===
  gem 'pry-rails'       # Console Rails améliorée (remplace IRB)
  gem 'pry-byebug'      # Debugger intégré à Pry
  gem 'awesome_print'   # Pretty print des objets Ruby
  gem 'hirb'            # Tables formatées dans la console

  # === BETTER ERROR PAGES ===
  gem 'better_errors'   # Pages d'erreur magnifiques
  gem 'binding_of_caller' # Requis pour better_errors
  gem 'byebug', platforms: [ :mri, :mingw, :x64_mingw ]
  gem "letter_opener"

  # === RAILS PANEL ===
  gem 'rails_panel'     # Extension Chrome pour Rails
  gem 'meta_request'    # Requis pour rails_panel
end

group :development do
  # === BEAUTIFUL LOGS ===
  gem 'rails_semantic_logger' # Logs structurés et colorés
  gem 'amazing_print'          # Pretty print amélioré
  gem 'rails_stdout_logging'   # Logs vers STDOUT (Heroku)

  # === LOG ANALYSIS ===
  gem 'lograge'         # Logs Rails en une ligne
end

group :development, :test do
  # === DEBUGGING LOGS ===
  gem 'table_print'     # Affichage en tableaux
end

# === PRODUCTION MONITORING (utile à connaître) ===
group :production do
  # gem 'newrelic_rpm'     # New Relic monitoring
  # gem 'sentry-ruby'      # Error tracking
  # gem 'honeybadger'      # Alternative à Sentry
end

gem 'rails-erd'
gem 'bullet'
gem 'annotate'  # rails g annotate:install
gem "boot"


group :production do
  gem "rails_12factor", "~> 0.0.3"
end
