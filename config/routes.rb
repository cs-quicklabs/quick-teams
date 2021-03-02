Rails.application.routes.draw do
  namespace :account do
    resources :roles, except: [:new, :show]
    resources :disciplines, except: [:new, :show]
    resources :skills, except: [:new, :show]
    resources :jobs, except: [:new, :show]
    resources :people_tags, except: [:new, :show]
    resources :project_tags, except: [:new, :show]
    resources :people_statuses, except: [:new, :show]
    resources :project_statuses, except: [:new, :show]
    resources :clients, except: [:new, :show]
  end

  resources :projects do
    resources :schedules
    resources :notes, only: [:index, :show, :create, :destroy], module: "projects"
    resources :feedbacks, only: [:index, :show, :create, :destroy], module: "projects"
    get "/participants", to: "projects/schedule#index", as: "participants"
  end

  resources :people do
    resources :feedbacks, module: "people"
    get "/team", to: "people/team#index"
  end
  resources :user

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static/static#home"
  get "/home", to: "home#index", as: "home"
  get "/schedule", to: "schedules#index", as: "schedules"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope "/settings" do
    get "/profile", to: "user#profile", as: "profile"
    get "/password", to: "user#password", as: "password"
    patch "/password", to: "user#update_password", as: "edit_password"
    get "/notifications", to: "settings#notifications", as: "notifications"
  end

  get "account/details", to: "account/account#index", as: "detail"
  patch "account/:id", to: "account/account#update", as: "update_account"
end
