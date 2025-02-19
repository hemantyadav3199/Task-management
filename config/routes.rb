Rails.application.routes.draw do
  post '/register', to: 'authentication#register'
  post '/login', to: 'authentication#login'
  
  resources :tasks, except: %i[new edit]
end
