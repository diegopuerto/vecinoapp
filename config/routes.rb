Rails.application.routes.draw do

  mount_devise_token_auth_for 'Usuario', at: '/auth'
  
  resources :usuarios,
   except: [:edit, :new],
   defaults: { format: :json } do
  
   	resources :direcciones,
   	 except: [:edit, :new]

    resources :negocios_propios,
      only: [:index, :create, :destroy],
      controller: 'negocios',
      defaults: { propietario: true }
  end

  resources :direcciones, only: [:destroy, :update], defaults: { format: :json }

  resources :negocios,
   except: [:edit, :new],
   defaults: { format: :json } do

    resources :propietarios,
      only: [:index, :create, :destroy],
      controller: 'usuarios',
      defaults: { negocio_propio: true }
  end

  root 'welcome#index'
end
