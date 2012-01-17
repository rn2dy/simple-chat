SimpleChat::Application.routes.draw do
  match '/pusher/auth' => 'pusher#auth'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' } do
    root :to => 'users/registrations#new'
  end
  
  resources :chat_rooms, :only => [:index, :show, :create] do
    member do
      get 'join'
      post 'send_message'  
      post 'update_nickname'
    end
  end

  match 'chat_rooms' => 'chat_rooms#index', :as => 'user_root'



end
