Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  

  # devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    authenticated do
      root 'admin/users#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  ActiveAdmin.routes(self)

  match 'api/v1/*path', to: 'application#render_404_json', via: :all
  match '*path', to: 'application#render_404', via: :all
end
