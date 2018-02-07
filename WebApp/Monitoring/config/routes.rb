Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/server_data/:server_name', to: "api#server_data"
  get 'api/servers'
  root 'home#index'
end
