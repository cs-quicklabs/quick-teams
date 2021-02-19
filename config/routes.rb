Rails.application.routes.draw do
  resources :roles, path: "/account/roles"
  resources :disciplines, path: "/account/disciplines"
  resources :skills, path: "/account/skills"
  resources :jobs, path: "/account/jobs"
  resources :people_tags, path: "/account/people-tags"
  resources :project_tags, path: "/account/project-tags"
  resources :people_statuses, path: "/account/people-statuses"
  resources :project_statuses, path: "/account/project-statuses"
  resources :clients, path: "/account/clients"
  resources :account, only: [:edit, :update]

  resources :projects do
    get "/participants", to: "projects/team#index", as: "team"
    get "/notes", to: "projects/notes#index", as: "notes"
    get "/feedback", to: "projects/feedback#index", as: "feedback"
    get "/schedule", to: "projects/schedule#index", as: "schedule"
  end

  resources :people
  resources :account, only: [:update, :edit]
  resources :user, only: [:update, :edit]

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"
  get "/home", to: "home#index", as: "home"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope "/settings" do
    get "/profile", to: "settings#profile", as: "profile"
    get "/password", to: "settings#password", as: "password"
    get "/notifications", to: "settings#notifications", as: "notifications"
  end

  scope "/account" do
    get "/details", to: "account#index", as: "detail"
  end
end
