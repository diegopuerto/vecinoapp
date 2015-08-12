Rails.application.routes.draw do
  mount_devise_token_auth_for 'Usuario', at: '/auth'
  root 'welcome#index'
end
