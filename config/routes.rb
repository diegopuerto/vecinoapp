Rails.application.routes.draw do

  mount_devise_token_auth_for 'Usuario', at: '/auth'
  
  resources :usuarios,
   except: [:edit, :new],
   defaults: { format: :json } do
  
   	resources :direcciones,
   	 except: [:edit, :new],
   	 defaults: { format: :json }
  
  end

  resources :direcciones, only: [:destroy, :update], defaults: { format: :json }
  
  root 'welcome#index'
end
