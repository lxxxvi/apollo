Rails.application.routes.draw do
  root to: 'polls#index'
  get :home, to: 'polls#index'

  resources :sessions, only: %i[new destroy]
  resource :authentication_token_requests, only: %i[new create]

  get 'request_token', to: 'authentication_token_requests#new', as: :request_token
  get 'sign_in/:authentication_token', to: 'sessions#new', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :polls, except: %i[destroy], param: :custom_id do
    resources :nominees, except: %i[index show], param: :custom_id, module: :polls
    resources :tokens, only: %i[new create destroy], param: :value, module: :polls
    resource :publishment, only: %i[create], module: :polls
    resource :start, only: %i[create], module: :polls
    resource :closing, only: %i[create], module: :polls
    resource :archiving, only: %i[create], module: :polls
    resource :deletion, only: %i[create], module: :polls
    resource :voting, only: %i[create], module: :polls

    get :manage, on: :member
    get 'vote/:token', to: 'polls#vote', as: :vote, on: :member
  end
end
