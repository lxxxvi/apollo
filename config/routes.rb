Rails.application.routes.draw do
  root to: 'home#show'
  get :home, to: 'home#show'

  resources :polls, except: [:index], param: :custom_id do
    resources :nominees, except: [:index, :show], param: :custom_id
  end
end
