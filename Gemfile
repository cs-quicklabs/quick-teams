# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby version app is using, [https://www.ruby-lang.org/en/downloads/]
ruby "3.2.0"

# Bundle edge Rails instead: gem 'rails', [https://github.com/rails/rails]
gem "rails", "7.0.4.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "3.4.2"

# Use postgresql as the database for Active Record [https://github.com/ged/ruby-pg]
gem "pg", "1.4.5"

# Use Puma as the app server [https://github.com/puma/puma]
gem "puma", "6.0.2"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "1.1.1"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "1.1.2"

# Hotwire's SPA-like page accelerator [https://github.com/hotwired/turbo-rails]
gem "turbo-rails", "1.3.3"

# Hotwire's modest JavaScript framework [https://github.com/hotwired/stimulus-rails]
gem "stimulus-rails", "1.2.1"

# Build reactive applications [https://github.com/stimulusreflex/stimulus_reflex]
gem "stimulus_reflex", "3.5.0.pre8"

# Use Redis adapter to run Action Cable in production
gem "hiredis"
gem "redis", "5.0.6"
gem "valid_url"

# Use Active Storage variant
gem "image_processing", "~> 1.12"

# sidekiq gems, sinatra is used to build UI for /sidekiq
gem "sidekiq", "7.0.3"
gem "sidekiq-scheduler", "5.0.1"
gem "sinatra", "3.0.5", require: nil

# Reduces boot times through caching; required in config/boot.rb
gem "acts_as_tenant"
gem "aws-sdk-s3", "~> 1.119"
gem "bootsnap", "1.16.0", require: false
gem "draper"
gem "mimemagic", github: "mimemagicrb/mimemagic", ref: "01f92d86d15d85cfd0f20dabd025dcbd36a8a60f"
gem "newrelic_rpm"
gem "pagy"
gem "rails-patterns"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "csv"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "pg_search"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "nokogiri", "~> 1.14"

# devise gems
gem "devise", github: "heartcombo/devise", branch: "main"
gem "devise_invitable", "~> 2.0.0"
gem "devise-pwned_password"

# Payments
gem "pay", "6.3.1"
gem "stripe", "~> 8.2"

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "launchy"
  gem "letter_opener"
  gem "letter_opener_web"
  gem "rexml"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  gem "ra ck-mini-profiler", "~> 3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "rufo"
  gem "htmlbeautifier"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.38"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end
