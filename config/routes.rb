Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'kuvera#index'
  resources :kuvera
  get '/clear_session' => 'kuvera#clear_session'
end
