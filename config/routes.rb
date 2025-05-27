Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
      resources :word_types
      devise_for :users,
                 path: "",
                 path_names: {
                   sign_in: "login",
                   sign_out: "logout",
                   registration: "signup"
                 },
                 controllers: {
                   sessions: "api/v1/sessions",
                   registrations: "api/v1/registrations"
                 },
                 defaults: { format: :json }

      resources :lessons do
        resources :vocabulary_entries
      end

      resources :vocabulary_entries, except: [ :new, :edit ]

      get "me", to: "base#me"
    end
  end
end
