Rails.application.routes.draw do
  root to: 'polls#index'

  resources :sessions, only: %i[new destroy]
  resource :authentication_token_requests, only: %i[new create]

  get 'request_token', to: 'authentication_token_requests#new', as: :request_token
  get 'sign_in/:authentication_token', to: 'sessions#new', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :polls, only: %i[index show new create], param: :custom_id do
    resource :voting, only: %i[new create], module: :polls
    get 'vote/:token_value', to: 'polls/votings#new', as: :vote
  end

  namespace :admin do
    resources :polls, only: %i[show update], param: :custom_id do
      resources :nominees, except: %i[show], param: :custom_id, module: :polls
      resources :tokens, only: %i[index new create], param: :custom_id, module: :polls do
        get :unused, on: :collection
      end
      resource :state_change, only: %i[create], module: :polls
    end
  end
end
