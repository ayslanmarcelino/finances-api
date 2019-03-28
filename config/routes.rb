Rails.application.routes.draw do
  apipie
  namespace :v1 do
    post 'authenticate' => 'authentication#authenticate'

    resources :categories, only: %i[create]
  end
end
