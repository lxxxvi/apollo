Rails.application.routes.draw do
  root to: 'polls#index'
  get :home, to: 'polls#index'

  resources :sessions, only: %i[new destroy]
  resource :authentication_token_requests, only: %i[new create]

  get 'request_token', to: 'authentication_token_requests#new', as: :request_token
  get 'sign_in/:authentication_token', to: 'sessions#new', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :polls, param: :custom_id do
    resources :nominees, except: [:index, :show], param: :custom_id
    resources :tokens, only: %i[new create destroy], param: :value

    resource :publishment, only: %i[create], module: :polls
  end
end
