Rails.application.routes.draw do
  root "password_panel_dbs#index"

  resources :password_panel_dbs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'chamar', controller: 'password_panel_dbs', action: 'show'
end
