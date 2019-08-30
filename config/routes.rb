Rails.application.routes.draw do
  root to: 'polls#index'
  get :home, to: 'polls#index'

  resources :polls, param: :custom_id do
    resources :nominees, except: [:index, :show], param: :custom_id
    resources :tokens, only: %i[new create destroy], param: :value
  end
end
