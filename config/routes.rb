Rails.application.routes.draw do
  mount_devise_token_auth_for 'Usuario', at: '/auth'
  resources :usuarios, only: [:index, :show, :destroy], :defaults => { :format => :json }
  root 'welcome#index'
end
