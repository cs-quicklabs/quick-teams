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
    resources :schedules
    resources :notes, only: [:index, :show, :create, :destroy], module: "projects"
    resources :feedbacks, only: [:index, :show, :create, :destroy], module: "projects"
    get "/participants", to: "projects/schedule#index", as: "participants"
  end

  resources :people do
    resources :feedbacks, module: "people"
    get "/team", to: "people/team#index"
  end
  resources :account, only: [:update, :edit]
  resources :user

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"
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

  scope "/account" do
    get "/details", to: "account#index", as: "detail"
  end
end
