Rails.application.routes.draw do
  root "password_panel_dbs#index"

  resources :password_panel_dbs, :default => {format: :json}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'chamar', to: 'password_panel_dbs#chamar'
  get 'cancel/:id', to: 'password_panel_dbs#cancel'
end
