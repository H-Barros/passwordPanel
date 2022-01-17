Rails.application.routes.draw do
  root "password_panel_dbs#index"

  resources :password_panel_dbs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'call/:pref', to: 'password_panel_dbs#call'
  get 'cancel/:id', to: 'password_panel_dbs#cancel'
  get 'end/:id', to: 'password_panel_dbs#end'
  get 'call/', to: 'password_panel_dbs#callFail'
  get 'report/:filter', to: 'password_panel_dbs#report'
end
