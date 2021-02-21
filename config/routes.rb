Rails.application.routes.draw do
  resources :projects do
    get "/participants", to: "projects/team#index", as: "team"
    get "/notes", to: "projects/notes#index", as: "notes"
    get "/feedback", to: "projects/feedback#index", as: "feedback"
    get "/schedule", to: "projects/schedule#index", as: "schedule"
  end

  resources :people
  resources :account, only: [:update, :edit]
  resources :user, only: [:update, :edit]
  resources :settings, only: [:update, :edit]
  # resources :password, only: [:create, :new]
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"
  get "/home", to: "home#index", as: "home"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope "/settings" do
    # get "/profile", to: "settings#profile", as: "profile"
    # get "/password", to: "settings#password", as: "password"
    # post "/password", to: "settings#password"
    get "/profile", to: "user#profile", as: "profile"
    get "/password", to: "user#password", as: "password"
    patch "/password", to: "user#password_update", as: "update_password"
    get "/notifications", to: "settings#notifications", as: "notifications"
  end

  scope "/admin" do
    get "/details", to: "accounts#profile", as: "account_details"
    get "/roles", to: "accounts#roles", as: "roles"
    get "/disciplines", to: "accounts#disciplines", as: "disciplines"
    get "/clients", to: "accounts#clients", as: "clients"
    get "/peopleTags", to: "accounts#peopletags", as: "peopletags"
    get "/peopleStatus", to: "accounts#peoplestatus", as: "peoplestatus"
    get "/projectTags", to: "accounts#projecttags", as: "projecttags"
    get "/projectStatus", to: "accounts#projectstatus", as: "projectstatus"
    get "/skills", to: "accounts#skills", as: "skills"
    get "/jobProfile", to: "accounts#jobprofile", as: "jobprofile"
  end
end
