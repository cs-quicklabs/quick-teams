Rails.application.routes.draw do
  devise_for :users
  get "static/home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
