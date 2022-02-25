Rails.application.routes.draw do
  root "password_panel_dbs#index"

  mount_devise_token_auth_for 'User', at: 'auth'

  resources :password_panel_dbs

  get 'call', to: 'password_panel_dbs#call'
  get 'cancel/:id', to: 'password_panel_dbs#cancel'
  get 'end/:id', to: 'password_panel_dbs#end'
  get 'report/:filter', to: 'password_panel_dbs#report'
  # !rotas de erro!
  get 'end', to: 'password_panel_dbs#end_fail'
  get 'cancel', to: 'password_panel_dbs#cancel_fail'
end
