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
    resources :schedules, module: "project"
    resources :notes, only: [:index, :show, :create, :destroy], module: "project"
    resources :feedbacks, only: [:index, :show, :create, :destroy], module: "project"
    resources :todos, module: "project"
    resources :timesheets, module: "project"
    resources :milestones, module: "project"
    get "/timeline", to: "project/timeline#index", as: "timeline"
  end

  resources :employees do
    resources :schedules, module: "employee"
    resources :feedbacks, module: "employee"
    resources :timesheets, module: "employee"
    resources :goals, module: "employee"
    get "/team", to: "employee/team#index"
    get "/timeline", to: "employee/timeline#index", as: "timeline"
  end
  resources :user
  resources :comments

  devise_for :users

  root to: "static/static#home"
  get "/home", to: "home#index", as: "home"
  get "/contact", to: "static/static#contact"
  get "/pricing", to: "static/static#pricing"

  get "/schedule", to: "schedules#index", as: "schedules"
  get :search, controller: :search

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope "/settings" do
    get "/profile", to: "user#profile", as: "profile"
    get "/password", to: "user#password", as: "setting_password"
    patch "/password", to: "user#update_password", as: "edit_password"
    get "/notifications", to: "settings#notifications", as: "notifications"
  end

  scope "report" do
    get "/timesheets", to: "report/timesheets#index", as: "timesheets_reports"
    get "/employees", to: "report/employees#index", as: "employees_reports"
    get "/goals", to: "report/goals#index", as: "goals_reports"
  end
  get "/reports", to: "reports#index", as: "reports"

  scope "archive" do
    get "/projects", to: "projects#archived", as: "archived_projects"
    get "/project/:id", to: "projects#archive_project", as: "archive_project"
    get "/project/:id/restore", to: "projects#unarchive_project", as: "unarchive_project"
    get "/employees", to: "employees#deactivated", as: "deactivated_users"
    get "/employees/:id", to: "employees#deactivate_user", as: "deactivate_user"
    get "/employees/:id/restore", to: "employees#activate_user", as: "activate_user"
  end

  get "account/details", to: "account/account#index", as: "detail"
  patch "account/:id", to: "account/account#update", as: "update_account"
end
