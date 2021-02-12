Rails.application.routes.draw do
  resources :projects
  resources :people
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"
  get "/home", to: "home#index", as: "home"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope '/settings' do
    get '/profile', to: "settings#profile", as: "profile"
    get '/password', to: "settings#password", as: "password"
    get '/notifications', to: "settings#notifications", as: "notifications"
  end

  scope '/account' do
    get '/details', to: "accounts#profile", as: "account_details"
  end

end
