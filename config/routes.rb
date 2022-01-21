Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq-scheduler/web"

  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"

  if %w(development).include?(Rails.env) && defined?(LetterOpenerWeb)
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

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
    resources :tags, only: [:destroy, :index]
    resources :preferences, only: [:index, :update]
    resources :question_categories, except: [:new, :show]
  end

  resources :projects do
    resources :schedules, module: "project"
    resources :notes, module: "project"
    resources :risks, module: "project"
    resources :feedbacks, only: [:index, :show, :create, :destroy], module: "project"
    resources :timesheets, module: "project"
    resources :milestones, module: "project"
    resources :todos, module: "project"
    resources :skills, module: "project"
    resources :reports, module: "project"
    resources :documents, only: [:index, :show, :create, :destroy, :edit, :update], module: "project"
    resources :surveys, module: "project", only: [:index, :show, :destroy]
    resources :kpis, module: "project", only: [:index, :show, :destroy] do
      get "stats", to: "kpis#stats", as: "stats"
    end

    get "/timeline", to: "project/timeline#index", as: "timeline"
  end

  resources :employees do
    resources :schedules, module: "employee"
    resources :feedbacks, module: "employee"
    resources :timesheets, module: "employee"
    resources :goals, module: "employee"
    resources :todos, module: "employee"
    resources :skills, module: "employee"
    resources :nuggets, module: "employee"
    resources :documents, module: "employee"
    resources :reports, module: "employee"
    resources :surveys, module: "employee", only: [:index, :show, :destroy]
    resources :kpis, module: "employee", only: [:index, :show, :destroy] do
      get "stats", to: "kpis#stats", as: "stats"
    end
    get "/team", to: "employee/team#index"
    get "/timeline", to: "employee/timeline#index", as: "timeline"
    get "/show_skills", to: "employee/skills#show_skills", as: "show_skills"
    post "/surveys/:survey_id/assessment", to: "employee/surveys#quick_assessment"
  end
  resources :user
  resources :comments, only: [:edit, :destroy, :update]
  resources :report_comments, only: [:create, :update]
  resources :goal_comments, only: [:create, :update]
  resources :nuggets
  resources :kbs
  resources :kpis
  resources :templates do
    resources :assignees
  end
  resources :surveys do
    resources :questions, module: "survey"
    resources :assignees, module: "survey", as: "assignees"
    resources :attempts, module: "survey" do
      get "questions", to: "attempts#survey_questions", as: "survey_questions"
    end
    get "reports/pdf/:id", to: "survey/reports#pdf", as: "report_pdf"
    get "/attempts/:id/preview", to: "survey/attempts#preview", as: "report_preview"
    patch "/reports/:id/submit", to: "survey/reports#submit", as: "report_submit"
    patch "/reports/:id/download", to: "survey/reports#download", as: "report_download"
    get "/search", to: "search#surveys"
  end

  get "/surveys/:id/clone", to: "surveys#clone", as: "clone_survey"

  devise_for :users, controllers: { registrations: "registrations" }
  post "/register", to: "registrations#create"

  root to: "home#index"
  get "/home", to: "home#index", as: "home"

  get "/schedule", to: "schedules#index", as: "schedules"
  get "/occupancy/:id", to: "schedules#occupancy", as: "schedules_occupancy"
  get "/occupancy", to: "schedules#occupancy", as: "account_occupancy"

  get "search/people-projects", to: "search#people_projects"
  get "/search/employee/skills", to: "search#employee_skills"
  get "/search/project/skills", to: "search#project_skills"
  get "/search/documents", to: "search#documents"
  get "/search/surveys", to: "search#surveys"
  get :goals, controller: :home
  get :events, controller: :home

  scope "/settings" do
    get "/profile", to: "user#profile", as: "profile"
    get "/password", to: "user#password", as: "setting_password"
    patch "/password", to: "user#update_password", as: "edit_password"
    get "/preferences", to: "user#preferences", as: "user_preferences"
  end

  # if you change something in reports path please check stats path are not broken in project/employee timsheets, as they are hardcoded.
  scope "report" do
    get "/timesheets", to: "report/timesheets#index", as: "timesheets_reports"
    get "/employees", to: "report/employees#index", as: "employees_reports"
    get "/projects", to: "report/projects#index", as: "projects_reports"
    get "/risks", to: "report/risks#index", as: "projects_risks_reports"

    get "/goals", to: "report/goals#index", as: "goals_reports"
    get "/goals/open", to: "report/goals#open", as: "open_goals_reports"
    get "/schedules/available", to: "report/schedules#available", as: "available_schedules_reports"
    get "/schedules/overburdened", to: "report/schedules#overburdened", as: "overburdened_schedules_reports"
    get "/schedules/shared", to: "report/schedules#shared", as: "shared_schedules_reports"
    get "/schedules/next", to: "report/schedules#available_next_month", as: "available_next_month_schedules_reports"
    get "/todos/my-pending-todos", to: "report/todos#my_pending_todos", as: "my_pending_todos"
    get "/todos/pending-todos", to: "report/todos#pending_todos", as: "pending_todos"
    get "/todos/pending-todos-all", to: "report/todos#all_pending_todos", as: "all_pending_todos"
    get "/todos/recently-added", to: "report/todos#recently_added_todos", as: "recently_added_todos"
    get "/todos/recently-finished", to: "report/todos#recently_finished_todos", as: "recently_finished_todos"
    get "/skills", to: "report/skills#index", as: "skills_reports"
    get "/nuggets", to: "report/nuggets#index", as: "nuggets_reports"
    get "/kbs", to: "report/kbs#index", as: "kbs_reports"
    get "/kpis", to: "report/kpis#index", as: "kpis_reports"
    get "/reports", to: "report/reports#index", as: "report_reports"
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
  delete "/", to: redirect("/users/sign_in", status: 303)
end
