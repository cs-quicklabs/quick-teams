# Be sure to restart your server when you modify this file.

# Add JavaScript directory to asset paths for importmap-rails with Propshaft
Rails.application.config.assets.paths << Rails.root.join("app/javascript")
Rails.application.config.assets.paths << Rails.root.join("vendor/javascript")
