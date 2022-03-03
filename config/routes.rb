Rails.application.routes.draw do
  root "password_panel_dbs#index"

  resources :password_panel_dbs

  get 'call', to: 'password_panel_dbs#call'
  get 'cancel/:id', to: 'password_panel_dbs#cancel'
  get 'end/:id', to: 'password_panel_dbs#end'
  get 'report', to: 'password_panel_dbs#report'
  # get 'clothing/:sex(/:option1)(/:option2)', to: 'password_panel_dbs#opcao'
  # !rotas de erro!
  get 'end', to: 'password_panel_dbs#end_fail'
  get 'cancel', to: 'password_panel_dbs#cancel_fail'
end
