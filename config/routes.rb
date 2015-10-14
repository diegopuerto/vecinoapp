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
	
	resources :pedidos,
   	 except: [:edit, :new],
   	 defaults: { usuario_pedido: true }
	 
  end

  resources :direcciones, only: [:destroy, :update], defaults: { format: :json }

  resources :negocios,
   except: [:edit, :new],
   defaults: { format: :json } do

    resources :propietarios,
      only: [:index, :create, :destroy],
      controller: 'usuarios',
      defaults: { negocio_propio: true }

    resources :pedidos,
       except: [:edit, :new],
       defaults: { format: :json }
   end

  resources :productos,
   except: [:edit, :new],
   defaults: { format: :json } do

    resources :categorias,
      only: [:index, :create, :destroy],
      defaults: { categoria_producto: true }

 
  end

   resources :negocios,
   except: [:edit, :new],
   defaults: { format: :json } do

    resources :productos,
      except: [:edit, :new],
      defaults: { negocio_producto: true }

   end

   resources :categorias,
   except: [:edit, :new],
   defaults: { format: :json }

  root 'welcome#index'
end
