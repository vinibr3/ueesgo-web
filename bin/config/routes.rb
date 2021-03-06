Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
 
  get 'pages/index',          to:"pages#index",          as: :home
  get 'pages/mei_entrada',    to:"pages#meia_entrada",   as: :meia_entrada
  get 'pages/noticias',       to:"pages#noticias",       as: :noticias
  get 'pages/autenticacao',   to:"pages#autenticacao",   as: :autenticacao
  get 'pages/contato',        to:"pages#contato",        as: :contato
  get 'pages/login',          to:"pages#login",          as: :login


  resources :estudantes, only: [:show, :update] do 
    resources :carteirinhas, only: [:new, :show, :autenticacao, :create]
  end
  
  post 'estudantes/senha',   to:"estudantes#update_password", as: :alterar_password

  get 'entidades/escolaridades', to:"entidades#escolaridades"
  get 'entidades/cursos', to:"entidades#cursos"

  resources :contatos, only:[:create]

  devise_for :estudantes, path: "auth", controllers: {:omniauth_callbacks=>"estudantes/omniauth_callbacks"},
                          path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', 
                                                                confirmation: 'verification', unlock: 'unblock', 
                                                                registration: 'register', sign_up: 'cmon_let_me_in' }

  # devise_scope :estudante do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  namespace :api, defaults:{format: :json} do
    resources :estudantes, only: [:create, :update], param: :oauth_token do
      resources :carteirinhas, only: [:create]
      get 'carteirinhas', to: 'carteirinhas#show' 
    end
    get 'estudantes/login', to: 'estudantes#login'   
    get 'estudantes/login/facebook', to: 'estudantes#facebook'
    resources :noticias, only:[:index]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
